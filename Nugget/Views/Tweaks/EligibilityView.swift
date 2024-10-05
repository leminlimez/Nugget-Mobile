//
//  EligibilityView.swift
//  Nugget
//
//  Created by lemin on 9/20/24.
//

import SwiftUI

struct EligibilityView: View {
    @StateObject var manager = EligibilityManager.shared
    @Environment(\.dismiss) var dismiss
    @StateObject var applyHandler = ApplyHandler.shared
    @State var euEnabler: Bool = false
    
    @State var aiEnabler: Bool = false
    @State var changeDeviceModel: Bool = false
    
    var body: some View {
        ScrollView {
            Image(systemName: "mappin")
                .foregroundStyle(.green)
                .font(.system(size: 50))
                .symbolRenderingMode(.hierarchical)
                .padding(.top)
            Text("Eligibility")
                .font(.largeTitle.weight(.bold))
            Text("Use EU Enabler to spoof your devices region to be in Europe for Sideloading apps.")
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            ModifyTweakViewModifier(pageKey: .Eligibility)
                .padding(.bottom)
            // MARK: EU Enabler
            VStack {
                SQ_Button(text: "EU Enabler",
                          systemimage: "globe.europe.africa",
                          bgcircle: true,
                          tintcolor: .blue,
                          randomColor: false,
                          needsDivider: false,
                          action: {},
                          toggleAction: {
                    print("EU Enabler toggled: \(euEnabler)")
                },
                          isToggled: $euEnabler,
                          important_bolded: false,
                          indexInput: nil,
                          bg_needed: false,
                          type: .toggle,
                          pickerOptions: [],
                          selectedOption: .constant(""))
                .onChange(of: euEnabler) { nv in
                    manager.euEnabler = nv
                }
            }
            .padding()
            .background{
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .foregroundStyle(.regularMaterial)
                    .frame(width: 316)
            }
            .frame(width: 316)
               .disabled(!applyHandler.enabledTweaks.contains(.Eligibility))
            
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
            euEnabler = manager.euEnabler
            aiEnabler = manager.aiEnabler
            changeDeviceModel = manager.spoofingDevice
        }
    }
    
    func showInfoAlert(_ body: String) {
        UIApplication.shared.alert(title: "Info", body: body)
    }
}
