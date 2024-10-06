//
//  TabViewConfiguration.swift
//  Nugget
//
//  Created by sq214 on 30/9/24.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case HomeView = "house"
    case ToolsView = "wrench.and.screwdriver"
    case HelpView = "questionmark.circle"
}

struct TabViewConfiguration: View {
    @Binding var selectedTab: Tab
    @State var isAnimating = false
    private var fillImage: String {
           
            return (selectedTab.rawValue + ".fill")
        }
    
    var body: some View {
        VStack{
            HStack{
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    if selectedTab == .HomeView{
                        if tab == .HomeView {
                                Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                                    .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                                    .foregroundColor(selectedTab == tab ? .blue : .gray)
                                    .font(.system(size: 22))
                                    .onTapGesture {
                                        hapticFeedback()
                                        withAnimation(.easeIn(duration: 0.1)) {
                                            selectedTab = tab
                                        }
                                    }
                            
                        
                        } else {
                           
                                Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                                    .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                                    .foregroundColor(selectedTab == tab ? .blue : .gray)
                                    .font(.system(size: 22))
                                    .onTapGesture {
                                        hapticFeedback()
                                        withAnimation(.easeIn(duration: 0.1)) {
                                            selectedTab = tab
                                        }
                                    }
                            
                        }
                    } else {
                        
                        
                        Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                            .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                            .foregroundColor(selectedTab == tab ? .blue : .gray)
                            .font(.system(size: 22))
                            .onTapGesture {
                                hapticFeedback()
                                withAnimation(.easeIn(duration: 0.1)) {
                                    selectedTab = tab
                                }
                            }
                        
                    }
                    Spacer()
                }
            }
        }
        .frame(maxWidth: 400)
        .frame(height: 60)
        
        .background{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .foregroundStyle(.regularMaterial)
        }
        .padding()
    }
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
