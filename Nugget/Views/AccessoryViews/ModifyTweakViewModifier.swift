//
//  ModifyTweakViewModifier.swift
//  Nugget
//
//  Created by lemin on 9/17/24.
//

import SwiftUI

struct ModifyTweakViewModifier: ViewModifier {
    @StateObject var applyHandler = ApplyHandler.shared
    let pageKey: TweakPage
    
    func body(content: Content) -> some View {
        content
            .disabled(!applyHandler.enabledTweaks.contains(pageKey))
            .toolbar {
                Button(action: {
                    // enable modification
                    if !applyHandler.enabledTweaks.contains(pageKey) {
                        applyHandler.enabledTweaks.append(pageKey)
                    } else {
                        for (i, tweak) in applyHandler.enabledTweaks.enumerated() {
                            if tweak == pageKey {
                                applyHandler.enabledTweaks.remove(at: i)
                                return
                            }
                        }
                    }
                }) {
                    HStack {
                        Text("Modify")
                        Image(systemName: applyHandler.enabledTweaks.contains(pageKey) ? "checkmark.seal" : "xmark.seal")
                            .foregroundStyle(Color(applyHandler.enabledTweaks.contains(pageKey) ? .green : .red))
                    }
                }
            }
    }
}

extension View {
    func tweakToggle(for page: TweakPage) -> some View {
        modifier(ModifyTweakViewModifier(pageKey: page))
    }
}
