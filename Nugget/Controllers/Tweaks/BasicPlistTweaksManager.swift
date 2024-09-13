//
//  BasicPlistTweaksManager.swift
//  Nugget
//
//  Created by lemin on 9/13/24.
//

import Foundation

protocol PlistTweak: Identifiable {
    var id: UUID { get set }
    var key: String { get set }
    var title: String { get set }
    var fileLocation: FileLocation { get set }
    var modified: Bool { get set }
}

struct ToggleOption: PlistTweak {
    var id = UUID()
    var key: String
    var title: String
    var fileLocation: FileLocation
    var modified: Bool = false
    var value: Bool = false
    var invertValue: Bool = false
}

struct TextOption: PlistTweak {
    var id = UUID()
    var key: String
    var title: String
    var fileLocation: FileLocation
    var modified: Bool = false
    var value: String = ""
}

class BasicPlistTweaksManager {
    static var managers: [BasicPlistTweaksManager] = []
    
    var title: String
    var tweaks: [any PlistTweak]
    
    init(title: String, tweaks: [any PlistTweak]) {
        self.title = title
        self.tweaks = tweaks
        
        // set the tweak values if they exist
        for (i, tweak) in self.tweaks.enumerated() {
            guard let data = try? Data(contentsOf: getURLFromFileLocation(tweak.fileLocation)) else { continue }
            guard let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else { continue }
            if let val = plist[tweak.key] {
                if var toggleOp = self.tweaks[i] as? ToggleOption, let val = val as? Bool {
                    toggleOp.value = val
                } else if var textOp = self.tweaks[i] as? TextOption, let val = val as? String {
                    textOp.value = val
                }
            }
        }
    }
    
    static func getManager(for title: String, tweaks: [any PlistTweak]) -> BasicPlistTweaksManager {
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
    
    func setTweakValue(_ tweak: any PlistTweak, newVal: Any) {
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
    
    // TODO: Remove tweaks
//    func reset() throws -> [FileLocation: Data] {
//        return
//    }
    
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
}
