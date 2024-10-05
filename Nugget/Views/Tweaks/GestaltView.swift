//
//  GestaltView.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import SwiftUI

struct GestaltView: View {
    let gestaltManager = MobileGestaltManager.shared
    let userVersion = Version(string: UIDevice.current.systemVersion)
    @StateObject var applyHandler = ApplyHandler.shared
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    struct GestaltTweak: Identifiable {
        var id = UUID()
        var label: String
        var keys: [String]
        var values: [Any] = [1]
        var active: Bool = false
        var minVersion: Version = Version(string: "1.0")
        var icon: String
        var color: Color
        var bgcircle: Bool
        var divider: Bool = true
    }
    
    struct GestaltSection: Identifiable {
        var id = UUID()
        var title: String?
        var icon: String?
        var tweaks: [GestaltTweak]
    }
    
    struct DeviceSubType: Identifiable {
        var id = UUID()
        var key: Int
        var title: String
        var minVersion: Version = Version(string: "16.0")
    }
    
    @State private var CurrentSubType: Int = -1
    @State private var CurrentSubTypeDisplay: String = "Default"
    
    @State private var modifyResolution: Bool = false
    private let resMode: Int = MobileGestaltManager.shared.getRdarFixMode()
    private let resTitle: String = MobileGestaltManager.shared.getRdarFixTitle()
    
    @State private var deviceModelChanged: Bool = false
    @State private var deviceModelName: String = ""
    
    // list of device subtype options
    @State var deviceSubTypes: [DeviceSubType] = [
        .init(key: -1, title: NSLocalizedString("Default", comment: "default device subtype")),
        .init(key: 2436, title: NSLocalizedString("iPhone X Gestures", comment: "x gestures")),
        .init(key: 2556, title: NSLocalizedString("iPhone 14 Pro Dynamic Island", comment: "iPhone 14 Pro SubType")),
        .init(key: 2796, title: NSLocalizedString("iPhone 14 Pro Max Dynamic Island", comment: "iPhone 14 Pro Max SubType")),
        .init(key: 2976, title: NSLocalizedString("iPhone 15 Pro Max Dynamic Island", comment: "iPhone 15 Pro Max SubType"), minVersion: Version(string: "17.0")),
        .init(key: 2622, title: NSLocalizedString("iPhone 16 Pro Dynamic Island", comment: "iPhone 16 Pro SubType"), minVersion: Version(string: "18.0")),
        .init(key: 2868, title: NSLocalizedString("iPhone 16 Pro Max Dynamic Island", comment: "iPhone 16 Pro Max SubType"), minVersion: Version(string: "18.0"))
    ]
    
