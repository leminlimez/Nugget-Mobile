//
//  ApplyHandler.swift
//  Nugget
//
//  Created by lemin on 9/11/24.
//

import Foundation

class ApplyHandler {
    static let shared = ApplyHandler()
    
    let gestaltManager = MobileGestaltManager.shared
    let ffManager = FeatureFlagManager.shared
    let statusManager = StatusManagerSwift.shared
    
    func apply(resetting: Bool, reboot: Bool) {
        var filesToRestore: [FileToRestore] = []
        do {
            // Apply mobilegestalt changes
            var mobileGestaltData: Data? = nil
            if resetting {
                mobileGestaltData = try gestaltManager.reset()
            } else {
                mobileGestaltData = try gestaltManager.apply()
            }
            if let mobileGestaltData = mobileGestaltData {
                filesToRestore.append(FileToRestore(contents: mobileGestaltData, path: "/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches/com.apple.MobileGestalt.plist"))
            }
            
            // Apply status bar
            var statusBarData: Data = Data()
            if !resetting {
                statusBarData = try statusManager.apply()
            }
            filesToRestore.append(FileToRestore(contents: statusBarData, path: "HomeDomain/Library/SpringBoard/statusBarOverrides"))
            
            // Apply feature flag changes
            var ffData: Data? = nil
            if resetting {
                ffData = try ffManager.reset()
            } else {
                ffData = try ffManager.apply()
            }
            if let ffData = ffData {
                filesToRestore.append(FileToRestore(contents: ffData, path: "/var/preferences/FeatureFlags/Global.plist"))
            }
            if !filesToRestore.isEmpty {
                RestoreManager.shared.restoreFiles(filesToRestore, reboot: reboot)
            } else {
                print("No files to restore!")
                return
            }
        } catch {
            print(error.localizedDescription)
            return
        }
    }
}
