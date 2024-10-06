//
//  HelpView.swift
//  Nugget
//
//  Created by sq214 on 30/9/24.
//

import SwiftUI

struct HelpView: View {
    @State var skipSetup = false
    @State var dummySelection = false
    @Environment(\.colorScheme) var colorScheme
    @State private var autoReboot: Bool = false // State variable for toggle
        @State private var selectedOption: String = "Option 1" // State variable for picker selection
    var body: some View {
        NavigationView {
            ScrollView {
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.blue)
                    .symbolRenderingMode(.hierarchical)
                    .padding(.top)
                Text("Help")
                    .font(.largeTitle.weight(.bold))
                Text("What do you need help with?")
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .padding(.bottom)
                HStack {
                    ZStack {
                        Image(systemName: "house.circle.fill")
                            .font(.system(size: 20))
                        ZStack {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 20))
                            
                            Image(systemName: "wrench.and.screwdriver.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(colorScheme == .light ? .white : .black)
                        }
                        .overlay {
                            if colorScheme == .light {
                                Circle()
                                    .stroke(.white, lineWidth: 3)
                                    .frame(width: 20, height: 20)
                            } else {
                                Circle()
                                    .stroke(.black, lineWidth: 1)
                                    .frame(width: 20, height: 20)
                            }
                        }
                        .offset(x: 15)
                        ZStack {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 20))
                        }
                        .overlay {
                            if colorScheme == .light {
                                Circle()
                                    .stroke(.white, lineWidth: 3)
                                    .frame(width: 20, height: 20)
                            } else {
                                Circle()
                                    .stroke(.black, lineWidth: 1)
                                    .frame(width: 20, height: 20)
                            }
                        }
                        .offset(x: 30)
                    }
                    
                    Text("Pages")
                        .bold()
                        .offset(x: 30)
                    Spacer()
                }
                .padding(.leading, 20)
                VStack {
                    SQ_Button(
                        text: "Home Page",
                        systemimage: "house.circle.fill",
                        bgcircle: false,
                        tintcolor: .blue,
                        randomColor: false,
                        needsDivider: true,
                        action: {},
                        toggleAction: nil,
                        isToggled: .constant(false),
                        important_bolded: false,
                        indexInput: nil,
                        bg_needed: false,
                        type: .navigation, // Use navigation type
                        pickerOptions: [], // Not needed for navigation
                        NavigationDestination: AnyView(HomeHelpView()), // Pass a view destination
                        selectedOption: .constant("") // Not used in this case
                    )
                    SQ_Button(
                        text: "Tweaks Page",
                        systemimage: "wrench.and.screwdriver.fill",
                        bgcircle: true,
                        tintcolor: .green,
                        randomColor: false,
                        needsDivider: false,
                        action: {UIApplication.shared.alert(title: NSLocalizedString("Coming Soon", comment: "info header"), body: NSLocalizedString("This help feature currently isn't developed.", comment: "coming soon info"))},
                        toggleAction: nil,
                        isToggled: .constant(false),
                        important_bolded: false,
                        indexInput: nil,
                        bg_needed: false,
                        type: .button, // Use navigation type
                        pickerOptions: [], // Not needed for navigation
                        NavigationDestination: AnyView(ToolsHelpView()), // Pass a view destination
                        selectedOption: .constant("") // Not used in this case
                    )
                }
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .foregroundStyle(.regularMaterial)
                        .frame(width: 316)
                }
                .frame(width: 316)
                
            }
            .overlay(alignment: .top) {
                VariableBlurView()
                    .frame(height: getStatusBarHeight())
                    .edgesIgnoringSafeArea(.top)
            }
        }
    }
    func getStatusBarHeight() -> CGFloat {
        // Get status bar height from the current window scene
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.statusBarManager?.statusBarFrame.height ?? 44
    }
}

#Preview {
    HelpView()
}
