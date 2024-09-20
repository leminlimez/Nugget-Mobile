//
//  RevertTweaksPopoverView.swift
//  Nugget
//
//  Created by lemin on 9/17/24.
//

import SwiftUI

struct RevertTweaksPopoverView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var revertingPages: Set<TweakPage>
    let revertFunction: (_ reverting: Bool) -> Void
    
    struct TweakOption: Identifiable {
        var id = UUID()
        var page: TweakPage
        var enabled: Bool
    }
    
    @State var tweakOptions: [TweakOption] = []
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach($tweakOptions) { option in
                        Toggle(isOn: option.enabled) {
                            Text("Revert \(option.page.wrappedValue.rawValue)")
                        }
                        .toggleStyle(.switch)
                        .onChange(of: option.enabled.wrappedValue) { nv in
                            if nv {
                                if !revertingPages.contains(option.page.wrappedValue) {
                                    revertingPages.insert(option.page.wrappedValue)
                                }
                            } else {
                                revertingPages.remove(option.page.wrappedValue)
                            }
                        }
                    }
                }
                .navigationTitle("Select Tweaks")
                Section {
                    // Apply button
                    Button("Remove Tweaks") {
                        dismiss()
                        revertFunction(true)
                    }
                    .buttonStyle(TintedButton(color: .red, fullwidth: true))
                    // Cancel button
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(TintedButton(color: .blue, fullwidth: true))
                }
            }
            .onAppear {
                let populateArray: Bool = revertingPages.isEmpty
                for page in TweakPage.allCases {
                    var autoEnable: Bool = true
                    // disable by default for non-exploit tweaks
                    if page == .StatusBar {
                        autoEnable = false
                    }
                    tweakOptions.append(.init(page: page, enabled: populateArray ? autoEnable : revertingPages.contains(page)))
                    if populateArray && autoEnable {
                        revertingPages.insert(page)
                    }
                }
            }
        }
    }
}
