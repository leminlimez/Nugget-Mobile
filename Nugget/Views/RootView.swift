//
//  ContentView.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ToolsView()
                .tabItem {
                    Label("Tools", systemImage: "wrench.and.screwdriver.fill")
                }
        }
    }
}
