//
//  AITutorialView.swift
//  Nugget
//
//  Created by sq214 on 1/10/24.
//

import SwiftUI
import MarkdownUI

struct AITutorialView: View {
    @Environment(\.dismiss) var dismiss
    @State private var tutorialText: String = ""
    var body: some View {
        VStack {
            ScrollView {
                if !tutorialText.isEmpty {
                    Markdown(tutorialText)
                        .padding()
                        .markdownTheme(.docC)
                } else {
                    Text("Loading tutorial...")
                        .foregroundColor(.gray)
                }
                Color.clear.frame(height: 130)
            }
            .onAppear {
                        tutorialText = loadTutorialText()
                    }
        }
        .navigationTitle("Tutorial")
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(.stack)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "arrow.left.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                Text("Back")
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            UIApplication.shared.open(URL(string: "https://gist.github.com/f1shy-dev/23b4a78dc283edd30ae2b2e6429129b5")!)
                        }) {
                            HStack {
                                Image(systemName: "link.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                            }
                        }
                    }
                }
        
    }
    func loadTutorialText() -> String {
            if let filePath = Bundle.main.path(forResource: "AITutorial", ofType: "txt") {
                do {
                    let contents = try String(contentsOfFile: filePath)
                    return contents
                } catch {
                    return "Error: Unable to read file."
                }
            }
            return "Error: File not found."
        }
}

#Preview {
    AITutorialView()
}
