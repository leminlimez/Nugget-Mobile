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
    static var managers: [BasicPlistTweaksManager] = [
        /* SpringBoard Manager */
        .init(page: .SpringBoard, tweaks: [
            PlistTweak(key: "LockScreenFootnote", title: "Lock Screen Footnote Text", fileLocation: .footnote, tweakType: .text, placeholder: "Footnote Text"),
            PlistTweak(key: "SBDontLockAfterCrash", title: "Disable Lock After Respring", fileLocation: .springboard, tweakType: .toggle),
            PlistTweak(key: "SBDontDimOrLockOnAC", title: "Disable Screen Dimming While Charging", fileLocation: .springboard, tweakType: .toggle),
            PlistTweak(key: "SBHideLowPowerAlerts", title: "Disable Low Battery Alerts", fileLocation: .springboard, tweakType: .toggle),
            PlistTweak(key: "SBNeverBreadcrumb", title: "Disable Breadcrumb", fileLocation: .springboard, tweakType: .toggle),
            PlistTweak(key: "SBShowSupervisionTextOnLockScreen", title: "Show Supervision Text on Lock Screen", fileLocation: .springboard, tweakType: .toggle),
            PlistTweak(key: "CCSPresentationGesture", title: "Disable CC Presentation Gesture", fileLocation: .springboard, tweakType: .toggle, invertValue: true),
            PlistTweak(key: "SBExtendedDisplayOverrideSupportForAirPlayAndDontFileRadars", title: "Enable AirPlay support for Stage Manager", fileLocation: .springboard, tweakType: .toggle),
//            PlistTweak(key: "WiFiManagerLoggingEnabled", title: "Show WiFi Debugger", fileLocation: .wifiDebug, tweakType: .toggle),
//            PlistTweak(key: "DiscoverableMode", title: "Permanently Allow Receiving AirDrop from Everyone", fileLocation: .airdrop, tweakType: .toggle)
        ]),
        /* Internal Options Manager */
        .init(page: .Internal, tweaks: [
            .init(key: "UIStatusBarShowBuildVersion", title: "Show Build Version in Status Bar", fileLocation: .globalPreferences, tweakType: .toggle),
            .init(key: "NSForceRightToLeftWritingDirection", title: "Force Right-to-Left Layout", fileLocation: .globalPreferences, tweakType: .toggle),
            .init(key: "MetalForceHudEnabled", title: "Enable Metal HUD Debug", fileLocation: .globalPreferences, tweakType: .toggle),
            .init(key: "AccessoryDeveloperEnabled", title: "Enable Accessory Debugging", fileLocation: .globalPreferences, tweakType: .toggle),
            .init(key: "iMessageDiagnosticsEnabled", title: "Enable iMessage Debugging", fileLocation: .globalPreferences, tweakType: .toggle),
            .init(key: "IDSDiagnosticsEnabled", title: "Enable Continuity Debugging", fileLocation: .globalPreferences, tweakType: .toggle),
            .init(key: "VCDiagnosticsEnabled", title: "Enable FaceTime Debugging", fileLocation: .globalPreferences, tweakType: .toggle),
            .init(key: "debugGestureEnabled", title: "Enable App Store Debug Gesture", fileLocation: .appStore, tweakType: .toggle),
            .init(key: "DebugModeEnabled", title: "Enable Notes App Debug Mode", fileLocation: .notes, tweakType: .toggle),
            .init(key: "BKDigitizerVisualizeTouches", title: "Show Touches With Debug Info", fileLocation: .backboardd, tweakType: .toggle),
            .init(key: "BKHideAppleLogoOnLaunch", title: "Hide Respring Icon", fileLocation: .backboardd, tweakType: .toggle),
            .init(key: "EnableWakeGestureHaptic", title: "Vibrate on Raise-to-Wake", fileLocation: .coreMotion, tweakType: .toggle),
            .init(key: "PlaySoundOnPaste", title: "Play Sound on Paste", fileLocation: .pasteboard, tweakType: .toggle),
            .init(key: "AnnounceAllPastes", title: "Show Notifications for System Pastes", fileLocation: .pasteboard, tweakType: .toggle)
        ])
    ]
    
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
    
    static func getManager(for page: TweakPage) -> BasicPlistTweaksManager? {
        // get the manager if the page matches
        for manager in managers {
            if manager.page == page {
                return manager
            }
        }
        return nil
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
            // set it with empty data
            changes[tweak.fileLocation] = Data()
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
