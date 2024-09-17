//
//  ApplyHandler.swift
//  Nugget
//
//  Created by lemin on 9/11/24.
//

import Foundation

enum TweakPage: String, CaseIterable {
    case MobileGestalt = "Mobilegestalt"
    case FeatureFlags = "Feature Flags"
    case StatusBar = "Status Bar"
    case SpringBoard = "SpringBoard"
    case Internal = "Internal Options"
}

class ApplyHandler: ObservableObject {
    static let shared = ApplyHandler()
    
    let gestaltManager = MobileGestaltManager.shared
    let ffManager = FeatureFlagManager.shared
    let statusManager = StatusManagerSwift.shared
    
    @Published var enabledTweaks: [TweakPage] = []
    
    func getTweakPageData(_ tweakPage: TweakPage, resetting: Bool) throws -> [FileToRestore] {
        var files: [FileToRestore] = []
        switch tweakPage {
        case .MobileGestalt:
            // Apply mobilegestalt changes
            var mobileGestaltData: Data? = nil
            var resChangerData: Data? = nil
            if resetting {
                mobileGestaltData = try gestaltManager.reset()
                resChangerData = Data()
            } else {
                mobileGestaltData = try gestaltManager.apply()
                resChangerData = gestaltManager.applyRdarFix()
            }
            if let mobileGestaltData = mobileGestaltData {
                files.append(FileToRestore(contents: mobileGestaltData, path: "/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches/com.apple.MobileGestalt.plist"))
            }
            if let resChangerData = resChangerData {
                files.append(FileToRestore(contents: resChangerData, path: FileLocation.resolution.rawValue))
            }
        case .FeatureFlags:
            // Apply feature flag changes (iOS 18.0+ only)
            var ffData: Data = Data()
            if resetting {
                ffData = try ffManager.reset()
            } else {
                ffData = try ffManager.apply()
            }
            files.append(FileToRestore(contents: ffData, path: "/var/preferences/FeatureFlags/Global.plist"))
        case .StatusBar:
            // Apply status bar
            var statusBarData: Data = Data()
            if resetting {
                statusBarData = try statusManager.reset()
            } else {
                statusBarData = try statusManager.apply()
            }
            files.append(FileToRestore(contents: statusBarData, path: "HomeDomain/Library/SpringBoard/statusBarOverrides"))
        case .SpringBoard, .Internal:
            // Apply basic plist changes
            var basicPlistTweaksData: [FileLocation: Data] = BasicPlistTweaksManager.applyPage(tweakPage, resetting: resetting)
            for file_path in basicPlistTweaksData.keys {
                files.append(FileToRestore(contents: basicPlistTweaksData[file_path]!, path: file_path.rawValue))
            }
        }
        return []
    }
    
    func apply(udid: String) -> Bool {
        var filesToRestore: [FileToRestore] = []
        do {
            for tweak in enabledTweaks {
                filesToRestore += try getTweakPageData(tweak, resetting: false)
            }
            if !filesToRestore.isEmpty {
                RestoreManager.shared.restoreFiles(filesToRestore, udid: udid)
                return true
            } else {
                print("No files to restore!")
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func reset(tweaks: [TweakPage], udid: String) -> Bool {
        var filesToRestore: [FileToRestore] = []
        do {
            for tweak in tweaks {
                filesToRestore += try getTweakPageData(tweak, resetting: true)
            }
            if !filesToRestore.isEmpty {
                RestoreManager.shared.restoreFiles(filesToRestore, udid: udid)
                return true
            } else {
                print("No files to restore!")
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
