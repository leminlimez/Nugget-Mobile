//
//  BasicPlistTweaksManager.swift
//  Nugget
//
//  Created by lemin on 9/13/24.
//

import Foundation

enum PlistTweakType {
    case toggle
    case text
}

struct PlistTweak: Identifiable {
    var id = UUID()
    var key: String
    var title: String
    var fileLocation: FileLocation
    var tweakType: PlistTweakType // this is very stupid but SwiftUI hard typing doesn't like the protocols
    
    var boolValue: Bool = false
    var invertValue: Bool = false
    
    var stringValue: String = ""
    var placeholder: String = ""
}

class BasicPlistTweaksManager: ObservableObject {
    static var managers: [BasicPlistTweaksManager] = []
    
    var page: TweakPage
    @Published var tweaks: [PlistTweak]
    
    init(page: TweakPage, tweaks: [PlistTweak]) {
        self.page = page
        self.tweaks = tweaks
        
        // set the tweak values if they exist
        for (i, tweak) in self.tweaks.enumerated() {
            guard let data = try? Data(contentsOf: getURLFromFileLocation(tweak.fileLocation)) else { continue }
            guard let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else { continue }
            if let val = plist[tweak.key] {
                if let val = val as? Bool {
                    self.tweaks[i].boolValue = val
                } else if let val = val as? String {
                    self.tweaks[i].stringValue = val
                }
            }
        }
    }
    
    static func getManager(for page: TweakPage, tweaks: [PlistTweak]) -> BasicPlistTweaksManager {
        // have tweaks as an input in case it doesn't exist
        for manager in managers {
            if manager.page == page {
                return manager
            }
        }
        // it does not exist, make a new manager and return that
        let newManager = BasicPlistTweaksManager(page: page, tweaks: tweaks)
        managers.append(newManager)
        return newManager
    }
    
    func setTweakValue(_ tweak: PlistTweak, newVal: Any) throws {
        let fileURL = getURLFromFileLocation(tweak.fileLocation)
        let data = try? Data(contentsOf: fileURL)
        var plist: [String: Any] = [:]
        if let data = data, let readPlist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] {
            plist = readPlist
        }
        plist[tweak.key] = newVal
        let newData = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
        try newData.write(to: fileURL)
    }
    
    func apply() -> [FileLocation: Data] {
        // create a dictionary of data to restore
        var changes: [FileLocation: Data] = [:]
        for tweak in self.tweaks {
            if changes[tweak.fileLocation] == nil {
                guard let data = try? Data(contentsOf: getURLFromFileLocation(tweak.fileLocation)) else { continue }
                changes[tweak.fileLocation] = data
            }
        }
        return changes
    }
    
    func reset() -> [FileLocation: Data] {
        var changes: [FileLocation: Data] = [:]
        // add the location of where to restore
        for tweak in self.tweaks {
            if changes[tweak.fileLocation] == nil {
                // set it with empty data
                changes[tweak.fileLocation] = Data()
            }
        }
        return changes
    }
    
    static func applyAll(resetting: Bool) -> [FileLocation: Data] {
        var changes: [FileLocation: Data] = [:]
        for manager in managers {
            changes.merge(resetting ? manager.reset() : manager.apply()) { (current, new) in
                // combine the 2 plists
                do {
                    guard let currentPlist = try PropertyListSerialization.propertyList(from: current, options: [], format: nil) as? [String: Any] else { return current }
                    guard let newPlist = try PropertyListSerialization.propertyList(from: new, options: [], format: nil) as? [String: Any] else { return current }
                    // combine them
                    let mergedPlist = HelperFuncs.deepMerge(currentPlist, newPlist)
                    return try PropertyListSerialization.data(fromPropertyList: mergedPlist, format: .binary, options: 0)
                } catch {
                    return current
                }
            }
        }
        return changes
    }
    
    static func applyPage(_ page: TweakPage, resetting: Bool) -> [FileLocation: Data] {
        for manager in self.managers {
            if manager.page == page {
                return resetting ? manager.reset() : manager.apply()
            }
        }
        // there is no manager, just apply blank
        return [:]
    }
}
