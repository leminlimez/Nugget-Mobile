//
//  ToolsView.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import SwiftUI

struct ToolsView: View {
    struct GeneralOption: Identifiable {
        var key: String
        var id = UUID()
        var view: AnyView
        var title: String
        var imageName: String
        var minVersion: Version = Version(string: "1.0")
    }
    
    @State var tools: [GeneralOption] = [
        .init(key: "GestaltView", view: AnyView(GestaltView()), title: NSLocalizedString("Mobile Gestalt", comment: "Title of tool"), imageName: "platter.filled.top.and.arrow.up.iphone"),
        .init(key: "FeatureFlagsView", view: AnyView(FeatureFlagsView()), title: NSLocalizedString("Feature Flags", comment: "Title of tool"), imageName: "flag", minVersion: Version(string: "18.0")),
//        .init(key: "StatusBarView", view: AnyView(StatusBarView()), title: NSLocalizedString("Status Bar", comment: "Title of tool"), imageName: "wifi")
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
