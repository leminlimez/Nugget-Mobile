//
//  SpringboardTweaksView.swift
//  Nugget
//
//  Created by lemin on 9/13/24.
//

import SwiftUI

struct SpringboardTweaksView: View {
    @StateObject var manager: BasicPlistTweaksManager = BasicPlistTweaksManager.getManager(for: .SpringBoard)!
    
    var body: some View {
        List {
            ForEach($manager.tweaks) { tweak in
                if tweak.tweakType.wrappedValue == .text {
                    Text(tweak.title.wrappedValue)
                        .bold()
                    TextField(tweak.placeholder.wrappedValue, text: tweak.stringValue).onChange(of: tweak.stringValue.wrappedValue, perform: { nv in
                        do {
                            try manager.setTweakValue(tweak.wrappedValue, newVal: nv)
                        } catch {
                            UIApplication.shared.alert(body: error.localizedDescription)
                        }
                    })
                } else if tweak.tweakType.wrappedValue == .toggle {
                    Toggle(tweak.title.wrappedValue, isOn: tweak.boolValue).onChange(of: tweak.boolValue.wrappedValue, perform: { nv in
                        do {
                            try manager.setTweakValue(tweak.wrappedValue, newVal: nv)
                        } catch {
                            UIApplication.shared.alert(body: error.localizedDescription)
                        }
                    })
                }
            }
        }
        .tweakToggle(for: .SpringBoard)
        .navigationTitle("Springboard Tweaks")
    }
}
