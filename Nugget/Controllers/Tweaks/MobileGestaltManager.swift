//
//  MobileGestaltManager.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import Foundation
import UIKit

class MobileGestaltManager {
    static let shared = MobileGestaltManager()
    
    private var GestaltChanges: [String: Any] = [:]
    var deviceSubType: Int
    @Published var deviceModel: String?
    
    init() {
        deviceSubType = UserDefaults.standard.integer(forKey: "DeviceSubType")
        if deviceSubType == -1 || deviceSubType == 0 {
            if let newSubType = try? getDefaultDeviceSubtype() {
                UserDefaults.standard.setValue(newSubType, forKey: "DeviceSubType")
                deviceSubType = newSubType
            }
        }
        deviceModel = UserDefaults.standard.string(forKey: "DeviceModel")
        if deviceModel == nil {
            if let newModel = try? getDefaultDeviceModel() {
                deviceModel = newModel
            }
        }
    }
    
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
    
    func hasGestaltChanges() -> Bool {
        return !self.GestaltChanges.isEmpty
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
    
    func getDefaultDeviceModel() throws -> String? {
        let gestaltData = try Data(contentsOf: URL(fileURLWithPath: "/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches/com.apple.MobileGestalt.plist"))
        let plist = try PropertyListSerialization.propertyList(from: gestaltData, options: [], format: nil) as! [String: Any]
        return getPlistValue(plist, key: "h9jDsbgj7xIVeIQ8S3/X3Q") as? String
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
    
    func getRdarFixMode() -> Int {
        /* values for rdar fix:
         * 0 = Disable
         * 1 = rdar fix
         * 2 = status bar fix
         */
        switch UIDevice().type {
        case .iPhoneXR, .iPhoneXS, .iPhone11, .iPhone11Pro:
            return 1
        case .iPhone12, .iPhone12Pro, .iPhone13, .iPhone13Pro, .iPhone14:
            return 2
        case .iPhoneSE, .iPhoneSE2, .iPhoneSE3:
            return 3
        default:
            return 0
        }
    }
    func getRdarFixTitle(mode: Int) -> String {
        if mode == 1 || mode == 3 {
            return "Fix rdar"
        } else if mode == 2 {
            return "DI status bar fix"
        }
        return "hide"
    }
    
    func getRdarFixTitle() -> String {
        getRdarFixTitle(mode: getRdarFixMode())
    }
    
    func apply() throws -> Data? {
        if self.GestaltChanges.isEmpty {
            return nil
        }
        let gestaltData = try Data(contentsOf: URL(fileURLWithPath: "/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches/com.apple.MobileGestalt.plist"))
        var plist = try PropertyListSerialization.propertyList(from: gestaltData, options: [], format: nil) as! [String: Any]
        
        if var newPlist = plist["CacheExtra"] as? [String: Any] {
            
            for key in self.GestaltChanges.keys {
                if key != "IOMobileGraphicsFamily" && (key != "ArtworkDeviceSubType" || self.GestaltChanges[key] as? Int ?? -1 != -1) {
                    var changed = false
                    (newPlist, changed) = setPlistValue(newPlist, key: key, value: self.GestaltChanges[key] as Any)
                    if !changed {
                        // not found, change in CacheExtra
                        newPlist[key] = self.GestaltChanges[key]
                    }
                }
            }
            plist["CacheExtra"] = newPlist
        }
        
        return try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
//        return FileToRestore.init(contents: newData, restorePath: "/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches/", restoreName: "com.apple.MobileGestalt.plist")
    }
    
    func applyRdarFix() -> Data? {
        /* values for rdar fix:
         * 0 = Disable
         * 1 = rdar fix
         * 2 = status bar fix
         */
        if let val = self.GestaltChanges["IOMobileGraphicsFamily"] as? Int {
            if val == 1 || val == 3 {
                let plist: [String: Int] = [
                    "canvas_height": 1791,
                    "canvas_width": 828
                ]
                return try? PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
            } else if val == 2 {
                // get the resolution needed based on the device subtype
                var new_canvas: CGSize = CGSize(width: 1320, height: 2868)
                if let subtype = self.GestaltChanges["ArtworkDeviceSubType"] as? Int {
                    switch subtype {
                    case 2556:
                        new_canvas = CGSize(width: 1179, height: 2556)
                    case 2796, 2976:
                        new_canvas = CGSize(width: 1290, height: 2796)
                    case 2622:
                        new_canvas = CGSize(width: 1206, height: 2622)
                    case 2868:
                        new_canvas = CGSize(width: 1320, height: 2868)
                    default:
                        print("No resolution for subtype \(subtype)!")
                    }
                }
                let plist: [String: Int] = [
                    "canvas_height": Int(new_canvas.height),
                    "canvas_width": Int(new_canvas.width)
                ]
                return try? PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
            } else {
                let plist: [String: Int] = [:]
                return try? PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
            }
        }
        return nil
    }
    
    func getRdarMode() -> Int? {
        if let mode = self.GestaltChanges["IOMobileGraphicsFamily"] as? Int {
            return mode
        }
        return nil
    }
    
    func reset() -> Data {
        let gestaltURL = URL.tweaksDirectory.appendingPathComponent("com.apple.MobileGestalt.plist")
        try? FileManager.default.removeItem(at: gestaltURL)
        UserDefaults.standard.removeObject(forKey: "DeviceSubType")
        return Data()
//        return FileToRestore.init(contents: Data(), restorePath: "/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches/", restoreName: "com.apple.MobileGestalt.plist")
    }
}