    // list of mobile gestalt tweaks
    @State var gestaltTweaks: [GestaltSection] = [
        .init(title: "Buttons & Controls", icon: "button.vertical.left.press.fill", tweaks: [
            .init(label: "Camera Control", keys: ["CwvKxM2cEogD3p+HYgaW0Q", "oOV1jhJbdV3AddkcCg0AEA"], values: [1, 1], minVersion: Version(string: "18.0"), icon: "camera.shutter.button.fill", color: .pink, bgcircle: true),
            .init(label: "Action Button", keys: ["cT44WE1EohiwRzhsZ8xEsw"], icon: "button.vertical.left.press.fill", color: .orange, bgcircle: true, divider: false)
        ]),
        .init(title: "Newer iPhone Features", icon: "iphone.gen3", tweaks: [
            .init(label: "Always On Display", keys: ["2OOJf1VhaM7NxfRok3HbWQ", "j8/Omm6s1lsmTDFsXjsBfA"], values: [1, 1], minVersion: Version(string: "18.0"), icon: "display", color: .teal, bgcircle: true),
            .init(label: "Boot Chime", keys: ["QHxt+hGLaBPbQJbXiUJX3w"], icon: "apple.haptics.and.music.note", color: .blue, bgcircle: true),
            .init(label: "Charge Limit", keys: ["37NVydb//GP/GrhuTN+exg"], icon: "bolt.badge.clock.fill", color: .green, bgcircle: true),
            .init(label: "Collision SOS", keys: ["HCzWusHQwZDea6nNhaKndw"], icon: "sos.circle.fill", color: .red, bgcircle: false),
            .init(label: "Tap to Wake", keys: ["yZf3GTRMGTuwSV/lD7Cagw"], icon: "hand.rays", color: .orange, bgcircle: true, divider: false),
            
                
        ]),
        
        .init(title: "iPadOS Features", icon: "ipad.landscape", tweaks: [
            .init(label: "Disable Wallpaper Parallax", keys: ["UIParallaxCapability"], values: [0], icon: "apps.iphone", color: .purple, bgcircle: true),
            .init(label: "Stage Manager", keys: ["qeaj75wk3HF4DwQ8qbIi7g"], values: [1], icon: "squares.leading.rectangle.fill", color: .yellow, bgcircle: true),
            .init(label: "iPad Multitasking", keys: ["mG0AnH/Vy1veoqoLRAIgTA", "UCG5MkVahJxG1YULbbd5Bg", "ZYqko/XM5zD3XBfN5RmaXA", "nVh/gwNpy7Jv1NOk00CMrw", "uKc7FPnEO++lVhHWHFlGbQ"], values: [1, 1, 1, 1, 1], icon: "platter.2.filled.ipad", color: .blue, bgcircle: true),
            .init(label: "iPad Apps on iPhone", keys: ["9MZ5AdH43csAUajl/dU+IQ"], values: [[1, 2]], icon: "apps.ipad.landscape", color: .green, bgcircle: true),
            .init(label: "Remove Region Locks", keys: ["h63QSdBCiT/z0WU6rdQv6Q", "zHeENZu+wbg7PUprwNwBWg"], values: ["US", "LL/A"], icon: "globe", color: .teal, bgcircle: true),
            .init(label: "Apple Pencil", keys: ["yhHcB0iH0d1XzPO/CFd3ow"], icon: "applepencil.and.scribble", color: .orange, bgcircle: true, divider: false),
            
        ]),
        .init(title: "Apple Internal", icon: "apple.logo", tweaks: [
            .init(label: "Internal Storage", keys: ["LBJfwOEzExRxzlAnSuI7eg"], icon: "internaldrive", color: .purple, bgcircle: true),
            .init(label: "Set Internal Install", keys: ["EqrsVvjcYDdxHBiQmGhAWw"], icon: "arrow.down.circle.fill", color: .blue, bgcircle: false, divider: false),
            
        ])
    ]
    
