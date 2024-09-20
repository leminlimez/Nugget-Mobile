//
//  InternalOptionsView.swift
//  Nugget
//
//  Created by lemin on 9/13/24.
//

import SwiftUI

struct InternalOptionsView: View {
    @StateObject var manager: BasicPlistTweaksManager = BasicPlistTweaksManager.getManager(for: .Internal)!
    
    var body: some View {
        List {
            ForEach($manager.tweaks) { tweak in
                Toggle(tweak.title.wrappedValue, isOn: tweak.boolValue).onChange(of: tweak.boolValue.wrappedValue, perform: { nv in
                    do {
                        try manager.setTweakValue(tweak.wrappedValue, newVal: nv)
                    } catch {
                        UIApplication.shared.alert(body: error.localizedDescription)
                    }
                })
            }
        }
        .tweakToggle(for: .Internal)
        .navigationTitle("Internal Options")
    }
}
