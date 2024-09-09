//
//  NuggetApp.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import SwiftUI

@main
struct NuggetApp: App {
    init() {
        setenv("USBMUXD_SOCKET_ADDRESS", "127.0.0.1:27015", 1)
    }
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