    var body: some View {
        ScrollView {
            Image(systemName: "platter.filled.top.and.arrow.up.iphone")
                .foregroundStyle(.blue)
                .font(.system(size: 50))
                .symbolRenderingMode(.hierarchical)
                .padding(.top)
            Text("Mobile Gestalt")
                .font(.largeTitle.weight(.bold))
            Text("Enable settings meant for newer devices, enable experimental features, and more.")
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            ModifyTweakViewModifier(pageKey: .MobileGestalt)
                .padding(.bottom)
            VStack {
            VStack {
                
                HStack {
                    Image(systemName: "ipad.landscape.and.iphone")
                        .font(.system(size: 20))
                    Text("Device Model & Model Name")
                        .bold()
                    Spacer()
                }
                .padding(.leading, 20)
                // device subtype
                HStack {
                    Image(systemName: "iphone.circle.fill")
                        .font(.system(size: 30))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.blue)
                    
                    if #available(iOS 17.0, *) {
                        VStack {
                            Text("Model\n")
                                .foregroundStyle(colorScheme == .light ? .black : .white)
                                .fontWeight(.bold)
                            +
                            Text("For Dynamic Island & Gestures")
                                .foregroundStyle(.gray)
                                .font(.system(size: 10))
                        }
                        .multilineTextAlignment(.leading)
                    } else {
                        VStack {
                            Text("Model\n")
                                .foregroundColor(colorScheme == .light ? .black : .white)
                                .fontWeight(.bold)
                            +
                            Text("For Dynamic Island & Gestures")
                                .foregroundColor(.gray)
                                .font(.footnote)
                        }
                        .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    Button {
                        showSubTypeChangerPopup()
                    } label: {
                        HStack {
                            HStack(spacing: 0) {
                                if #available(iOS 17.0, *) {
                                    Text(CurrentSubTypeDisplay)
                                        .foregroundStyle(.gray)
                                        .font(.footnote)
                                } else {
                                    Text(CurrentSubTypeDisplay)
                                        .foregroundColor(.secondary)
                                        .font(.footnote)
                                }
                            }
                            .frame(maxWidth: 75)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            Image(systemName: "chevron.up.chevron.down")
                                .foregroundStyle(.gray)
                                .font(.caption)
                        }
                        
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                Divider()
                // rdar fix (change resolution)
                if resMode > 0 {
                    SQ_Button(text: "\(resTitle) (modifies resolution)",
                              systemimage: "ant.circle.fill",
                              bgcircle: false,
                              tintcolor: .red,
                              randomColor: false,
                              needsDivider: true,
                              action: {},
                              toggleAction: {
                                  print("\(resTitle) (modifies resolution) toggled: \(modifyResolution)")
                              },
                              isToggled: $modifyResolution,
                              important_bolded: false,
                              indexInput: nil,
                              bg_needed: false,
                              type: .toggle,
                              pickerOptions: [],
                              selectedOption: .constant(""))
                    .onChange(of: modifyResolution, perform: { nv in
                        if nv {
                            gestaltManager.setGestaltValue(key: "IOMobileGraphicsFamily", value: resMode)
                        } else {
                            gestaltManager.setGestaltValue(key: "IOMobileGraphicsFamily", value: 0)
                        }
                    })
                }
                
                // device model name
                
                SQ_Button(text: "Change Model Name",
                          systemimage: "textformat.characters",
                          bgcircle: true,
                          tintcolor: .purple,
                          randomColor: false,
                          needsDivider: false,
                          action: {},
                          toggleAction: {
                              print("Change Device Model Name toggled: \(deviceModelChanged)")
                          },
                          isToggled: $deviceModelChanged,
                          important_bolded: false,
                          indexInput: nil,
                          bg_needed: false,
                          type: .toggle,
                          pickerOptions: [],
                          selectedOption: .constant(""))
                    .onChange(of: deviceModelChanged, perform: { nv in
                        if nv {
                            if deviceModelName != "" {
                                gestaltManager.setGestaltValue(key: "ArtworkDeviceProductDescription", value: deviceModelName)
                            }
                        } else {
                            gestaltManager.removeGestaltValue(key: "ArtworkDeviceProductDescription")
                        }
                    })
                if deviceModelChanged {
                    TextField("Device Model Name", text: $deviceModelName).padding(.leading).padding(.trailing).onChange(of: deviceModelName, perform: { nv in
                        if deviceModelChanged {
                            gestaltManager.setGestaltValue(key: "ArtworkDeviceProductDescription", value: deviceModelName)
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
            
            
            // tweaks from list
                ForEach($gestaltTweaks) { category in
                    if category.icon.wrappedValue != nil && category.title.wrappedValue != nil {
                        HStack {
                            Image(systemName: category.icon.wrappedValue ?? "questionmark.square.dashed")
                                .font(.system(size: 20))
                            Text(category.title.wrappedValue ?? "Add A Title and Icon")
                                .bold()
                            Spacer()
                        }
                        .padding(.leading, 20)
                    }
                    VStack {
                        ForEach(category.tweaks) { tweak in
                            if userVersion >= tweak.minVersion.wrappedValue {
                                SQ_Button(text: tweak.label.wrappedValue,
                                          systemimage: tweak.icon.wrappedValue,
                                          bgcircle: tweak.bgcircle.wrappedValue,
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
                                          selectedOption: .constant(""),
                                          description: tweak.label.wrappedValue == "Tap to Wake" ? "For iPhone SE" : tweak.label.wrappedValue == "Stage Manager" ? "Risky on iPhones" : tweak.label.wrappedValue == "Medusa (iPad Multitasking)" ? "Risky on iPhones" : tweak.label.wrappedValue == "Internal Storage" ? "Risky on iPads" : tweak.label.wrappedValue == "iPad Multitasking" ? "ONLY enable on iPhone" : nil)
                                .onChange(of: tweak.active.wrappedValue, perform: { nv in
                                    if nv {
                                        gestaltManager.setGestaltValues(keys: tweak.keys.wrappedValue, values: tweak.values.wrappedValue)
                                    } else {
                                        gestaltManager.removeGestaltValues(keys: tweak.keys.wrappedValue)
                                    }
                                })
                            }
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
            }
            .disabled(!applyHandler.enabledTweaks.contains(.MobileGestalt))
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
            // get the base device subtype
            for (i, deviceSubType) in deviceSubTypes.enumerated() {
                if deviceSubType.key == -1 {
                    deviceSubTypes[i].key = gestaltManager.deviceSubType
                    break
                }
            }
            // load enabled gestalt tweaks
            let enabledTweaks = gestaltManager.getEnabledTweaks()
            // first, the dynamic island
            if let subtype = enabledTweaks["ArtworkDeviceSubType"] as? Int {
                CurrentSubType = subtype
                for deviceSubType in deviceSubTypes {
                    if deviceSubType.key == subtype {
                        CurrentSubTypeDisplay = deviceSubType.title
                        break
                    }
                }
            }
            // second, the resolution
            if let resChange = enabledTweaks["IOMobileGraphicsFamily"] as? Bool {
                modifyResolution = resChange
            }
            // next, the device model name
            if let modelName = enabledTweaks["ArtworkDeviceProductDescription"] as? String {
                deviceModelName = modelName
                deviceModelChanged = true
            }
            // finally, do the other values
            for (i, category) in gestaltTweaks.enumerated() {
                for (j, gestaltTweak) in category.tweaks.enumerated() {
                    if gestaltTweak.keys.count > 0 && enabledTweaks[gestaltTweak.keys[0]] != nil {
                        gestaltTweaks[i].tweaks[j].active = true
                    }
                }
            }
        }
    }
    
    func showSubTypeChangerPopup() {
        // create and configure alert controller
        let alert = UIAlertController(title: NSLocalizedString("Choose a device subtype", comment: ""), message: "", preferredStyle: .actionSheet)
        
        // create the actions
        
        for type in deviceSubTypes {
            if userVersion >= type.minVersion {
                let newAction = UIAlertAction(title: type.title + " (" + String(type.key) + ")", style: .default) { (action) in
                    // apply the type
                    gestaltManager.setGestaltValue(key: "ArtworkDeviceSubType", value: type.key)
                    CurrentSubType = type.key
                    CurrentSubTypeDisplay = type.title
                }
                if CurrentSubType == type.key {
                    // add a check mark
                    newAction.setValue(true, forKey: "checked")
                }
                alert.addAction(newAction)
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (action) in
            // cancels the action
        }
        
        // add the actions
        alert.addAction(cancelAction)
        
        let view: UIView = UIApplication.shared.windows.first!.rootViewController!.view
        // present popover for iPads
        alert.popoverPresentationController?.sourceView = view // prevents crashing on iPads
        alert.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.maxY, width: 0, height: 0) // show up at center bottom on iPads
        
        // present the alert
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
}
