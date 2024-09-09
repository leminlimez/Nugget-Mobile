//
//  GestaltView.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import SwiftUI

struct GestaltView: View {
    let gestaltManager = MobileGestaltManager.shared
    
    struct GestaltTweak: Identifiable {
        var id = UUID()
        var label: String
        var keys: [String]
        var values: [Any] = [true]
        var active: Bool = false
        var minVersion: Version = Version(string: "1.0")
    }
    
    struct DeviceSubType: Identifiable {
        var id = UUID()
        var key: Int
        var title: String
        var iOS17Only: Bool = false
    }
    
    @State private var CurrentSubType: Int = -1
    @State private var CurrentSubTypeDisplay: String = "Default"
    
    @State private var deviceModelChanged: Bool = false
    @State private var deviceModelName: String = ""
    
    // list of device subtype options
    @State var deviceSubTypes: [DeviceSubType] = [
        .init(key: -1, title: NSLocalizedString("Default", comment: "default device subtype")),
        .init(key: 2436, title: NSLocalizedString("iPhone X Gestures", comment: "x gestures")),
        .init(key: 2556, title: NSLocalizedString("iPhone 14 Pro Dynamic Island", comment: "iPhone 14 Pro SubType")),
        .init(key: 2796, title: NSLocalizedString("iPhone 14 Pro Max Dynamic Island", comment: "iPhone 14 Pro Max SubType")),
        .init(key: 2976, title: NSLocalizedString("iPhone 15 Pro Max Dynamic Island", comment: "iPhone 15 Pro Max SubType"), iOS17Only: true)
    ]
    
    // list of mobile gestalt tweaks
    @State var gestaltTweaks: [GestaltTweak] = [
        .init(label: "Toggle Boot Chime", keys: ["DeviceSupportsBootChime"]),
        .init(label: "Toggle Charge Limit", keys: ["DeviceSupports80ChargeLimit"]),
        .init(label: "Toggle Collision SOS", keys: ["DeviceSupportsCollisionSOS"]),
        .init(label: "Disable Wallpaper Parallax", keys: ["UIParallaxCapability"], values: [false]),
        .init(label: "Toggle Stage Manager Supported (WARNING: risky on some devices, mainly phones)", keys: ["DeviceSupportsEnhancedMultitasking"], values: [1]),
        .init(label: "Allow iPad Apps on iPhone", keys: ["9MZ5AdH43csAUajl/dU+IQ"], values: [[1, 2]]),
        .init(label: "Disable Region Restrictions (ie. Shutter Sound)", keys: ["h63QSdBCiT/z0WU6rdQv6Q", "zHeENZu+wbg7PUprwNwBWg"], values: ["US", "LL/A"]),
        .init(label: "Toggle Action Button", keys: ["RingerButtonCapability"]),
        .init(label: "Toggle Internal Storage (WARNING: risky for some devices, mainly iPads)", keys: ["InternalBuild"]),
        .init(label: "Set as Apple Internal Install (ie Metal HUD in any app)", keys: ["EqrsVvjcYDdxHBiQmGhAWw"]),
        .init(label: "Always On Display", keys: ["DeviceSupportsAlwaysOnDisplay", "DeviceSupportsAlwaysOnTime"], values: [true, true])
    ]
    
    var body: some View {
        List {
            Section {
                // device subtype
                HStack {
                    Image(systemName: "ipodtouch")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.blue)
                    
                    
                    Text("Gestures / Dynamic Island")
                        .minimumScaleFactor(0.5)
                    
                    Spacer()
                    
                    Button(CurrentSubTypeDisplay, action: {
                        showSubTypeChangerPopup()
                    })
                    .foregroundColor(.blue)
                    .padding(.leading, 10)
                }
                
                // device model name
                VStack {
                    Toggle("Change Device Model Name", isOn: $deviceModelChanged).onChange(of: deviceModelChanged, perform: { nv in
                        if nv {
                            if deviceModelName != "" {
                                gestaltManager.setGestaltValue(key: "ArtworkDeviceProductDescription", value: deviceModelName)
                            }
                        } else {
                            gestaltManager.removeGestaltValue(key: "ArtworkDeviceProductDescription")
                        }
                    })
                    TextField("Device Model Name", text: $deviceModelName).onChange(of: deviceModelName, perform: { nv in
                        if deviceModelChanged {
                            gestaltManager.setGestaltValue(key: "ArtworkDeviceProductDescription", value: deviceModelName)
                        }
                    })
                }
            }
            Section {
                // tweaks from list
                ForEach($gestaltTweaks) { tweak in
                    Toggle(tweak.label.wrappedValue, isOn: tweak.active).onChange(of: tweak.active.wrappedValue, perform: { nv in
                        if nv {
                            gestaltManager.setGestaltValues(keys: tweak.keys.wrappedValue, values: tweak.values.wrappedValue)
                        } else {
                            gestaltManager.removeGestaltValues(keys: tweak.keys.wrappedValue)
                        }
                    })
                }
            }
        }
        .navigationTitle("Mobile Gestalt")
        .navigationViewStyle(.stack)
        .onAppear {
            do {
                try gestaltManager.loadMobileGestaltFile()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func showSubTypeChangerPopup() {
        // create and configure alert controller
        let alert = UIAlertController(title: NSLocalizedString("Choose a device subtype", comment: ""), message: NSLocalizedString("Respring to see changes", comment: ""), preferredStyle: .actionSheet)
        
        var iOS17 = false
        if #available(iOS 17, *) {
            iOS17 = true
        }
        
        // create the actions
        
        for type in deviceSubTypes {
            if !type.iOS17Only ||  iOS17 {
                let newAction = UIAlertAction(title: type.title + " (" + String(type.key) + ")", style: .default) { (action) in
                    // apply the type
                    gestaltManager.setGestaltValue(key: "ArtworkDeviceSubType", value: type.key)
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
