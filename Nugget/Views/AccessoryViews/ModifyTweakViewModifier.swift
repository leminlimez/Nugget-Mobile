//
//  ModifyTweakViewModifier.swift
//  Nugget
//
//  Created by lemin on 9/17/24.
//

import SwiftUI

struct ModifyTweakViewModifier: ViewModifier {
    let pageKey: TweakPage
    
    func body(content: Content) -> some View {
        content
            .disabled(!ApplyHandler.shared.enabledTweaks.contains(pageKey))
            .toolbar {
                Button(action: {
                    // enable modification
                    ApplyHandler.shared.setTweakEnabled(pageKey, isEnabled: !ApplyHandler.shared.isTweakEnabled(pageKey))
                }) {
                    HStack {
                        Text("Modify")
                        Image(systemName: ApplyHandler.shared.isTweakEnabled(pageKey) ? "checkmark.seal" : "xmark.seal")
                            .foregroundStyle(Color(ApplyHandler.shared.isTweakEnabled(pageKey) ? .green : .red))
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
