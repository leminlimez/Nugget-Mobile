//
//  StatusBarTweaks.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import SwiftUI

struct StatusBarView: View {
    @StateObject var applyHandler = ApplyHandler.shared
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State var DummyBinding: String = ""
    @State private var radioPrimarySelection: String = "Default"
//    @State private var cellularServiceEnabled: Bool = false
//    @State private var cellularServiceValue: Bool = false
    
    @State private var carrierText: String = ""
    @State private var carrierTextEnabled: Bool = false
    
    @State private var primaryServiceBadgeText: String = ""
    @State private var primaryServiceBadgeTextEnabled: Bool = false
    
    @State private var radioSecondarySelection: String = "Default"
//    @State private var secondCellularServiceEnabled: Bool = false
//    @State private var secondaryCellularServiceValue: Bool = false
    
    @State private var secondaryCarrierText: String = ""
    @State private var secondaryCarrierTextEnabled: Bool = false
    
    @State private var secondaryServiceBadgeText: String = ""
    @State private var secondaryServiceBadgeTextEnabled: Bool = false
    
    @State private var dateText: String = ""
    @State private var dateTextEnabled: Bool = false
    
    @State private var timeText: String = ""
    @State private var timeTextEnabled: Bool = false
    
    @State private var batteryDetailText: String = ""
    @State private var batteryDetailEnabled: Bool = false
    
    @State private var crumbText: String = ""
    @State private var crumbTextEnabled: Bool = false
    
    @State private var dataNetworkType: Int = 0
    @State private var dataNetworkTypeEnabled: Bool = false
    
    @State private var secondaryDataNetworkType: Int = 0
    @State private var secondaryDataNetworkTypeEnabled: Bool = false
    
    @State private var batteryCapacity: Double = 0
    @State private var batteryCapacityEnabled: Bool = false
    
    @State private var wiFiStrengthBars: Double = 0
    @State private var wiFiStrengthBarsEnabled: Bool = false
    
    @State private var gsmStrengthBars: Double = 0
    @State private var gsmStrengthBarsEnabled: Bool = false
    
    @State private var secondaryGsmStrengthBars: Double = 0
    @State private var secondaryGsmStrengthBarsEnabled: Bool = false
    
    @State private var displayingRawWiFiStrength: Bool = false
    @State private var displayingRawGSMStrength: Bool = false
    
    @State private var DNDHidden: Bool = false
    @State private var airplaneHidden: Bool = false
    @State private var cellHidden: Bool = false
    @State private var wiFiHidden: Bool = false
    @State private var batteryHidden: Bool = false
    @State private var bluetoothHidden: Bool = false
    @State private var alarmHidden: Bool = false
    @State private var locationHidden: Bool = false
    @State private var rotationHidden: Bool = false
    @State private var airPlayHidden: Bool = false
    @State private var carPlayHidden: Bool = false
    @State private var VPNHidden: Bool = false
    
    private var NetworkTypes: [String] = [
        "GPRS", // 0
        "EDGE", // 1
        "3G", // 2
        "4G", // 3
        "LTE", // 4
        "WiFi", // 5
        "Personal Hotspot", // 6
        "1x", // 7
        "5Gᴇ", // 8
        "LTE-A", // 9
        "LTE+", // 10
        "5G", // 11
        "5G+", // 12
        "5GUW", // 13
        "5GUC", // 14
    ]
    
