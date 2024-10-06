//
//  InternalOptionsView.swift
//  Nugget
//
//  Created by lemin on 9/13/24.
//

import SwiftUI

struct InternalOptionsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var applyHandler = ApplyHandler.shared
    @StateObject var manager: BasicPlistTweaksManager = BasicPlistTweaksManager.getManager(for: .Internal)!
    let legibleColors: [Color] = [
        .blue, .green, .orange, .red, .purple, .yellow, .pink, .cyan, .mint
    ]
    
    // Function to generate a random color from the legible color list
    func randomTintColor() -> Color {
        return legibleColors.randomElement() ?? .blue // Fallback to blue if randomization fails
    }
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                Image(systemName: "internaldrive.fill")
                    .foregroundStyle(.purple)
                    .font(.system(size: 50))
                    .symbolRenderingMode(.hierarchical)
                    .padding(.top)
                Text("Internal")
                    .font(.largeTitle.weight(.bold))
                Text("Change UI Layout, Show debug options, and more.")
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                ModifyTweakViewModifier(pageKey: .Internal)
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .foregroundStyle(.regularMaterial)
                            .frame(width: abs(geo.size.width - 30))
                    }
                    .frame(width: abs(geo.size.width - 30))
                    .padding(.bottom)
                VStack {
                    ForEach(manager.sections) { section in
                        if section.imageString != nil && section.title != nil {
                            HStack {
                                Image(systemName: section.imageString ?? "questionmark.square.dashed")
                                    .font(.system(size: 20))
                                Text(section.title ?? "Add A Title and Icon")
                                    .bold()
                                Spacer()
                            }
                            .padding(.leading, 20)
                        }
                        VStack {
                            ForEach($manager.sections[manager.sections.firstIndex(where: { $0.id == section.id })!].tweaks) { tweak in
                                SQ_Button(text: tweak.title.wrappedValue,
                                          systemimage: tweak.icon.wrappedValue,
                                          bgcircle: tweak.needsBGCircle.wrappedValue,
                                          tintcolor: tweak.color.wrappedValue,
                                          randomColor: false,
                                          needsDivider: tweak.divider.wrappedValue,
                                          action: {},
                                          toggleAction: {
                                    print("\(tweak.title.wrappedValue) toggled: \(tweak.boolValue.wrappedValue)")
                                },
                                          isToggled: tweak.boolValue,
                                          important_bolded: false,
                                          indexInput: nil,
                                          bg_needed: false,
                                          type: .toggle,
                                          pickerOptions: [],
                                          selectedOption: .constant(""))
                                .onChange(of: tweak.boolValue.wrappedValue, perform: { nv in
                                    do {
                                        try manager.setTweakValue(tweak.wrappedValue, newVal: nv)
                                    } catch {
                                        UIApplication.shared.alert(body: error.localizedDescription)
                                    }
                                })
                            }
                        }
                        .padding()
                        .background{
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .foregroundStyle(.regularMaterial)
                                .frame(width: abs(geo.size.width - 30))
                        }
                        .frame(width: abs(geo.size.width - 30))
                    }
                }
                .disabled(!applyHandler.enabledTweaks.contains(.Internal))
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
        }
    }
}
