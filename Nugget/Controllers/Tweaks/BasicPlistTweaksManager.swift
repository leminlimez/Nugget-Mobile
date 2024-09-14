//
//  BasicPlistTweaksManager.swift
//  Nugget
//
//  Created by lemin on 9/13/24.
//

import Foundation

//protocol PlistTweak: Identifiable {
//    var id: UUID { get set }
//    var key: String { get set }
//    var title: String { get set }
//    var fileLocation: FileLocation { get set }
//    var modified: Bool { get set }
//}
//
//struct ToggleOption: PlistTweak {
//    var id = UUID()
//    var key: String
//    var title: String
//    var fileLocation: FileLocation
//    var modified: Bool = false
//    var value: Bool = false
//    var invertValue: Bool = false
//}
//
//struct TextOption: PlistTweak {
//    var id = UUID()
//    var key: String
//    var title: String
//    var fileLocation: FileLocation
//    var modified: Bool = false
//    var value: String = ""
//    var placeholder: String
//}

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
    var modified: Bool = false
    
    var boolValue: Bool = false
    var invertValue: Bool = false
    
    var stringValue: String = ""
    var placeholder: String = ""
}

class BasicPlistTweaksManager: ObservableObject {
    static var managers: [BasicPlistTweaksManager] = []
    
    var title: String
    @Published var tweaks: [PlistTweak]
    
    init(title: String, tweaks: [PlistTweak]) {
        self.title = title
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
    
    static func getManager(for title: String, tweaks: [PlistTweak]) -> BasicPlistTweaksManager {
        // have tweaks as an input in case it doesn't exist
        for (i, manager) in managers.enumerated() {
            if manager.title == title {
                return managers[i]
            }
        }
        // it does not exist, make a new manager and return that
        var newManager = BasicPlistTweaksManager(title: title, tweaks: tweaks)
        managers.append(newManager)
        return newManager
    }
    
    func setTweakValue(_ tweak: PlistTweak, newVal: Any) {
        let fileURL = getURLFromFileLocation(tweak.fileLocation)
        let data = try? Data(contentsOf: fileURL)
        var plist: [String: Any] = [:]
        if let data = data, let readPlist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] {
            plist = readPlist
        }
        plist[tweak.key] = newVal
        guard let newData = try? PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0) else {return}
        guard ((try? newData.write(to: fileURL)) != nil) else {return}
        for (i, t) in self.tweaks.enumerated() {
            if t.id == tweak.id {
//                if var toggleOp = self.tweaks[i] as? ToggleOption, let newVal = newVal as? Bool {
//                    toggleOp.value =
//                }
                self.tweaks[i].modified = true
                break;
            }
        }
    }
    
    func apply() -> [FileLocation: Data] {
        var changedLocations: [FileLocation] = []
        // add the location of where to restore
        for tweak in self.tweaks {
            print("Tweak: \(tweak.title)\nmodified: \(tweak.modified)\nvalue: \(tweak.tweakType == .text ? tweak.stringValue : String(tweak.boolValue))\n\n")
            if tweak.modified && !changedLocations.contains(tweak.fileLocation) {
                changedLocations.append(tweak.fileLocation)
            }
        }
        // create a dictionary of data to restore
        var changes: [FileLocation: Data] = [:]
        for changedLocation in changedLocations {
            guard let data = try? Data(contentsOf: getURLFromFileLocation(changedLocation)) else { continue }
            changes[changedLocation] = data
        }
        return changes
    }
    
    func reset() -> [FileLocation: Data] {
        var changedLocations: [FileLocation] = []
        // add the location of where to restore
        for tweak in self.tweaks {
            if !changedLocations.contains(tweak.fileLocation) {
                changedLocations.append(tweak.fileLocation)
            }
        }
        // create a dictionary of data to restore
        var changes: [FileLocation: Data] = [:]
        let emptyPlist: [String: Any] = [:]
        let emptyData = try? PropertyListSerialization.data(fromPropertyList: emptyPlist, format: .xml, options: 0)
        for changedLocation in changedLocations {
            changes[changedLocation] = emptyData
        }
        return changes
    }
    
    static func applyAll() -> [FileLocation: Data] {
        var changes: [FileLocation: Data] = [:]
        for manager in managers {
            changes.merge(manager.apply()) { originalData, newData in
                // TODO: Merge the 2 files
                return originalData // prioritize original data for now
            }
        }
        return changes
    }
    
    static func resetAll() -> [FileLocation: Data] {
        // TODO: combine with applyAll()
        var changes: [FileLocation: Data] = [:]
        for manager in managers {
            changes.merge(manager.reset()) { originalData, newData in
                // TODO: Merge the 2 files
                return originalData // prioritize original data for now
            }
        }
        return changes
    }
}
