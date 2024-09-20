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
//    case SkipSetup = "Skip Setup"
}

class ApplyHandler: ObservableObject {
    static let shared = ApplyHandler()
    
    let gestaltManager = MobileGestaltManager.shared
    let ffManager = FeatureFlagManager.shared
    let statusManager = StatusManagerSwift.shared
    
    @Published var enabledTweaks: [TweakPage] = []
    
    func getTweakPageData(_ tweakPage: TweakPage, resetting: Bool, files: inout [FileToRestore]) throws {
        switch tweakPage {
        case .MobileGestalt:
            // Apply mobilegestalt changes
            var mobileGestaltData: Data? = resetting ? try gestaltManager.reset() : try gestaltManager.apply()
            var resChangerData: Data? = resetting ? Data() : gestaltManager.applyRdarFix()
            if let mobileGestaltData = mobileGestaltData {
                files.append(FileToRestore(contents: mobileGestaltData, path: "/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches/com.apple.MobileGestalt.plist"))
            }
            if let resChangerData = resChangerData {
                files.append(FileToRestore(contents: resChangerData, path: FileLocation.resolution.rawValue))
            }
        case .FeatureFlags:
            // Apply feature flag changes (iOS 18.0+ only)
            var ffData: Data = resetting ? try ffManager.reset() : try ffManager.apply()
            files.append(FileToRestore(contents: ffData, path: "/var/preferences/FeatureFlags/Global.plist"))
        case .StatusBar:
            // Apply status bar
            var statusBarData: Data = resetting ? try statusManager.reset() : try statusManager.apply()
            files.append(FileToRestore(contents: statusBarData, path: "HomeDomain/Library/SpringBoard/statusBarOverrides", usesInodes: false))
        case .SpringBoard, .Internal:
            // Apply basic plist changes
            let basicPlistTweaksData: [FileLocation: Data] = BasicPlistTweaksManager.applyPage(tweakPage, resetting: resetting)
            for file_path in basicPlistTweaksData.keys {
                files.append(FileToRestore(contents: basicPlistTweaksData[file_path]!, path: file_path.rawValue))
            }
//        case .SkipSetup:
//            // Apply the skip setup file
//            var skipSetupData: Data = Data()
//            if !resetting {
//                let keys = ["AutoUpdatePresented", "Payment2Presented", "SiriOnBoardingPresented", "AppleIDPB10Presented", "WebKitShrinksStandaloneImagesToFit", "AssistantPresented", "iCloudQuotaPresented", "PBAppActivity2Presented", "PrivacyPresented", "PaymentMiniBuddy4Ran", "PBDiagnostics4Presented", "HSA2UpgradeMiniBuddy3Ran", "ApplePayOnBoardingPresented", "DiagnosticsAutoOptInSet", "SetupFinishedAllSteps", "AssistantPHSOffered", "IntelligencePresented", "UserInterfaceStyleModePresented", "ScreenTimePresented"]
//                var plist: [String: Bool] = [:]
//                for key in keys {
//                    plist[key] = true
//                }
//                skipSetupData = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
//            }
//            if resetting || !self.isExploitOnly() {
//                files.append(FileToRestore(contents: skipSetupData, path: "ManagedPreferencesDomain/mobile/com.apple.purplebuddy.plist"))
//            }
        }
    }
    
    func isExploitOnly() -> Bool {
        if self.enabledTweaks.contains(.StatusBar) {
            return false
        }
        return true
    }
    
    func apply(udid: String/*, skipSetup: Bool*/) -> Bool {
        var filesToRestore: [FileToRestore] = []
        do {
            print("Tweak pages being applied: \(self.enabledTweaks)")
            for tweak in self.enabledTweaks {
                try getTweakPageData(tweak, resetting: false, files: &filesToRestore)
            }
//            if skipSetup {
//                try getTweakPageData(.SkipSetup, resetting: false, files: &filesToRestore)
//            }
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
            print("Tweak pages being reset: \(tweaks)")
            for tweak in tweaks {
                try self.getTweakPageData(tweak, resetting: true, files: &filesToRestore)
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
