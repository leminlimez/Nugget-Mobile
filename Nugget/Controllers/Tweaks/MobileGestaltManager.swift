//
//  MobileGestaltManager.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import Foundation

class MobileGestaltManager {
    static let shared = MobileGestaltManager()
    
    private var GestaltChanges: [String: Any] = [:]
    
    func loadMobileGestaltFile() throws {
        let fm = FileManager.default
        
        let docsURL = URL.tweaksDirectory
        let gestaltURL = docsURL.appendingPathComponent("com.apple.MobileGestalt.plist")
//        let gestaltBackupURL = docsURL.appendingPathComponent("com.apple.MobileGestalt-BACKUP.plist")
        if fm.fileExists(atPath: gestaltURL.path) {
            return
        }
//        if !fm.fileExists(atPath: gestaltBackupURL.path) {
        let gestaltData = try Data(contentsOf: URL(fileURLWithPath: "/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches/com.apple.MobileGestalt.plist"))
        try gestaltData.write(to: gestaltURL)
//            try gestaltData.write(to: gestaltBackupURL)
//        }
    }
    
    func setGestaltValue(key: String, value: Any) {
//        let gestaltURL = URL.documents.appendingPathComponent("com.apple.MobileGestalt.plist")
//        let stringsData = try Data(contentsOf: gestaltURL)
//        
//        // open plist
//        let plist = try! PropertyListSerialization.propertyList(from: stringsData, options: [], format: nil) as! [String: Any]
//        func changeDictValue(_ dict: [String: Any], _ key: String, _ value: Any) -> [String: Any] {
//            var newDict = dict
//            for (k, v) in dict {
//                if k == key {
//                    newDict[k] = value
//                } else if let subDict = v as? [String: Any] {
//                    newDict[k] = changeDictValue(subDict, key, value)
//                }
//            }
//            return newDict
//        }
//        
//        // modify value
//        var newPlist = plist
//        newPlist = changeDictValue(newPlist, key, value)
//        
//        // overwrite the plist
//        let newData = try PropertyListSerialization.data(fromPropertyList: newPlist, format: .binary, options: 0)
//        try newData.write(to: gestaltURL)
        self.GestaltChanges[key] = value
    }
    func setGestaltValues(keys: [String], values: [Any]) {
        for keyIdx in 0...(keys.count - 1) {
            self.setGestaltValue(key: keys[keyIdx], value: values[keyIdx])
        }
    }
    
    func removeGestaltValue(key: String) {
        self.GestaltChanges.removeValue(forKey: key)
    }
    func removeGestaltValues(keys: [String]) {
        for key in keys {
            self.removeGestaltValue(key: key)
        }
    }
    
    func getEnabledTweaks() -> [String: Any] {
        return self.GestaltChanges
    }
    
    func getPlistValue(_ dict: [String: Any], key: String) -> Any? {
        for (k, v) in dict {
            if k == key {
                return v
            } else if let subDict = v as? [String: Any] {
                let subValue: Any? = getPlistValue(subDict, key: key)
                if subValue != nil {
                    return subValue
                }
            }
        }
        return nil
    }
    
    func getDefaultDeviceSubtype() throws -> Int {
        let gestaltData = try Data(contentsOf: URL(fileURLWithPath: "/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches/com.apple.MobileGestalt.plist"))
        let plist = try PropertyListSerialization.propertyList(from: gestaltData, options: [], format: nil) as! [String: Any]
        return getPlistValue(plist, key: "ArtworkDeviceSubType") as? Int ?? -1
    }
    
    func setPlistValue(_ dict: [String: Any], key: String, value: Any) -> ([String: Any], Bool) {
        var newDict = dict
        var changed = false
        for (k, v) in dict {
            if k == key {
                newDict[k] = value
                changed = true
                break
            } else if let subDict = v as? [String: Any] {
                (newDict[k], changed) = self.setPlistValue(subDict, key: key, value: value)
            }
        }
        return (newDict, changed)
    }
    
    func apply() throws -> Data? {
        if self.GestaltChanges.isEmpty {
            return nil
        }
        let gestaltURL = URL.tweaksDirectory.appendingPathComponent("com.apple.MobileGestalt.plist")
        let gestaltData = try Data(contentsOf: gestaltURL)
        var plist = try PropertyListSerialization.propertyList(from: gestaltData, options: [], format: nil) as! [String: Any]
        
        for key in self.GestaltChanges.keys {
            if key != "ArtworkDeviceSubType" || self.GestaltChanges[key] as? Int ?? -1 != -1 {
                var changed = false
                (plist, changed) = setPlistValue(plist, key: key, value: self.GestaltChanges[key] as Any)
                if !changed {
                    // not found, change in CacheExtra
                    if var newPlist = plist["CacheExtra"] as? [String: Any] {
                        newPlist[key] = self.GestaltChanges[key]
                    }
                }
            }
        }
        
        return try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
//        return FileToRestore.init(contents: newData, restorePath: "/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches/", restoreName: "com.apple.MobileGestalt.plist")
    }
    
    func reset() throws -> Data {
        let fm = FileManager.default
        let gestaltURL = URL.tweaksDirectory.appendingPathComponent("com.apple.MobileGestalt.plist")
        try? fm.removeItem(at: gestaltURL)
        return Data()
//        return FileToRestore.init(contents: Data(), restorePath: "/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches/", restoreName: "com.apple.MobileGestalt.plist")
    }
}