    var body: some View {
        ScrollView {
            Image(systemName: "wifi")
                .foregroundStyle(.blue)
                .font(.system(size: 50))
                .symbolRenderingMode(.hierarchical)
                .padding(.top)
            Text("Status Bar")
                .font(.largeTitle.weight(.bold))
            Text("Betas, use with caution. Have a backup.")
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            ModifyTweakViewModifier(pageKey: .StatusBar)
                .padding(.bottom)
            VStack {
                HStack {
                    Image(systemName: "1.circle.fill")
                        .font(.system(size: 20))
                    Text("Primary Carrier")
                        .bold()
                    Spacer()
                }
                .padding(.leading, 20)
                
            VStack {
                    SQ_Button(text: "Visibility",
                              systemimage: "eye.circle.fill",
                              bgcircle: false,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: true,
                              action: {
                        print("Selected option: \(radioPrimarySelection)")
                    },
                              toggleAction: nil,
                              isToggled: .constant(false), // Not used for picker
                              important_bolded: false,
                              indexInput: 1,
                              bg_needed: false,
                              type: .picker,
                              pickerOptions: ["Default", "Force Show", "Force Hide"], // Options for picker
                              selectedOption: $radioPrimarySelection)
                    .onChange(of: radioPrimarySelection) { new in
                        if new == "Default" {
                            print("ChangedDefault")
                            StatusManager.sharedInstance().unsetCellularService()
                        } else if new == "Force Show" {
                            print("ChangedFS")
                            StatusManager.sharedInstance().setCellularService(true)
                        } else if new == "Force Hide" {
                            print("ChangedFH")
                            StatusManager.sharedInstance().setCellularService(false)
                        }
                    }
                    .onAppear {
                        let serviceEnabled = StatusManager.sharedInstance().isCellularServiceOverridden()
                        if serviceEnabled {
                            let serviceValue = StatusManager.sharedInstance().getCellularServiceOverride()
                            if serviceValue {
                                radioPrimarySelection = "Force Show"
                            } else {
                                radioPrimarySelection = "Force Hide"
                            }
                        } else {
                            radioPrimarySelection = "Default"
                        }
                    }
                    
                    //                            Toggle("Change Service Status", isOn: $cellularServiceEnabled).onChange(of: cellularServiceEnabled, perform: { nv in
                    //                                if nv {
                    //                                    StatusManager.sharedInstance().setCellularService(cellularServiceValue)
                    //                                } else {
                    //                                    StatusManager.sharedInstance().unsetCellularService()
                    //                                }
                    //                            }).onAppear(perform: {
                    //                                cellularServiceEnabled = StatusManager.sharedInstance().isCellularServiceOverridden()
                    //                            })
                    //                            if cellularServiceEnabled {
                    //                                Toggle("Cellular Service Enabled", isOn: $cellularServiceValue).onChange(of: cellularServiceValue, perform: { nv in
                    //                                    if cellularServiceEnabled {
                    //                                        StatusManager.sharedInstance().setCellularService(nv)
                    //                                    }
                    //                                }).onAppear(perform: {
                    //                                    cellularServiceValue = StatusManager.sharedInstance().getCellularServiceOverride()
                    //                                })
                    //                            }
                SQ_Button(text: "Edit Carrier Text",
                          systemimage: "character.textbox",
                          bgcircle: true,
                          tintcolor: nil,
                          randomColor: true,
                          needsDivider: false,
                          action: {},
                          toggleAction: {
                              print("Change Primary Carrier Text toggled: \(carrierTextEnabled)")
                          },
                          isToggled: $carrierTextEnabled,
                          important_bolded: false,
                          indexInput: 2,
                          bg_needed: false,
                          type: .toggle,
                          pickerOptions: [],
                          selectedOption: $DummyBinding)
                .onChange(of: carrierTextEnabled, perform: { nv in
                    if nv {
                        StatusManager.sharedInstance().setCarrier(carrierText)
                    } else {
                        StatusManager.sharedInstance().unsetCarrier()
                    }
                }).onAppear(perform: {
                    carrierTextEnabled = StatusManager.sharedInstance().isCarrierOverridden()
                })
                if carrierTextEnabled {
                    TextField("Carrier Text", text: $carrierText).padding(.leading).padding(.trailing).onChange(of: carrierText, perform: { nv in
                        // This is important.
                        // Make sure the UTF-8 representation of the string does not exceed 100
                        // Otherwise the struct will overflow
                        var safeNv = nv
                        while safeNv.utf8CString.count > 100 {
                            safeNv = String(safeNv.prefix(safeNv.count - 1))
                        }
                        carrierText = safeNv
                        if carrierTextEnabled {
                            StatusManager.sharedInstance().setCarrier(safeNv)
                        }
                    }).onAppear(perform: {
                        carrierText = StatusManager.sharedInstance().getCarrierOverride()
                    })
                    Divider()
                } else {
                    Divider()
                }
                SQ_Button(text: "Edit Service Badge Text",
                          systemimage: "character.textbox", //being left like this until i find another one
                          bgcircle: true,
                          tintcolor: nil,
                          randomColor: true,
                          needsDivider: false,
                          action: {},
                          toggleAction: {
                              print("Change Primary Service Badge Text toggled: \(primaryServiceBadgeTextEnabled)")
                          },
                          isToggled: $primaryServiceBadgeTextEnabled,
                          important_bolded: false,
                          indexInput: 3,
                          bg_needed: false,
                          type: .toggle,
                          pickerOptions: [],
                          selectedOption: $DummyBinding)
                .onChange(of: primaryServiceBadgeTextEnabled, perform: { nv in
                    if nv {
                        StatusManager.sharedInstance().setPrimaryServiceBadge(primaryServiceBadgeText)
                    } else {
                        StatusManager.sharedInstance().unsetPrimaryServiceBadge()
                    }
                }).onAppear(perform: {
                    primaryServiceBadgeTextEnabled = StatusManager.sharedInstance().isPrimaryServiceBadgeOverridden()
                })
                if primaryServiceBadgeTextEnabled {
                    TextField("Service Badge Text", text: $primaryServiceBadgeText).padding(.leading).padding(.trailing).onChange(of: primaryServiceBadgeText, perform: { nv in
                        // This is important.
                        // Make sure the UTF-8 representation of the string does not exceed 100
                        // Otherwise the struct will overflow
                        var safeNv = nv
                        while safeNv.utf8CString.count > 100 {
                            safeNv = String(safeNv.prefix(safeNv.count - 1))
                        }
                        primaryServiceBadgeText = safeNv
                        if primaryServiceBadgeTextEnabled {
                            StatusManager.sharedInstance().setPrimaryServiceBadge(safeNv)
                        }
                    }).onAppear(perform: {
                        primaryServiceBadgeText = StatusManager.sharedInstance().getPrimaryServiceBadgeOverride()
                    })
                    Divider()
                } else {
                    Divider()
                }
                SQ_Button(text: "Edit Data Network Type",
                          systemimage: "antenna.radiowaves.left.and.right.circle.fill",
                          bgcircle: false,
                          tintcolor: nil,
                          randomColor: true,
                          needsDivider: false,
                          action: {},
                          toggleAction: {
                              print("Change Data Network Type toggled: \(dataNetworkTypeEnabled)")
                          },
                          isToggled: $dataNetworkTypeEnabled,
                          important_bolded: false,
                          indexInput: 4,
                          bg_needed: false,
                          type: .toggle,
                          pickerOptions: [],
                          selectedOption: $DummyBinding)
                .onChange(of: dataNetworkTypeEnabled, perform: { nv in
                        if nv {
                            StatusManager.sharedInstance().setDataNetworkType(Int32(dataNetworkType))
                        } else {
                            StatusManager.sharedInstance().unsetDataNetworkType()
                        }
                    }).onAppear(perform: {
                        dataNetworkTypeEnabled = StatusManager.sharedInstance().isDataNetworkTypeOverridden()
                    })
                if dataNetworkTypeEnabled {
                    Menu {
                        ForEach(Array(NetworkTypes.enumerated()), id: \.offset) { i, net in
                            if net != "???" {
                                Button(action: {
                                    dataNetworkType = i
                                    if dataNetworkTypeEnabled {
                                        StatusManager.sharedInstance().setDataNetworkType(Int32(dataNetworkType))
                                    }
                                }) {
                                    Text(net)
                                }
                            }
                        }
                    } label: {
                        
                        
                        HStack {
                            
                            HStack {
                                VStack {
                                    if #available(iOS 17.0, *) {
                                        Text("Type")
                                            .foregroundStyle(colorScheme == .light ? .black : .white)
                                    } else {
                                        Text("Type")
                                            .foregroundColor(colorScheme == .light ? .black : .white)
                                    }
                                }
                                .multilineTextAlignment(.leading)
                                    
                            }
                            Spacer()
                            HStack {
                                if #available(iOS 17.0, *) {
                                    Text(NetworkTypes[dataNetworkType])
                                        .foregroundStyle(.gray)
                                        .font(.footnote)
                                } else {
                                    Text(NetworkTypes[dataNetworkType])
                                        .foregroundColor(.secondary)
                                        .font(.footnote)
                                }
                                Image(systemName: "chevron.up.chevron.down")
                                    .foregroundStyle(.gray)
                                    .font(.caption)
                            }
                        }
                        .padding(.leading)
                        .padding(.trailing)
                    }
                    .onAppear(perform: {
                        dataNetworkType = Int(StatusManager.sharedInstance().getDataNetworkTypeOverride())
                    })
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
                HStack {
                    Image(systemName: "2.circle.fill")
                        .font(.system(size: 20))
                    Text("Secondary Carrier")
                        .bold()
                    Spacer()
                }
                .padding(.leading, 20)
                VStack {
                    SQ_Button(text: "Visibility",
                              systemimage: "eye.circle.fill",
                              bgcircle: false,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: true,
                              action: {
                        print("Selected option: \(radioSecondarySelection)")
                    },
                              toggleAction: nil,
                              isToggled: .constant(false), // Not used for picker
                              important_bolded: false,
                              indexInput: 5,
                              bg_needed: false,
                              type: .picker,
                              pickerOptions: ["Default", "Force Show", "Force Hide"], // Options for picker
                              selectedOption: $radioSecondarySelection)
                    .onChange(of: radioSecondarySelection) { new in
                        if new == "Default" {
                            StatusManager.sharedInstance().unsetSecondaryCellularService()
                        } else if new == "Force Show" {
                            StatusManager.sharedInstance().setSecondaryCellularService(true)
                        } else if new == "Force Hide" {
                            StatusManager.sharedInstance().setSecondaryCellularService(false)
                        }
                    }
                    .onAppear {
                        let serviceEnabled = StatusManager.sharedInstance().isSecondaryCellularServiceOverridden()
                        if serviceEnabled {
                            let serviceValue = StatusManager.sharedInstance().getSecondaryCellularServiceOverride()
                            if serviceValue {
                                radioSecondarySelection = "Force Show"
                            } else {
                                radioSecondarySelection = "Force Hide"
                            }
                        } else {
                            radioSecondarySelection = "Default"
                        }
                    }
                    
                    //                            Toggle("Change Secondary Service Status", isOn: $secondCellularServiceEnabled).onChange(of: secondCellularServiceEnabled, perform: { nv in
                    //                                if nv {
                    //                                    StatusManager.sharedInstance().setSecondaryCellularService(secondaryCellularServiceValue)
                    //                                } else {
                    //                                    StatusManager.sharedInstance().unsetSecondaryCellularService()
                    //                                }
                    //                            }).onAppear(perform: {
                    //                                secondCellularServiceEnabled = StatusManager.sharedInstance().isSecondaryCellularServiceOverridden()
                    //                            })
                    //                            if secondCellularServiceEnabled {
                    //                                Toggle("Secondary Cellular Service Enabled", isOn: $secondaryCellularServiceValue).onChange(of: secondaryCellularServiceValue, perform: { nv in
                    //                                    if secondCellularServiceEnabled {
                    //                                        StatusManager.sharedInstance().setSecondaryCellularService(nv)
                    //                                    }
                    //                                }).onAppear(perform: {
                    //                                    secondaryCellularServiceValue = StatusManager.sharedInstance().getSecondaryCellularServiceOverride()
                    //                                })
                    //                            }
                    SQ_Button(text: "Edit Carrier Text",
                              systemimage: "character.textbox",
                              bgcircle: true,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: false,
                              action: {},
                              toggleAction: {
                        print("Change Secondary Carrier Text toggled: \(secondaryCarrierTextEnabled)")
                    },
                              isToggled: $secondaryCarrierTextEnabled,
                              important_bolded: false,
                              indexInput: 6,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: $DummyBinding)
                    .onChange(of: secondaryCarrierTextEnabled, perform: { nv in
                        if nv {
                            StatusManager.sharedInstance().setSecondaryCarrier(secondaryCarrierText)
                        } else {
                            StatusManager.sharedInstance().unsetSecondaryCarrier()
                        }
                    }).onAppear(perform: {
                        secondaryCarrierTextEnabled = StatusManager.sharedInstance().isSecondaryCarrierOverridden()
                    })
                    if secondaryCarrierTextEnabled {
                        TextField("Secondary Carrier Text", text: $secondaryCarrierText).padding(.leading).padding(.trailing).onChange(of: secondaryCarrierText, perform: { nv in
                            // This is important.
                            // Make sure the UTF-8 representation of the string does not exceed 100
                            // Otherwise the struct will overflow
                            var safeNv = nv
                            while safeNv.utf8CString.count > 100 {
                                safeNv = String(safeNv.prefix(safeNv.count - 1))
                            }
                            secondaryCarrierText = safeNv
                            if secondaryCarrierTextEnabled {
                                StatusManager.sharedInstance().setSecondaryCarrier(safeNv)
                            }
                        }).onAppear(perform: {
                            secondaryCarrierText = StatusManager.sharedInstance().getSecondaryCarrierOverride()
                        })
                        Divider()
                    } else {
                        Divider()
                    }
                    SQ_Button(text: "Edit Service Badge Text",
                              systemimage: "character.textbox", //being left like this until i find another one
                              bgcircle: true,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: false,
                              action: {},
                              toggleAction: {
                        print("Change Secondary Service Badge Text toggled: \(secondaryServiceBadgeTextEnabled)")
                    },
                              isToggled: $secondaryServiceBadgeTextEnabled,
                              important_bolded: false,
                              indexInput: 7,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: $DummyBinding)
                    .onChange(of: secondaryServiceBadgeTextEnabled, perform: { nv in
                        if nv {
                            StatusManager.sharedInstance().setSecondaryServiceBadge(secondaryServiceBadgeText)
                        } else {
                            StatusManager.sharedInstance().unsetSecondaryServiceBadge()
                        }
                    }).onAppear(perform: {
                        secondaryServiceBadgeTextEnabled = StatusManager.sharedInstance().isSecondaryServiceBadgeOverridden()
                    })
                    if secondaryServiceBadgeTextEnabled {
                        TextField("Secondary Service Badge Text", text: $secondaryServiceBadgeText).padding(.leading).padding(.trailing).onChange(of: secondaryServiceBadgeText, perform: { nv in
                            // This is important.
                            // Make sure the UTF-8 representation of the string does not exceed 100
                            // Otherwise the struct will overflow
                            var safeNv = nv
                            while safeNv.utf8CString.count > 100 {
                                safeNv = String(safeNv.prefix(safeNv.count - 1))
                            }
                            secondaryServiceBadgeText = safeNv
                            if secondaryServiceBadgeTextEnabled {
                                StatusManager.sharedInstance().setSecondaryServiceBadge(safeNv)
                            }
                        }).onAppear(perform: {
                            secondaryServiceBadgeText = StatusManager.sharedInstance().getSecondaryServiceBadgeOverride()
                        })
                        Divider()
                    } else {
                        Divider()
                    }
                    SQ_Button(text: "Edit Data Network Type",
                              systemimage: "antenna.radiowaves.left.and.right.circle.fill",
                              bgcircle: false,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: false,
                              action: {},
                              toggleAction: {
                        print("Change Secondary Data Network Type toggled: \(secondaryDataNetworkTypeEnabled)")
                    },
                              isToggled: $secondaryDataNetworkTypeEnabled,
                              important_bolded: false,
                              indexInput: 8,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: $DummyBinding)
                    .onChange(of: secondaryDataNetworkTypeEnabled, perform: { nv in
                        if nv {
                            StatusManager.sharedInstance().setSecondaryDataNetworkType(Int32(secondaryDataNetworkType))
                        } else {
                            StatusManager.sharedInstance().unsetSecondaryDataNetworkType()
                        }
                    }).onAppear(perform: {
                        secondaryDataNetworkTypeEnabled = StatusManager.sharedInstance().isSecondaryDataNetworkTypeOverridden()
                    })
                    if secondaryDataNetworkTypeEnabled {
                        Menu {
                            ForEach(Array(NetworkTypes.enumerated()), id: \.offset) { i, net in
                                if net != "???" {
                                    Button(action: {
                                        secondaryDataNetworkType = i
                                        if secondaryDataNetworkTypeEnabled {
                                            StatusManager.sharedInstance().setSecondaryDataNetworkType(Int32(secondaryDataNetworkType))
                                        }
                                    }) {
                                        Text(net)
                                    }
                                }
                            }
                        } label: {
                            
                            
                            HStack {
                                
                                HStack {
                                    VStack {
                                        if #available(iOS 17.0, *) {
                                            Text("Type")
                                                .foregroundStyle(colorScheme == .light ? .black : .white)
                                        } else {
                                            Text("Type")
                                                .foregroundColor(colorScheme == .light ? .black : .white)
                                        }
                                    }
                                    .multilineTextAlignment(.leading)
                                        
                                }
                                Spacer()
                                HStack {
                                    if #available(iOS 17.0, *) {
                                        Text(NetworkTypes[secondaryDataNetworkType])
                                            .foregroundStyle(.gray)
                                            .font(.footnote)
                                    } else {
                                        Text(NetworkTypes[secondaryDataNetworkType])
                                            .foregroundColor(.secondary)
                                            .font(.footnote)
                                    }
                                    Image(systemName: "chevron.up.chevron.down")
                                        .foregroundStyle(.gray)
                                        .font(.caption)
                                }
                            }
                            .padding(.leading)
                            .padding(.trailing)
                            
                            
                        }
                        .onAppear(perform: {
                        secondaryDataNetworkType = Int(StatusManager.sharedInstance().getSecondaryDataNetworkTypeOverride())
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
                HStack {
                    Image(systemName: "square.grid.3x3.fill")
                        .font(.system(size: 20))
                    Text("Miscellaneous")
                        .bold()
                    Spacer()
                }
                .padding(.leading, 20)
                VStack {
                VStack {
                    SQ_Button(text: "Edit Breadcrumb Text",
                              systemimage: "textformat.characters",
                              bgcircle: true,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: false,
                              action: {},
                              toggleAction: {
                                  print("Change Breadcrumb Text toggled: \(crumbTextEnabled)")
                              },
                              isToggled: $crumbTextEnabled,
                              important_bolded: false,
                              indexInput: 9,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: crumbTextEnabled, perform: { nv in
                        if nv {
                            StatusManager.sharedInstance().setCrumb(crumbText)
                        } else {
                            StatusManager.sharedInstance().unsetCrumb()
                        }
                    }).onAppear(perform: {
                        crumbTextEnabled = StatusManager.sharedInstance().isCrumbOverridden()
                    })
                    if crumbTextEnabled {
                        TextField("Breadcrumb Text", text: $crumbText).padding(.leading).padding(.trailing).onChange(of: crumbText, perform: { nv in
                            // This is important.
                            // Make sure the UTF-8 representation of the string does not exceed 256
                            // Otherwise the struct will overflow
                            var safeNv = nv
                            while (safeNv + " ▶").utf8CString.count > 256 {
                                safeNv = String(safeNv.prefix(safeNv.count - 1))
                            }
                            crumbText = safeNv
                            if crumbTextEnabled {
                                StatusManager.sharedInstance().setCrumb(safeNv)
                            }
                        }).onAppear(perform: {
                            crumbText = StatusManager.sharedInstance().getCrumbOverride()
                        })
                        Divider()
                    } else {
                        Divider()
                    }
                    SQ_Button(text: "Edit Battery Detail Text",
                              systemimage: "battery.75percent",
                              bgcircle: true,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: false,
                              action: {},
                              toggleAction: {
                                  print("Change Battery Detail Text toggled: \(batteryDetailEnabled)")
                              },
                              isToggled: $batteryDetailEnabled,
                              important_bolded: false,
                              indexInput: 10,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: batteryDetailEnabled, perform: { nv in
                        if nv {
                            StatusManager.sharedInstance().setBatteryDetail(batteryDetailText)
                        } else {
                            StatusManager.sharedInstance().unsetBatteryDetail()
                        }
                    }).onAppear(perform: {
                        batteryDetailEnabled = StatusManager.sharedInstance().isBatteryDetailOverridden()
                    })
                    if batteryDetailEnabled {
                        TextField("Battery Detail Text", text: $batteryDetailText).padding(.leading).padding(.trailing).onChange(of: batteryDetailText, perform: { nv in
                            // This is important.
                            // Make sure the UTF-8 representation of the string does not exceed 150
                            // Otherwise the struct will overflow
                            var safeNv = nv
                            while safeNv.utf8CString.count > 150 {
                                safeNv = String(safeNv.prefix(safeNv.count - 1))
                            }
                            batteryDetailText = safeNv
                            if batteryDetailEnabled {
                                StatusManager.sharedInstance().setBatteryDetail(safeNv)
                            }
                        }).onAppear(perform: {
                            batteryDetailText = StatusManager.sharedInstance().getBatteryDetailOverride()
                        })
                        Divider()
                    } else {
                        Divider()
                    }
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        SQ_Button(text: "Edit Date Text",
                                  systemimage: "calendar.circle.fill",
                                  bgcircle: false,
                                  tintcolor: nil,
                                  randomColor: true,
                                  needsDivider: false,
                                  action: {},
                                  toggleAction: {
                                      print("Change Status Bar Date Text toggled: \(dateTextEnabled)")
                                  },
                                  isToggled: $dateTextEnabled,
                                  important_bolded: false,
                                  indexInput: 11,
                                  bg_needed: false,
                                  type: .toggle,
                                  pickerOptions: [],
                                  selectedOption: .constant(""))
                        .onChange(of: dateTextEnabled, perform: { nv in
                            if nv {
                                StatusManager.sharedInstance().setDate(dateText)
                            } else {
                                StatusManager.sharedInstance().unsetDate()
                            }
                        }).onAppear(perform: {
                            dateTextEnabled = StatusManager.sharedInstance().isDateOverridden()
                        })
                        if dateTextEnabled {
                            TextField("Status Bar Date Text", text: $dateText).padding(.leading).padding(.trailing).onChange(of: dateText, perform: { nv in
                                // This is important.
                                // Make sure the UTF-8 representation of the string does not exceed 64
                                // Otherwise the struct will overflow
                                var safeNv = nv
                                while safeNv.utf8CString.count > 256 {
                                    safeNv = String(safeNv.prefix(safeNv.count - 1))
                                }
                                dateText = safeNv
                                if dateTextEnabled {
                                    StatusManager.sharedInstance().setDate(safeNv)
                                }
                            }).onAppear(perform: {
                                dateText = StatusManager.sharedInstance().getDateOverride()
                            })
                            Divider()
                        } else {
                            Divider()
                        }
                    }
                    SQ_Button(text: "Edit Time Text",
                              systemimage: "clock.circle.fill",
                              bgcircle: false,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: false,
                              action: {},
                              toggleAction: {
                                  print("Change Status Bar Time Text toggled: \(timeTextEnabled)")
                              },
                              isToggled: $timeTextEnabled,
                              important_bolded: false,
                              indexInput: UIDevice.current.userInterfaceIdiom == .pad ? 12 : 11,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: timeTextEnabled, perform: { nv in
                        if nv {
                            StatusManager.sharedInstance().setTime(timeText)
                        } else {
                            StatusManager.sharedInstance().unsetTime()
                        }
                    }).onAppear(perform: {
                        timeTextEnabled = StatusManager.sharedInstance().isTimeOverridden()
                    })
                    if timeTextEnabled {
                        TextField("Status Bar Time Text", text: $timeText).padding(.leading).padding(.trailing).onChange(of: timeText, perform: { nv in
                            // This is important.
                            // Make sure the UTF-8 representation of the string does not exceed 64
                            // Otherwise the struct will overflow
                            var safeNv = nv
                            while safeNv.utf8CString.count > 64 {
                                safeNv = String(safeNv.prefix(safeNv.count - 1))
                            }
                            timeText = safeNv
                            if timeTextEnabled {
                                StatusManager.sharedInstance().setTime(safeNv)
                            }
                        }).onAppear(perform: {
                            timeText = StatusManager.sharedInstance().getTimeOverride()
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
                    Text("When set to blank on notched devices, this will display the carrier name.")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom)
                        .frame(width: 316)
                
                VStack {
                    SQ_Button(text: "Edit Battery Icon",
                              systemimage: "battery.100percent",
                              bgcircle: true,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: false,
                              action: {},
                              toggleAction: {
                                  print("Change Battery Icon Capacity toggled: \(batteryCapacityEnabled)")
                              },
                              isToggled: $batteryCapacityEnabled,
                              important_bolded: false,
                              indexInput: 13,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: batteryCapacityEnabled, perform: { nv in
                        if nv {
                            StatusManager.sharedInstance().setBatteryCapacity(Int32(batteryCapacity))
                        } else {
                            StatusManager.sharedInstance().unsetBatteryCapacity()
                        }
                    }).onAppear(perform: {
                        batteryCapacityEnabled = StatusManager.sharedInstance().isBatteryCapacityOverridden()
                    })
                    if batteryCapacityEnabled {
                        HStack {
                            Text("\(Int(batteryCapacity))%")
                                
                            Spacer()
                            Slider(value: $batteryCapacity, in: 0...100, step: 1.0)
                                .padding(.horizontal)
                                .onChange(of: batteryCapacity) { nv in
                                    StatusManager.sharedInstance().setBatteryCapacity(Int32(nv))
                                }
                                .onAppear(perform: {
                                    batteryCapacity = Double(StatusManager.sharedInstance().getBatteryCapacityOverride())
                                })
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        Divider()
                    } else {
                        Divider()
                    }
                    SQ_Button(text: "Edit Wi-Fi Signal",
                              systemimage: "wifi.circle.fill",
                              bgcircle: false,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: false,
                              action: {},
                              toggleAction: {
                                  print("Change Wi-Fi Signal Strength Bars toggled: \(wiFiStrengthBarsEnabled)")
                              },
                              isToggled: $wiFiStrengthBarsEnabled,
                              important_bolded: false,
                              indexInput: 14,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: wiFiStrengthBarsEnabled, perform: { nv in
                        if nv {
                            StatusManager.sharedInstance().setWiFiSignalStrengthBars(Int32(wiFiStrengthBars))
                        } else {
                            StatusManager.sharedInstance().unsetWiFiSignalStrengthBars()
                        }
                    }).onAppear(perform: {
                        wiFiStrengthBarsEnabled = StatusManager.sharedInstance().isWiFiSignalStrengthBarsOverridden()
                    })
                    if wiFiStrengthBarsEnabled {
                        HStack {
                            Text("\(Int(wiFiStrengthBars))")
                                .frame(width: 35)
                            Spacer()
                            Slider(value: $wiFiStrengthBars, in: 0...3, step: 1.0)
                                .padding(.horizontal)
                                .onChange(of: wiFiStrengthBars) { nv in
                                    StatusManager.sharedInstance().setWiFiSignalStrengthBars(Int32(nv))
                                }
                                .onAppear(perform: {
                                    wiFiStrengthBars = Double(StatusManager.sharedInstance().getWiFiSignalStrengthBarsOverride())
                                })
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        Divider()
                    } else {
                        Divider()
                    }
                    SQ_Button(text: "Edit Primary Signal",
                              systemimage: "1.circle.fill",
                              bgcircle: false,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: false,
                              action: {},
                              toggleAction: {
                                  print("Change Primary GSM Signal Strength Bars toggled: \(gsmStrengthBarsEnabled)")
                              },
                              isToggled: $gsmStrengthBarsEnabled,
                              important_bolded: false,
                              indexInput: 15,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: gsmStrengthBarsEnabled, perform: { nv in
                        if nv {
                            StatusManager.sharedInstance().setGsmSignalStrengthBars(Int32(gsmStrengthBars))
                        } else {
                            StatusManager.sharedInstance().unsetGsmSignalStrengthBars()
                        }
                    }).onAppear(perform: {
                        gsmStrengthBarsEnabled = StatusManager.sharedInstance().isGsmSignalStrengthBarsOverridden()
                    })
                    if gsmStrengthBarsEnabled {
                        HStack {
                            Text("\(Int(gsmStrengthBars))")
                                .frame(width: 35)
                            Spacer()
                            Slider(value: $gsmStrengthBars, in: 0...4, step: 1.0)
                                .padding(.horizontal)
                                .onChange(of: gsmStrengthBars) { nv in
                                    StatusManager.sharedInstance().setGsmSignalStrengthBars(Int32(nv))
                                }
                                .onAppear(perform: {
                                    gsmStrengthBars = Double(StatusManager.sharedInstance().getGsmSignalStrengthBarsOverride())
                                })
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        Divider()
                    } else {
                        Divider()
                    }
                    SQ_Button(text: "Edit Secondary Signal",
                              systemimage: "2.circle.fill",
                              bgcircle: false,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: false,
                              action: {},
                              toggleAction: {
                                  print("Change Primary GSM Signal Strength Bars toggled: \(secondaryGsmStrengthBarsEnabled)")
                              },
                              isToggled: $secondaryGsmStrengthBarsEnabled,
                              important_bolded: false,
                              indexInput: 16,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: secondaryGsmStrengthBarsEnabled, perform: { nv in
                        if nv {
                            StatusManager.sharedInstance().setSecondaryGsmSignalStrengthBars(Int32(secondaryGsmStrengthBars))
                        } else {
                            StatusManager.sharedInstance().unsetSecondaryGsmSignalStrengthBars()
                        }
                    }).onAppear(perform: {
                        secondaryGsmStrengthBarsEnabled = StatusManager.sharedInstance().isSecondaryGsmSignalStrengthBarsOverridden()
                    })
                    if secondaryGsmStrengthBarsEnabled {
                        HStack {
                            Text("\(Int(secondaryGsmStrengthBars))")
                                .frame(width: 35)
                            Spacer()
                            Slider(value: $secondaryGsmStrengthBars, in: 0...4, step: 1.0)
                                .padding(.horizontal)
                                .onChange(of: secondaryGsmStrengthBars) { nv in
                                    StatusManager.sharedInstance().setSecondaryGsmSignalStrengthBars(Int32(nv))
                                }
                                .onAppear(perform: {
                                    secondaryGsmStrengthBars = Double(StatusManager.sharedInstance().getSecondaryGsmSignalStrengthBarsOverride())
                                })
                        }
                        .padding(.leading)
                        .padding(.trailing)
                    }
                }
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .foregroundStyle(.regularMaterial)
                        .frame(width: 316)
                }
                .frame(width: 316)
                VStack {
                    SQ_Button(text: "Display Wi-Fi Strength",
                              systemimage: "wifi.router.fill",
                              bgcircle: true,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: true,
                              action: {},
                              toggleAction: {
                                  print("Show Numeric Wi-Fi Strength toggled: \(displayingRawWiFiStrength)")
                              },
                              isToggled: $displayingRawWiFiStrength,
                              important_bolded: false,
                              indexInput: 17,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: displayingRawWiFiStrength, perform: { nv in
                        StatusManager.sharedInstance().displayRawWifiSignal(nv)
                    }).onAppear(perform: {
                        displayingRawWiFiStrength = StatusManager.sharedInstance().isDisplayingRawWiFiSignal()
                    })
                    SQ_Button(text: "Show Cellular Strength",
                              systemimage: "cellularbars",
                              bgcircle: true,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: false,
                              action: {},
                              toggleAction: {
                                  print("Show Numeric Cellular Strength toggled: \(displayingRawGSMStrength)")
                              },
                              isToggled: $displayingRawGSMStrength,
                              important_bolded: false,
                              indexInput: 18,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: displayingRawGSMStrength, perform: { nv in
                        StatusManager.sharedInstance().displayRawGSMSignal(nv)
                    }).onAppear(perform: {
                        displayingRawGSMStrength = StatusManager.sharedInstance().isDisplayingRawGSMSignal()
                    })
                }
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .foregroundStyle(.regularMaterial)
                        .frame(width: 316)
                }
                .frame(width: 316)
                VStack {
                    SQ_Button(text: "Hide Focus",
                              systemimage: "moon.fill",
                              bgcircle: true,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: true,
                              action: {},
                              toggleAction: {
                                  print("Hide Focus (i.e. Do Not Disturb) toggled: \(DNDHidden)")
                              },
                              isToggled: $DNDHidden,
                              important_bolded: false,
                              indexInput: 19,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: DNDHidden, perform: { nv in
                        StatusManager.sharedInstance().hideDND(nv)
                    }).onAppear(perform: {
                        DNDHidden = StatusManager.sharedInstance().isDNDHidden()
                    })
                    SQ_Button(text: "Hide Airplane Mode",
                              systemimage: "airplane.circle.fill",
                              bgcircle: false,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: true,
                              action: {},
                              toggleAction: {
                                  print("Hide Airplane Mode toggled: \(airplaneHidden)")
                              },
                              isToggled: $airplaneHidden,
                              important_bolded: false,
                              indexInput: 21,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: airplaneHidden, perform: { nv in
                        StatusManager.sharedInstance().hideAirplane(nv)
                    }).onAppear(perform: {
                        airplaneHidden = StatusManager.sharedInstance().isAirplaneHidden()
                    })
                    SQ_Button(text: "Hide Cellular*",
                              systemimage: "antenna.radiowaves.left.and.right.slash.circle.fill",
                              bgcircle: false,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: false,
                              action: {},
                              toggleAction: {
                                  print("Hide Cellular toggled: \(cellHidden)")
                              },
                              isToggled: $cellHidden,
                              important_bolded: false,
                              indexInput: 20,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: cellHidden, perform: { nv in
                        StatusManager.sharedInstance().hideCell(nv)
                    }).onAppear(perform: {
                        cellHidden = StatusManager.sharedInstance().isCellHidden()
                    })
                }
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .foregroundStyle(.regularMaterial)
                        .frame(width: 316)
                }
                .frame(width: 316)
                VStack {
                    SQ_Button(text: "Hide Wi-Fi^",
                              systemimage: "wifi.slash",
                              bgcircle: true,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: true,
                              action: {},
                              toggleAction: {
                                  print("Hide Wi-Fi toggled: \(wiFiHidden)")
                              },
                              isToggled: $wiFiHidden,
                              important_bolded: false,
                              indexInput: 22,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: wiFiHidden, perform: { nv in
                        StatusManager.sharedInstance().hideWiFi(nv)
                    }).onAppear(perform: {
                        wiFiHidden = StatusManager.sharedInstance().isWiFiHidden()
                    })
                    //                if UIDevice.current.userInterfaceIdiom != .pad {
                    SQ_Button(text: "Hide Battery",
                              systemimage: "battery.0percent",
                              bgcircle: true,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: true,
                              action: {},
                              toggleAction: {
                                  print("Hide Battery toggled: \(batteryHidden)")
                              },
                              isToggled: $batteryHidden,
                              important_bolded: false,
                              indexInput: 23,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: batteryHidden, perform: { nv in
                        StatusManager.sharedInstance().hideBattery(nv)
                    }).onAppear(perform: {
                        batteryHidden = StatusManager.sharedInstance().isBatteryHidden()
                    })
                    //                }
                    SQ_Button(text: "Hide Bluetooth",
                              systemimage: "bonjour",
                              bgcircle: true,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: true,
                              action: {},
                              toggleAction: {
                                  print("Hide Bluetooth toggled: \(bluetoothHidden)")
                              },
                              isToggled: $bluetoothHidden,
                              important_bolded: false,
                              indexInput: 24,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: bluetoothHidden, perform: { nv in
                        StatusManager.sharedInstance().hideBluetooth(nv)
                    }).onAppear(perform: {
                        bluetoothHidden = StatusManager.sharedInstance().isBluetoothHidden()
                    })
                    SQ_Button(text: "Hide Alarm",
                              systemimage: "alarm.fill",
                              bgcircle: true,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: true,
                              action: {},
                              toggleAction: {
                                  print("Hide Alarm toggled: \(alarmHidden)")
                              },
                              isToggled: $alarmHidden,
                              important_bolded: false,
                              indexInput: 24,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: alarmHidden, perform: { nv in
                        StatusManager.sharedInstance().hideAlarm(nv)
                    }).onAppear(perform: {
                        alarmHidden = StatusManager.sharedInstance().isAlarmHidden()
                    })
                    SQ_Button(text: "Hide Location",
                              systemimage: "location.slash.circle.fill",
                              bgcircle: false,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: true,
                              action: {},
                              toggleAction: {
                                  print("Hide Location toggled: \(locationHidden)")
                              },
                              isToggled: $locationHidden,
                              important_bolded: false,
                              indexInput: 25,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: locationHidden, perform: { nv in
                        StatusManager.sharedInstance().hideLocation(nv)
                    }).onAppear(perform: {
                        locationHidden = StatusManager.sharedInstance().isLocationHidden()
                    })
                    SQ_Button(text: "Hide Rotation Lock",
                              systemimage: "lock.rotation",
                              bgcircle: true,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: true,
                              action: {},
                              toggleAction: {
                                  print("Hide Rotation Lock toggled: \(rotationHidden)")
                              },
                              isToggled: $rotationHidden,
                              important_bolded: false,
                              indexInput: 26,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: rotationHidden, perform: { nv in
                        StatusManager.sharedInstance().hideRotation(nv)
                    }).onAppear(perform: {
                        rotationHidden = StatusManager.sharedInstance().isRotationHidden()
                    })
                    SQ_Button(text: "Hide AirPlay",
                              systemimage: "airplay.video.circle.fill",
                              bgcircle: false,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: true,
                              action: {},
                              toggleAction: {
                                  print("Hide AirPlay toggled: \(airPlayHidden)")
                              },
                              isToggled: $airPlayHidden,
                              important_bolded: false,
                              indexInput: 27,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: airPlayHidden, perform: { nv in
                        StatusManager.sharedInstance().hideAirPlay(nv)
                    }).onAppear(perform: {
                        airPlayHidden = StatusManager.sharedInstance().isAirPlayHidden()
                    })
                    SQ_Button(text: "Hide CarPlay",
                              systemimage: "car.fill",
                              bgcircle: true,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: true,
                              action: {},
                              toggleAction: {
                                  print("Hide CarPlay toggled: \(carPlayHidden)")
                              },
                              isToggled: $carPlayHidden,
                              important_bolded: false,
                              indexInput: 28,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: carPlayHidden, perform: { nv in
                        StatusManager.sharedInstance().hideCarPlay(nv)
                    }).onAppear(perform: {
                        carPlayHidden = StatusManager.sharedInstance().isCarPlayHidden()
                    })
                    SQ_Button(text: "Hide VPN",
                              systemimage: "network.badge.shield.half.filled",
                              bgcircle: true,
                              tintcolor: nil,
                              randomColor: true,
                              needsDivider: false,
                              action: {},
                              toggleAction: {
                                  print("Hide VPN toggled: \(VPNHidden)")
                              },
                              isToggled: $VPNHidden,
                              important_bolded: false,
                              indexInput: 29,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: VPNHidden, perform: { nv in
                        StatusManager.sharedInstance().hideVPN(nv)
                    }).onAppear(perform: {
                        VPNHidden = StatusManager.sharedInstance().isVPNHidden()
                    })
                }
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .foregroundStyle(.regularMaterial)
                        .frame(width: 316)
                }
                .frame(width: 316)
                    Text("*Will also hide carrier name\n^Will also hide cellular data indicator")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom)
                        .frame(width: 316)
                
            }
            
        }
            .disabled(!applyHandler.enabledTweaks.contains(.StatusBar))
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

