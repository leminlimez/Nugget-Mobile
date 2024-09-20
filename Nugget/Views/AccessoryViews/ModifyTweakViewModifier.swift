//
//  ModifyTweakViewModifier.swift
//  Nugget
//
//  Created by lemin on 9/17/24.
//

import SwiftUI

struct ModifyTweakViewModifier: ViewModifier {
    let pageKey: TweakPage
    @StateObject var applyHandler = ApplyHandler.shared
    
    func body(content: Content) -> some View {
        content
            .disabled(!applyHandler.enabledTweaks.contains(pageKey))
            .toolbar {
                Button(action: {
                    // enable modification
                    applyHandler.setTweakEnabled(pageKey, isEnabled: !applyHandler.isTweakEnabled(pageKey))
                }) {
                    HStack {
                        Text("Modify")
                        Image(systemName: applyHandler.isTweakEnabled(pageKey) ? "checkmark.seal" : "xmark.seal")
                            .foregroundStyle(Color(applyHandler.isTweakEnabled(pageKey) ? .green : .red))
                    }
                }
                .disabled(pageKey == .MobileGestalt && EligibilityManager.shared.aiEnabler == true)
            }
    }
}

extension View {
    func tweakToggle(for page: TweakPage) -> some View {
        modifier(ModifyTweakViewModifier(pageKey: page))
    }
}
