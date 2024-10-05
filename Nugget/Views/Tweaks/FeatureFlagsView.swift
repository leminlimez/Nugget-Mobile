//
//  FeatureFlagsView.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import SwiftUI

struct FeatureFlagsView: View {
    @StateObject var ffManager = FeatureFlagManager.shared
    @StateObject var applyHandler = ApplyHandler.shared
    @Environment(\.dismiss) var dismiss
    struct FeatureFlagOption: Identifiable {
        var id = UUID()
        var label: String
        var icon: String
        var divider: Bool = true
        var needsbgcirc: Bool
        var flag: FeatureFlag
        var active: Bool = false
        var color: Color
    }
    
    @State var featureFlagOptions: [FeatureFlagOption] = [
        .init(label: "Smooth Clock Animation", icon: "lock.iphone",
              needsbgcirc: true, flag: .init(id: 0, category: .SpringBoard, flags: ["SwiftUITimeAnimation"]), color: .blue),
        .init(label: "Lockscreen Switches",
              icon: "button.horizontal.top.press.fill", needsbgcirc: true, flag: .init(id: 1, category: .SpringBoard, flags: ["AutobahnQuickSwitchTransition", "SlipSwitch", "PosterEditorKashida"]), color: .purple),
        .init(label: "Old Photo UI",
              icon: "photo.circle.fill", divider: false, needsbgcirc: false, flag: .init(id: 2, category: .Photos, flags: ["Lemonade"], is_list: false, inverted: true), color: .green)
    ]
    
    var body: some View {
        ScrollView {
            Image(systemName: "flag.fill")
                .foregroundStyle(.red)
                .font(.system(size: 50))
                .symbolRenderingMode(.hierarchical)
                .padding(.top)
            Text("Feature Flags")
                .font(.largeTitle.weight(.bold))
            Text("Enable smooth UI animations, toggle duplicate lockscreen buttons, and more.")
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            ModifyTweakViewModifier(pageKey: .FeatureFlags)
                .padding(.bottom)
            // tweaks from list
            VStack {
                ForEach($featureFlagOptions) { tweak in
                    SQ_Button(text: tweak.label.wrappedValue,
                              systemimage: tweak.icon.wrappedValue,
                              bgcircle: tweak.needsbgcirc.wrappedValue,
                              tintcolor: tweak.color.wrappedValue,
                              randomColor: false,
                              needsDivider: tweak.divider.wrappedValue,
                              action: {},
                              toggleAction: {
                        print("\(tweak.label.wrappedValue) toggled: \(tweak.active.wrappedValue)")
                    },
                              isToggled: tweak.active,
                              important_bolded: false,
                              indexInput: nil,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: tweak.active.wrappedValue, perform: { nv in
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
            .padding()
            .background{
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .foregroundStyle(.regularMaterial)
                    .frame(width: 316)
            }
            .frame(width: 316)
            .disabled(!applyHandler.enabledTweaks.contains(.FeatureFlags))
            Color.clear.frame(height: 30)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(.stack)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "arrow.left.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                Text("Tweaks")
                                    .fontWeight(.bold)
                            }
                        }
                    }
                }
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
