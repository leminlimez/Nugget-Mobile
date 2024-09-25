//
//  EligibilityView.swift
//  Nugget
//
//  Created by lemin on 9/20/24.
//

import SwiftUI

struct EligibilityView: View {
    @StateObject var manager = EligibilityManager.shared
    
    @State var euEnabler: Bool = false
    
    @State var aiEnabler: Bool = false
    @State var changeDeviceModel: Bool = false
    
    var body: some View {
        List {
            // MARK: EU Enabler
//            Section {
//                Toggle(isOn: $euEnabler) {
//                    Text("Enable EU Sideloading")
//                }.onChange(of: euEnabler) { nv in
//                    manager.euEnabler = nv
//                }
//            } header: {
//                Text("EU Enabler")
//            }
            
            // MARK: AI Enabler
            if #available(iOS 18.1, *) {
                Section {
                    Toggle(isOn: $aiEnabler) {
                        HStack {
                            Text("Enable Apple Intelligence")
                            Spacer()
                            Button(action: {
                                showInfoAlert(NSLocalizedString("Enables Apple Intelligence on unsupported devices. It may take a long time to download, be patient and check [Settings] -> General -> iPhone/iPad Storage -> iOS -> Apple Intelligence to see if it is downloading.\n\nIf it doesn't apply, try applying again.", comment: "AI info popup"))
                            }) {
                                Image(systemName: "info.circle")
                            }
                        }
                    }.onChange(of: aiEnabler) { nv in
                        manager.toggleAI(nv)
                    }
                    if aiEnabler {
                        Toggle(isOn: $changeDeviceModel) {
                            HStack {
                                Text("Spoof Device Model")
                                Spacer()
                                Button(action: {
                                    showInfoAlert(NSLocalizedString("Spoofs your device model to iPhone 16 (or iPad Pro M4), allowing you to download the AI models.\n\nTurn this on to download the models, then turn this off and reapply after the models are downloading.\n\nNote: While this is on, it breaks Face ID. Reverting the file will fix it.", comment: "Device model changer info popup"))
                                }) {
                                    Image(systemName: "info.circle")
                                }
                            }
                        }.onChange(of: changeDeviceModel) { nv in
                            manager.setDeviceModelCode(nv)
                        }
                    }
                } header: {
                    Text("AI Enabler")
                }
            }
        }
        .tweakToggle(for: .Eligibility)
        .navigationTitle("Eligibility")
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
