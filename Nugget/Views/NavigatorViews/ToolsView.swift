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
//        var minVersion: Version = "1.0"
    }
    
    @State var tools: [GeneralOption] = [
        .init(key: "GestaltView", view: AnyView(GestaltView()), title: NSLocalizedString("Mobile Gestalt", comment: "Title of tool"), imageName: "platter.filled.top.and.arrow.up.iphone"),
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach($tools) { option in
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
            .navigationTitle("Tools")
        }
    }
}
