//
//  ModifyTweakViewModifier.swift
//  Nugget
//
//  Created by lemin on 9/17/24.
//

import SwiftUI

struct ModifyTweakViewModifier: View {
    let pageKey: TweakPage
    @Environment(\.colorScheme) var colorScheme
    @StateObject var applyHandler = ApplyHandler.shared
    
    var body: some View {
        
            Button(action: {
                // enable modification
                withAnimation(.easeInOut) {
                    applyHandler.setTweakEnabled(pageKey, isEnabled: !applyHandler.isTweakEnabled(pageKey))
                }
            }) {
                HStack {
                    Image(systemName: applyHandler.isTweakEnabled(pageKey) ? "checkmark.seal.fill" : "xmark.seal.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(Color(applyHandler.isTweakEnabled(pageKey) ? .systemGreen : .systemRed))
                        .font(.system(size: 30))
                    
                    Text("Modify")
                        .fontWeight(.bold)
                        .foregroundStyle(colorScheme == .light ? .black : .white)
                    Spacer()
                }
            }
            .disabled(pageKey == .MobileGestalt && EligibilityManager.shared.aiEnabler == true)
            
        
                
            }
    }
