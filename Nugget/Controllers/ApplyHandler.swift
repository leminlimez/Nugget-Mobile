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
    case Eligibility = "Eligibility"
    case StatusBar = "Status Bar"
    case SpringBoard = "SpringBoard"
    case Internal = "Internal Options"
    case SkipSetup = "Skip Setup"
}

class ApplyHandler: ObservableObject {
    static let shared = ApplyHandler()
    
    let gestaltManager = MobileGestaltManager.shared
    let ffManager = FeatureFlagManager.shared
    let eligibilityManager = EligibilityManager.shared
    let statusManager = StatusManagerSwift.shared
    
    @Published var enabledTweaks: Set<TweakPage> = []
    
    // MARK: Modifying Enabled Tweaks
    func setTweakEnabled(_ tweak: TweakPage, isEnabled: Bool) {
        if isEnabled {
            enabledTweaks.insert(tweak)
        } else {
            enabledTweaks.remove(tweak)
        }
    }
    func isTweakEnabled(_ tweak: TweakPage) -> Bool {
        return enabledTweaks.contains(tweak)
    }
    func allEnabledTweaks() -> Set<TweakPage> {
        return enabledTweaks
    }
    
    // MARK: Getting Data For Each Tweak
    func getTweakPageData(_ tweakPage: TweakPage, resetting: Bool, files: inout [FileToRestore]) throws {
        switch tweakPage {
        case .MobileGestalt:
            // Apply mobilegestalt changes
            if let mobileGestaltData: Data = resetting ? gestaltManager.reset() : try gestaltManager.apply() {
                files.append(FileToRestore(contents: mobileGestaltData, path: "/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches/com.apple.MobileGestalt.plist"))
            }
            if let resChangerData: Data = resetting ? Data() : gestaltManager.applyRdarFix() {
                files.append(FileToRestore(contents: resChangerData, path: FileLocation.resolution.rawValue))
            }
        case .FeatureFlags:
            // Apply feature flag changes (iOS 18.0+ only)
            let ffData: Data = resetting ? try ffManager.reset() : try ffManager.apply()
            files.append(FileToRestore(contents: ffData, path: "/var/preferences/FeatureFlags/Global.plist"))
        case .Eligibility:
            // Apply eligibility changes
            if !resetting {
                let changes: [String: Data] = try eligibilityManager.apply()
                for (file, newData) in changes {
                    files.append(FileToRestore(contents: newData, path: file))
                }
            } // TODO: reverting
        case .StatusBar:
            // Apply status bar
            let statusBarData: Data = resetting ? try statusManager.reset() : try statusManager.apply()
            files.append(FileToRestore(contents: statusBarData, path: "HomeDomain/Library/SpringBoard/statusBarOverrides", usesInodes: false))
        case .SpringBoard, .Internal:
            // Apply basic plist changes
            let basicPlistTweaksData: [FileLocation: Data] = BasicPlistTweaksManager.applyPage(tweakPage, resetting: resetting)
            for file_path in basicPlistTweaksData.keys {
                files.append(FileToRestore(contents: basicPlistTweaksData[file_path]!, path: file_path.rawValue))
            }
        case .SkipSetup:
            // Apply the skip setup file
            var skipSetupData: Data = Data()
            if !resetting {
                let plist: [String: Any] = [
                    "SkipSetup": ["WiFi", "Location", "Restore", "SIMSetup", "Android", "AppleID", "IntendedUser", "TOS", "Siri", "ScreenTime", "Diagnostics", "SoftwareUpdate", "Passcode", "Biometric", "Payment", "Zoom", "DisplayTone", "MessagingActivationUsingPhoneNumber", "HomeButtonSensitivity", "CloudStorage", "ScreenSaver", "TapToSetup", "Keyboard", "PreferredLanguage", "SpokenLanguage", "WatchMigration", "OnBoarding", "TVProviderSignIn", "TVHomeScreenSync", "Privacy", "TVRoom", "iMessageAndFaceTime", "AppStore", "Safety", "Multitasking", "ActionButton", "TermsOfAddress", "AccessibilityAppearance", "Welcome", "Appearance", "RestoreCompleted", "UpdateCompleted"],
                    "CloudConfigurationUIComplete": true
                ]
                skipSetupData = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
            }
            if resetting || !self.isExploitOnly() {
                files.append(FileToRestore(contents: skipSetupData, path: "/var/containers/Shared/SystemGroup/systemgroup.com.apple.configurationprofiles/Library/ConfigurationProfiles/SharedDeviceConfiguration.plist"))
            }
        }
    }
    
    func isExploitOnly() -> Bool {
        if self.enabledTweaks.contains(.StatusBar) {
            return false
        }
        return true
    }
    
    // MARK: Actual Applying/Resetting Functions
    func apply(udid: String, skipSetup: Bool) -> Bool {
        var filesToRestore: [FileToRestore] = []
        do {
            print("Tweak pages being applied: \(self.enabledTweaks)")
            for tweak in self.enabledTweaks {
                try getTweakPageData(tweak, resetting: false, files: &filesToRestore)
            }
            if skipSetup {
                try getTweakPageData(.SkipSetup, resetting: false, files: &filesToRestore)
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
    
    func reset(tweaks: Set<TweakPage>, udid: String) -> Bool {
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
