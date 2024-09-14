//
//  ToolsView.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import SwiftUI

struct ToolsView: View {
    struct GeneralOption: Identifiable {
        var id = UUID()
        var view: AnyView
        var title: String
        var imageName: String
        var minVersion: Version = Version(string: "1.0")
    }
    
    @State var tools: [GeneralOption] = [
        .init(view: AnyView(GestaltView()), title: NSLocalizedString("Mobile Gestalt", comment: "Title of tool"), imageName: "platter.filled.top.and.arrow.up.iphone"),
        .init(view: AnyView(FeatureFlagsView()), title: NSLocalizedString("Feature Flags", comment: "Title of tool"), imageName: "flag", minVersion: Version(string: "18.0")),
        .init(view: AnyView(StatusBarView()), title: NSLocalizedString("Status Bar", comment: "Title of tool"), imageName: "wifi"),
        .init(view: AnyView(SpringboardTweaksView()), title: NSLocalizedString("Springboard", comment: "Title of tool"), imageName: "app.badge"),
        .init(view: AnyView(InternalOptionsView()), title: NSLocalizedString("Internal Options", comment: "Title of tool"), imageName: "internaldrive")
    ]
    
    let userVersion = Version(string: UIDevice.current.systemVersion)
    
    var body: some View {
        NavigationView {
            List {
                ForEach($tools) { option in
                    if option.minVersion.wrappedValue <= userVersion {
                        NavigationLink(destination: option.view.wrappedValue) {
                            HStack {
                                Image(systemName: option.imageName.wrappedValue)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.blue)
                                Text(option.title.wrappedValue)
                                    .padding(.horizontal, 8)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tools")
        }
    }
}
