//
//  BasicPlistTweaksManager.swift
//  Nugget
//
//  Created by lemin on 9/13/24.
//

//
//  BasicPlistTweaksManager.swift
//  Nugget
//
//  Created by lemin on 9/13/24.
//


import Foundation
import SwiftUICore

enum PlistTweakType {
    case toggle
    case text
}

struct PlistTweak: Identifiable {
    var id = UUID()
    var key: String
    var title: String
    var fileLocation: FileLocation
    var tweakType: PlistTweakType
    var boolValue: Bool = false
    var invertValue: Bool = false
    var stringValue: String = ""
    var placeholder: String = ""
    var icon: String
    var needsBGCircle: Bool
    var divider: Bool = true
    var color: Color
}

struct TweakSection: Identifiable {
    var id = UUID()
    var title: String?
    var imageString: String? // New property for the image string
    var tweaks: [PlistTweak]
}

class BasicPlistTweaksManager: ObservableObject {
    static var managers: [BasicPlistTweaksManager] = [
        /* SpringBoard Manager */
        .init(page: .SpringBoard, sections: [
            TweakSection(title: "Lock Screen Options", imageString: "lock.ipad", tweaks: [
                PlistTweak(key: "LockScreenFootnote", title: "Footnote Text", fileLocation: .footnote, tweakType: .text, placeholder: "Footnote Text", icon: "platter.filled.bottom.and.arrow.down.iphone", needsBGCircle: true, color: .blue),
                PlistTweak(key: "SBShowSupervisionTextOnLockScreen", title: "Supervision Text", fileLocation: .springboard, tweakType: .toggle, icon: "keyboard.badge.eye", needsBGCircle: true, color: .red),
                PlistTweak(key: "SBDontLockAfterCrash", title: "Disable Lock on Respring", fileLocation: .springboard, tweakType: .toggle, icon: "lock.open.iphone", needsBGCircle: true, divider: false, color: .orange)
            ]),
            TweakSection(title: "Power Options", imageString: "bolt.ring.closed", tweaks: [
                PlistTweak(key: "SBDontDimOrLockOnAC", title: "Stop Charging Dimming", fileLocation: .springboard, tweakType: .toggle, icon: "cable.connector", needsBGCircle: true, color: .green),
                PlistTweak(key: "SBHideLowPowerAlerts", title: "Disable Low Battery Alerts", fileLocation: .springboard, tweakType: .toggle, icon: "battery.25percent", needsBGCircle: true, divider: false, color: .orange),
            ]),
            TweakSection(title: "Miscellaneous", imageString: "square.grid.3x3.fill", tweaks: [
                PlistTweak(key: "SBNeverBreadcrumb", title: "Disable Breadcrumb", fileLocation: .springboard, tweakType: .toggle, icon: "iphone.circle.fill", needsBGCircle: false, color: .teal),
                
                PlistTweak(key: "CCSPresentationGesture", title: "Disable CC Gesture", fileLocation: .springboard, tweakType: .toggle, invertValue: true, icon: "hand.pinch", needsBGCircle: true, divider: false, color: .yellow),
                
            ]),
            TweakSection(tweaks: [
                PlistTweak(key: "SBExtendedDisplayOverrideSupportForAirPlayAndDontFileRadars", title: "AirPlay for Stage Manager", fileLocation: .springboard, tweakType: .toggle, icon: "airplay.video", needsBGCircle: true, divider: false, color: .purple),
            ]),
            
            //            PlistTweak(key: "WiFiManagerLoggingEnabled", title: "Show WiFi Debugger", fileLocation: .wifiDebug, tweakType: .toggle),
            //            PlistTweak(key: "DiscoverableMode", title: "Permanently Allow Receiving AirDrop from Everyone", fileLocation: .airdrop, tweakType: .toggle)
        ]),
        
        /* Internal Options Manager */
        .init(page: .Internal, sections: [
            TweakSection(title: "UI Options", imageString: "apps.iphone", tweaks: [
                .init(key: "UIStatusBarShowBuildVersion", title: "Build Version in Status Bar", fileLocation: .globalPreferences, tweakType: .toggle, icon: "hammer.circle.fill", needsBGCircle: false, color: .pink),
                .init(key: "NSForceRightToLeftWritingDirection", title: "Right-to-Left Layout", fileLocation: .globalPreferences, tweakType: .toggle, icon: "chevron.left.to.line", needsBGCircle: true, color: .blue),
                .init(key: "BKHideAppleLogoOnLaunch", title: "Hide Respring Icon", fileLocation: .backboardd, tweakType: .toggle, icon: "apple.logo", needsBGCircle: true, divider: false, color: .brown)
                
            ]),
            TweakSection(title: "Debug Options", imageString: "ant.fill", tweaks: [
                .init(key: "MetalForceHudEnabled", title: "Metal HUD Debug", fileLocation: .globalPreferences, tweakType: .toggle, icon: "screwdriver.fill", needsBGCircle: true, color: .purple),
                .init(key: "AccessoryDeveloperEnabled", title: "Accessory Debugging", fileLocation: .globalPreferences, tweakType: .toggle, icon: "applepencil", needsBGCircle: true, color: .indigo),
                .init(key: "iMessageDiagnosticsEnabled", title: "iMessage Debugging", fileLocation: .globalPreferences, tweakType: .toggle, icon: "message.circle.fill", needsBGCircle: false, color: .green),
                .init(key: "IDSDiagnosticsEnabled", title: "Continuity Debugging", fileLocation: .globalPreferences, tweakType: .toggle, icon: "macbook.and.iphone", needsBGCircle: true, color: .blue),
                .init(key: "VCDiagnosticsEnabled", title: "FaceTime Debugging", fileLocation: .globalPreferences, tweakType: .toggle, icon: "video.circle.fill", needsBGCircle: false, color: .teal),
                .init(key: "debugGestureEnabled", title: "App Store Debug Gesture", fileLocation: .appStore, tweakType: .toggle, icon: "app.gift.fill", needsBGCircle: true, color: .pink),
                .init(key: "DebugModeEnabled", title: "Notes App Debug Mode", fileLocation: .notes, tweakType: .toggle, icon: "note.text", needsBGCircle: true, color: .yellow),
                .init(key: "BKDigitizerVisualizeTouches", title: "Touches w/ Debug Info", fileLocation: .backboardd, tweakType: .toggle, icon: "hand.tap.fill", needsBGCircle: true, divider: false, color: .orange)
            ]),
            TweakSection(title: "Sound and Haptics", imageString: "iphone.radiowaves.left.and.right", tweaks: [
                .init(key: "EnableWakeGestureHaptic", title: "Vibrate on Raise-to-Wake", fileLocation: .coreMotion, tweakType: .toggle, icon: "iphone.gen3.motion", needsBGCircle: true, color: .blue),
                .init(key: "PlaySoundOnPaste", title: "Play Sound on Paste", fileLocation: .pasteboard, tweakType: .toggle, icon: "document.on.clipboard.fill", needsBGCircle: true, color: .green),
                .init(key: "AnnounceAllPastes", title: "Alert for System Pastes", fileLocation: .pasteboard, tweakType: .toggle, icon: "bell.badge.circle.fill", needsBGCircle: false, divider: false, color: .yellow)
                ])
        ])
    ]
    
