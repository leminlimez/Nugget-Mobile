//
//  InternalOptionsView.swift
//  Nugget
//
//  Created by lemin on 9/13/24.
//

import SwiftUI

struct InternalOptionsView: View {
    @State var manager: BasicPlistTweaksManager = BasicPlistTweaksManager.getManager(
        for: "Internal",
        tweaks: [
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
        ]
    )
    var body: some View {
        List {
            ForEach($manager.tweaks) { tweak in
                Toggle(tweak.title.wrappedValue, isOn: tweak.boolValue).onChange(of: tweak.boolValue.wrappedValue, perform: { nv in
                    manager.setTweakValue(tweak.wrappedValue, newVal: nv)
                })
            }
        }
        .navigationTitle("Springboard Tweaks")
    }
}
