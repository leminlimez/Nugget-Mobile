//
//  TestView.swift
//  Nugget
//
//  Created by Marlon Mawby on 30/9/24.
//

import SwiftUI

import SwiftUI

struct TestView: View {
    @State private var showHelp = false
    @State private var helpText = ""

    var body: some View {
        VStack {
            Text("Nugget")
                .font(.largeTitle)
                .bold()

            List {
                tweakOptionRow(title: "Apply Tweaks", info: "Apply the selected tweaks to the system.")
                tweakOptionRow(title: "Remove All Tweaks", info: "Removes all applied tweaks from the system.")
                tweakOptionRow(title: "Select Pairing File", info: "Select a file to pair with the system for tweak application.")
            }
        }
        .sheet(isPresented: $showHelp) {
            HelpView(helpText: $helpText)
        }
    }

    private func tweakOptionRow(title: String, info: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Button(action: {
                helpText = info
                showHelp = true
            }) {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}

struct HelpView: View {
    @Binding var helpText: String

    var body: some View {
        VStack {
            Text("Help")
                .font(.title)
                .bold()
                .padding()

            Text(helpText)
                .padding()

            Spacer()

            Button("Close") {
                // Action to dismiss help
            }
            .padding()
        }
    }
}


#Preview {
    TestView()
}
