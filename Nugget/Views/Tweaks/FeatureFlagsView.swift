//
//  FeatureFlagsView.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import SwiftUI

struct FeatureFlagsView: View {
    @StateObject var ffManager = FeatureFlagManager.shared
    
    struct FeatureFlagOption: Identifiable {
        var id = UUID()
        var label: String
        var flag: FeatureFlag
        var active: Bool = false
    }
    
    @State var featureFlagOptions: [FeatureFlagOption] = [
        .init(label: "Toggle Lockscreen Clock Animation",
              flag: .init(id: 0, category: .SpringBoard, flags: ["SwiftUITimeAnimation"])),
        .init(label: "Toggle Duplicate Lockscreen Button and Lockscreen Quickswitch",
              flag: .init(id: 1, category: .SpringBoard, flags: ["AutobahnQuickSwitchTransition", "SlipSwitch", "PosterEditorKashida"])),
        .init(label: "Enable Old Photo UI",
              flag: .init(id: 2, category: .Photos, flags: ["Lemonade"], is_list: false, inverted: true)),
        .init(label: "Enable Apple Intelligence",
              flag: .init(id: 3, category: .SpringBoard, flags: ["Domino", "SuperDomino"]))
    ]
    
    var body: some View {
        List {
            // tweaks from list
            ForEach($featureFlagOptions) { tweak in
                Toggle(tweak.label.wrappedValue, isOn: tweak.active).onChange(of: tweak.active.wrappedValue, perform: { nv in
                    if nv {
                        ffManager.EnabledFlags.append(tweak.flag.wrappedValue)
                    } else {
                        for (i, flag) in ffManager.EnabledFlags.enumerated() {
                            if tweak.flag.wrappedValue.id == flag.id {
                                ffManager.EnabledFlags.remove(at: i)
                                return
                            }
                        }
                    }
                })
            }
        }
        .tweakToggle(for: .FeatureFlags)
        .navigationTitle("Feature Flags")
        .navigationViewStyle(.stack)
        .onAppear {
            // get the enabled feature flags
            // O(n^2), should be improved
            let enabledFlags = ffManager.EnabledFlags
            for (i, flagOption) in featureFlagOptions.enumerated() {
                for enabledFlag in enabledFlags {
                    if enabledFlag.id == flagOption.flag.id {
                        featureFlagOptions[i].active = true
                        break
                    }
                }
            }
        }
    }
}