    var page: TweakPage
    @Published var sections: [TweakSection]
    
    init(page: TweakPage, sections: [TweakSection]) {
        self.page = page
        self.sections = sections
        
        // Set the tweak values if they exist
        for section in self.sections {
            for (i, tweak) in section.tweaks.enumerated() {
                guard let data = try? Data(contentsOf: getURLFromFileLocation(tweak.fileLocation)) else { continue }
                guard let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else { continue }
                if let val = plist[tweak.key] {
                    if let val = val as? Bool {
                        self.sections[self.sections.firstIndex(where: { $0.id == section.id })!].tweaks[i].boolValue = val
                    } else if let val = val as? String {
                        self.sections[self.sections.firstIndex(where: { $0.id == section.id })!].tweaks[i].stringValue = val
                    }
                }
            }
        }
    }
    
    static func getManager(for page: TweakPage) -> BasicPlistTweaksManager? {
        // Get the manager if the page matches
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
        // Create a dictionary of data to restore
        var changes: [FileLocation: Data] = [:]
        for section in self.sections {
            for tweak in section.tweaks {
                if changes[tweak.fileLocation] == nil {
                    guard let data = try? Data(contentsOf: getURLFromFileLocation(tweak.fileLocation)) else { continue }
                    changes[tweak.fileLocation] = data
                }
            }
        }
        return changes
    }
    
    func reset() -> [FileLocation: Data] {
        var changes: [FileLocation: Data] = [:]
        // Add the location of where to restore
        for section in self.sections {
            for tweak in section.tweaks {
                changes[tweak.fileLocation] = Data()
            }
        }
        return changes
    }
    
    static func applyAll(resetting: Bool) -> [FileLocation: Data] {
        var changes: [FileLocation: Data] = [:]
        for manager in managers {
            changes.merge(resetting ? manager.reset() : manager.apply()) { (current, new) in
                // Combine the 2 plists
                do {
                    guard let currentPlist = try PropertyListSerialization.propertyList(from: current, options: [], format: nil) as? [String: Any] else { return current }
                    guard let newPlist = try PropertyListSerialization.propertyList(from: new, options: [], format: nil) as? [String: Any] else { return current }
                    // Combine them
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
        for manager in managers {
            if manager.page == page {
                return resetting ? manager.reset() : manager.apply()
            }
        }
        // There is no manager, just apply blank
        return [:]
    }
}
