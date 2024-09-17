//
//  SpringboardTweaksView.swift
//  Nugget
//
//  Created by lemin on 9/13/24.
//

import SwiftUI

struct SpringboardTweaksView: View {
    @StateObject var manager: BasicPlistTweaksManager = BasicPlistTweaksManager.getManager(
        for: .SpringBoard,
        tweaks: [
            PlistTweak(key: "LockScreenFootnote", title: "Lock Screen Footnote Text", fileLocation: .footnote, tweakType: .text, placeholder: "Footnote Text"),
            PlistTweak(key: "SBDontLockAfterCrash", title: "Disable Lock After Respring", fileLocation: .springboard, tweakType: .toggle),
            PlistTweak(key: "SBDontDimOrLockOnAC", title: "Disable Screen Dimming While Charging", fileLocation: .springboard, tweakType: .toggle),
            PlistTweak(key: "SBHideLowPowerAlerts", title: "Disable Low Battery Alerts", fileLocation: .springboard, tweakType: .toggle),
            PlistTweak(key: "SBNeverBreadcrumb", title: "Disable Breadcrumb", fileLocation: .springboard, tweakType: .toggle),
            PlistTweak(key: "SBShowSupervisionTextOnLockScreen", title: "Show Supervision Text on Lock Screen", fileLocation: .springboard, tweakType: .toggle),
            PlistTweak(key: "CCSPresentationGesture", title: "Disable CC Presentation Gesture", fileLocation: .springboard, tweakType: .toggle, invertValue: true),
            PlistTweak(key: "WiFiManagerLoggingEnabled", title: "Show WiFi Debugger", fileLocation: .wifiDebug, tweakType: .toggle),
            PlistTweak(key: "DiscoverableMode", title: "Permanently Allow Receiving AirDrop from Everyone", fileLocation: .airdrop, tweakType: .toggle)
        ]
    )
    
    var body: some View {
        List {
            ForEach($manager.tweaks) { tweak in
                if tweak.tweakType.wrappedValue == .text {
                    Text(tweak.title.wrappedValue)
                        .bold()
                    TextField(tweak.placeholder.wrappedValue, text: tweak.stringValue).onChange(of: tweak.stringValue.wrappedValue, perform: { nv in
                        manager.setTweakValue(tweak.wrappedValue, newVal: nv)
                    })
                } else if tweak.tweakType.wrappedValue == .toggle {
                    Toggle(tweak.title.wrappedValue, isOn: tweak.boolValue).onChange(of: tweak.boolValue.wrappedValue, perform: { nv in
                        manager.setTweakValue(tweak.wrappedValue, newVal: nv)
                    })
                }
            }
        }
        .tweakToggle(for: .SpringBoard)
        .navigationTitle("Springboard Tweaks")
    }
}
