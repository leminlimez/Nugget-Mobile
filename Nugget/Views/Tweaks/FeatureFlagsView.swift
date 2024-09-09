//
//  FeatureFlagsView.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import SwiftUI

struct FeatureFlagsView: View {
    let ffManager = FeatureFlagManager.shared
    
    struct FeatureFlagOption: Identifiable {
        var id = UUID()
        var label: String
        var flag: FeatureFlag
        var active: Bool = false
    }
    
    @State var featureFlagOptions: [FeatureFlagOption] = [
        .init(label: "Toggle Lockscreen Clock Animation",
              flag: .init(category: .SpringBoard, flags: ["SwiftUITimeAnimation"])),
        .init(label: "Toggle Duplicate Lockscreen Button and Lockscreen Quickswitch",
              flag: .init(category: .SpringBoard, flags: ["AutobahnQuickSwitchTransition", "SlipSwitch", "PosterEditorKashida"])),
        .init(label: "Enable Old Photo UI",
              flag: .init(category: .Photos, flags: ["Lemonade"], is_list: false, inverted: true)),
        .init(label: "Enable Apple Intelligence",
              flag: .init(category: .SpringBoard, flags: ["Domino", "SuperDomino"]))
    ]
    
    var body: some View {
        List {
            // tweaks from list
            ForEach($featureFlagOptions) { tweak in
                Toggle(tweak.label.wrappedValue, isOn: tweak.active).onChange(of: tweak.active.wrappedValue, perform: { nv in
                    if nv {
                        ffManager.enableFlag(tweak.flag.wrappedValue)
                    } else {
                        ffManager.removeFlag(tweak.flag.wrappedValue)
                    }
                })
            }
        }
        .navigationTitle("Feature Flags")
        .navigationViewStyle(.stack)
    }
}
