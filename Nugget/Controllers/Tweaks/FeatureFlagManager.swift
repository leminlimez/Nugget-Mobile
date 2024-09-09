//
//  FeatureFlagManager.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import Foundation

enum FeatureFlagCategory: String {
    case SpringBoard = "SpringBoard"
    case Photos = "Photos"
}

struct FeatureFlag: Identifiable {
    let id = UUID()
    let category: FeatureFlagCategory
    let flags: [String]
    var is_list: Bool = true
    var inverted: Bool = false
}

class FeatureFlagManager {
    static let FFManager = FeatureFlagManager()
    
    private var EnabledFlags: [FeatureFlag] = []
    
    public func enableFlag(_ flag: FeatureFlag) {
        self.EnabledFlags.append(flag)
    }
    public func removeFlag(_ flag: FeatureFlag) {
        for (i, EnabledFlag) in self.EnabledFlags.enumerated() {
            if EnabledFlag.id == flag.id {
                self.EnabledFlags.remove(at: i)
                return
            }
        }
    }
    
    public func apply() throws -> Data {
        var plist: [String: Any] = [:]
        for EnabledFlag in self.EnabledFlags {
            let value = !EnabledFlag.inverted
            var flagList: [String: Any] = [:]
            for flag in EnabledFlag.flags {
                if EnabledFlag.is_list {
                    flagList[flag] = ["Enabled": value]
                } else {
                    flagList[flag] = value
                }
            }
            plist[EnabledFlag.category.rawValue] = flagList
        }
        // convert to data and return
        return try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
    }
    
    public func reset() throws -> Data {
        let plist: [String: Any] = [:]
        return try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
    }
}
