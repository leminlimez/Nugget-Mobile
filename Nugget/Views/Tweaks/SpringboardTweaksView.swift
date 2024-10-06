//
//  SpringboardTweaksView.swift
//  Nugget
//
//  Created by lemin on 9/13/24.
//

import SwiftUI

struct SpringboardTweaksView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @StateObject var applyHandler = ApplyHandler.shared
    @StateObject var manager: BasicPlistTweaksManager = BasicPlistTweaksManager.getManager(for: .SpringBoard)!
    let legibleColors: [Color] = [
        .blue, .green, .orange, .red, .purple, .yellow, .pink, .cyan, .mint
    ]
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                Image(systemName: "gear")
                    .foregroundStyle(.orange)
                    .font(.system(size: 50))
                    .symbolRenderingMode(.hierarchical)
                    .padding(.top)
                Text("SpringBoard")
                    .font(.largeTitle.weight(.bold))
                Text("Tweak your lockscreen, change power settings and more.")
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                ModifyTweakViewModifier(pageKey: .SpringBoard)
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
                                if tweak.tweakType.wrappedValue == .text {
                                    HStack {
                                        if !tweak.needsBGCircle.wrappedValue {
                                            Image(systemName: tweak.icon.wrappedValue)
                                                .symbolRenderingMode(.hierarchical)
                                                .font(.system(size: 30))
                                                .foregroundStyle(tweak.color.wrappedValue)
                                        } else {
                                            Image(systemName: "arrow.down.circle.fill")
                                                .symbolRenderingMode(.hierarchical)
                                                .font(.system(size: 30))
                                                .foregroundStyle(.clear)
                                                .overlay(alignment: .center) {
                                                    ZStack {
                                                        Circle()
                                                            .foregroundStyle(tweak.color.wrappedValue)
                                                            .opacity(0.2)
                                                            .frame(width: 30, height: 30)
                                                        
                                                        Image(systemName: tweak.icon.wrappedValue)
                                                            .font(.system(size: 16, weight: .regular))
                                                            .foregroundStyle(tweak.color.wrappedValue)
                                                            .symbolRenderingMode(.hierarchical)
                                                    }
                                                }
                                        }
                                        
                                        Text(tweak.title.wrappedValue)
                                            .fontWeight(.bold)
                                            .foregroundStyle(colorScheme == .light ? .black : .white)
                                        Spacer()
                                    }
                                    .padding(.leading)
                                    .padding(.trailing)
                                    TextField(tweak.placeholder.wrappedValue, text: tweak.stringValue)
                                        .padding(.leading)
                                        .padding(.trailing)
                                        .onChange(of: tweak.stringValue.wrappedValue, perform: { nv in
                                            do {
                                                try manager.setTweakValue(tweak.wrappedValue, newVal: nv)
                                            } catch {
                                                UIApplication.shared.alert(body: error.localizedDescription)
                                            }
                                        })
                                    
                                    if tweak.divider.wrappedValue {
                                        Divider()
                                    }
                                    
                                } else if tweak.tweakType.wrappedValue == .toggle {
                                    // Store the selected color for the toggle button
                                    
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
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .foregroundStyle(.regularMaterial)
                                .frame(width: abs(geo.size.width - 30))
                        }
                        .frame(width: abs(geo.size.width - 30))
                    }
                }
                .disabled(!applyHandler.enabledTweaks.contains(.SpringBoard))
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
