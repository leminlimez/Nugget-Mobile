//
//  RevertTweaksPopoverView.swift
//  Nugget
//
//  Created by lemin on 9/17/24.
//

import SwiftUI

struct RevertTweaksPopoverView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var revertingPages: [TweakPage]
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
                            Text(option.page.wrappedValue.rawValue)
                        }
                        .toggleStyle(.switch)
                        .onChange(of: option.enabled.wrappedValue) { nv in
                            if nv {
                                if !revertingPages.contains(option.page.wrappedValue) {
                                    revertingPages.append(option.page.wrappedValue)
                                }
                            } else {
                                for (i, page) in revertingPages.enumerated() {
                                    if page == option.page.wrappedValue {
                                        revertingPages.remove(at: i)
                                        return
                                    }
                                }
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
                    tweakOptions.append(.init(page: page, enabled: populateArray ? true : revertingPages.contains(page)))
                    if populateArray {
                        revertingPages.append(page)
                    }
                }
            }
        }
    }
}
