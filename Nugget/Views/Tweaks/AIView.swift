//
//  AIView.swift
//  Nugget
//
//  Created by sq214 on 1/10/24.
//

import SwiftUI
import MarkdownUI

struct AIView: View {
    @StateObject var manager = EligibilityManager.shared
    
    @State var euEnabler: Bool = false
    let url = URL(string: "App-Prefs:root=General&path=SOFTWARE_UPDATE_LINK")!

    @State var aiEnabler: Bool = false
    @State var changeDeviceModel: Bool = false
    @StateObject var applyHandler = ApplyHandler.shared
    @Environment(\.dismiss) var dismiss
    @StateObject var ffManager = FeatureFlagManager.shared
    @Environment(\.colorScheme) var colorScheme
    struct FeatureFlagOption: Identifiable {
        var id = UUID()
        var label: String
        var flag: FeatureFlag
        var active: Bool = false
        var symbol: String
        var divider: Bool = true
    }
    
    @State var featureFlagOptions: [FeatureFlagOption] = [
        .init(label: "Enable Apple Intelligence",
              flag: .init(id: 3, category: .SpringBoard, flags: ["Domino", "SuperDomino"]), symbol: "power.circle.fill", divider: true)
    ]
    
    var body: some View {
        ScrollView {
            Image(systemName: "apple.intelligence")
                .foregroundStyle(LinearGradient(colors: [.yellow, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                .font(.system(size: 50))
                .symbolRenderingMode(.hierarchical)
                .padding(.top)
            Text("Apple Intelligence")
                .font(.largeTitle.weight(.bold))
            Text("Enable the new Siri UI with advanced contextual features and priority notifications.")
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            ModifyTweakViewModifier(pageKey: .AI)
            //MARK: tweaks from list
            
                VStack {
                    if #available(iOS 18.1, *) {
                        VStack {
                            SQ_Button(text: "Enable",
                                      systemimage: "power.circle.fill",
                                      bgcircle: false,
                                      tintcolor: .green,
                                      randomColor: false,
                                      needsDivider: true,
                                      action: {},
                                      toggleAction: {
                                print("Enable Apple Intelligence toggled: \(aiEnabler)")
                            },
                                      isToggled: $aiEnabler,
                                      important_bolded: false,
                                      indexInput: nil,
                                      bg_needed: false,
                                      type: .toggle,
                                      pickerOptions: [],
                                      selectedOption: .constant(""),
                                      infoAlert: true,
                                      infoAlertText: "Enables Apple Intelligence on unsupported devices. It may take a long time to download, be patient and check [Settings] -> General -> iPhone/iPad Storage -> iOS -> Apple Intelligence to see if it is downloading.\n\nIf it doesn't apply, try applying again.")
                            
                            .onChange(of: aiEnabler) { nv in
                                manager.toggleAI(nv)
                                if aiEnabler == false {
                                    changeDeviceModel = false
                                    manager.setDeviceModelCode(false)
                                }
                            }
                            if aiEnabler {
                                SQ_Button(text: "Spoof Device Model",
                                          systemimage: "iphone.sizes",
                                          bgcircle: true,
                                          tintcolor: .purple,
                                          randomColor: false,
                                          needsDivider: true,
                                          action: {},
                                          toggleAction: {
                                    print("Spoof Device Model toggled: \(changeDeviceModel)")
                                },
                                          isToggled: $changeDeviceModel,
                                          important_bolded: false,
                                          indexInput: nil,
                                          bg_needed: false,
                                          type: .toggle,
                                          pickerOptions: [],
                                          selectedOption: .constant(""),
                                          infoAlert: true,
                                          infoAlertText: "Spoofs your device model to iPhone 16 (or iPad Pro M4), allowing you to download the AI models.\n\nTurn this on to download the models, then turn this off and reapply after the models are downloading.\n\nNote: While this is on, it breaks Face ID. Reverting the file will fix it.")
                                .onChange(of: changeDeviceModel) { nv in
                                    manager.setDeviceModelCode(nv)
                                }
                            }
                        }
                        .disabled(!applyHandler.enabledTweaks.contains(.AI))
                        
                        NavigationLink {
                            AITutorialView()
                        } label: {
                            HStack {
                                Image(systemName: "arrow.down.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.system(size: 30))
                                    .foregroundStyle(.clear)
                                    .overlay(alignment: .center) {
                                        ZStack {
                                            Circle()
                                                .foregroundStyle(.blue)
                                                .opacity(0.2)
                                                .frame(width: 30, height: 30)
                                            
                                            Image(systemName: "text.page")
                                                .font(.system(size: 16, weight: .regular))
                                                .foregroundStyle(.blue)
                                                .symbolRenderingMode(.hierarchical)
                                        }
                                    }
                                Text("Tutorial")
                                    .foregroundStyle(colorScheme == .light ? .black : .white)
                                Spacer()
                            }
                            .padding(.leading)
                            .padding(.trailing)
                        }
                    } else {
                        
                        
                    }
                }
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .foregroundStyle(.regularMaterial)
                        .frame(width: 316)
                }
                .frame(width: 316)
            
            
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
                    aiEnabler = manager.aiEnabler
                    changeDeviceModel = manager.spoofingDevice
                }
    }
    func openSoftwareUpdateSettings() {
            if let url = URL(string: "App-Prefs:root=General&path=SOFTWARE_UPDATE_LINK"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Unable to open Software Update settings")
            }
        }
    func showInfoAlert(_ body: String) {
        UIApplication.shared.alert(title: "Info", body: body)
    }
}

#Preview {
    AIView()
}
