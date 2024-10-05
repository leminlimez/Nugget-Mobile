//
//  ToolsView.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import SwiftUI

struct ToolsView: View {
    @StateObject var applyHandler = ApplyHandler.shared
    @Environment(\.colorScheme) var colorScheme
    
    let colors: [Color] = [.blue, .red, .green, .orange, .purple, .yellow, .pink, .teal]
    
    struct GeneralOption: Identifiable {
        var id = UUID()
        var page: TweakPage
        var view: AnyView
        var title: String
        var imageName: String
        var minVersion: Version = Version(string: "1.0")
        var minVersionString: String = "1.0"
    }
    
    struct ToolCategory: Identifiable {
        var id = UUID()
        var title: String
        var pages: [GeneralOption]
        
    }
    
    @State var tools: [ToolCategory] = [
        .init(title: "Sparserestore Tweaks", pages: [
            .init(page: .MobileGestalt, view: AnyView(GestaltView()), title: NSLocalizedString("Mobile Gestalt", comment: "Title of tool"), imageName: "platter.filled.top.and.arrow.up.iphone"),
            .init(page: .FeatureFlags, view: AnyView(FeatureFlagsView()), title: NSLocalizedString("Feature Flags", comment: "Title of tool"), imageName: "flag.circle.fill", minVersion: Version(string: "18.0")),
            .init(page: .Eligibility, view: AnyView(EligibilityView()), title: NSLocalizedString("Eligibility", comment: "Title of tool"), imageName: "mappin.circle.fill", minVersion: Version(string: "18.0")/*Version(string: "17.4")*/),
            .init(page: .SpringBoard, view: AnyView(SpringboardTweaksView()), title: NSLocalizedString("SpringBoard", comment: "Title of tool"), imageName: "gear.circle.fill"),
            .init(page: .Internal, view: AnyView(InternalOptionsView()), title: NSLocalizedString("Internal Options", comment: "Title of tool"), imageName: "internaldrive")
        ]),
        .init(title: "Domain Restore Tweaks", pages: [
            .init(page: .StatusBar, view: AnyView(StatusBarView()), title: NSLocalizedString("Status Bar", comment: "Title of tool"), imageName: "wifi.circle.fill")
        ]),
        .init(title: "Special Features", pages: [
            .init(page: .AI, view: AnyView(AIView()), title: NSLocalizedString("Apple Intelligence", comment: "Title of tool"), imageName: "apple.intelligence", minVersion: Version(string: "18.1"), minVersionString: "18.1")
        ])
    ]
    
    let userVersion = Version(string: UIDevice.current.systemVersion)
    
    var body: some View {
        NavigationView {
            ScrollView {
                Image(systemName: "wrench.and.screwdriver.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.blue)
                    .padding(.top, 50)
                    .symbolRenderingMode(.hierarchical)
                Text("Tweaks")
                    .font(.largeTitle.weight(.bold))
                Text("Tweak your iOS Device with tweaks such as Dynamic island and Apple Intelligence.")
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                ForEach($tools) { category in
                    Section {
                        if category.title.wrappedValue == "Sparserestore Tweaks" {
                            HStack {
                                Image(systemName: "iphone")
                                    .font(.system(size: 20))
                                    .overlay {
                                        Text("")
                                            .font(.system(size: 7))
                                    }
                                Text(category.title.wrappedValue)
                                    .bold()
                                Spacer()
                            }
                            .padding(.leading, 20)
                            .padding(.top)
                        } else if category.title.wrappedValue == "Domain Restore Tweaks" {
                            HStack {
                                Image(systemName: "iphone")
                                    .font(.system(size: 20))
                                    .overlay {
                                        Image(systemName: "network")
                                            .font(.system(size: 7))
                                    }
                                if #available(iOS 17.0, *) {
                                    Text("\(category.title.wrappedValue)\n")
                                        .bold()
                                    +
                                    Text("Requires Skip Setup")
                                        .foregroundStyle(.secondary)
                                        .font(.footnote)
                                } else {
                                    Text("\(category.title.wrappedValue)\n")
                                        .bold()
                                    +
                                    Text("Requires Skip Setup")
                                        .foregroundColor(.secondary)
                                        .font(.footnote)
                                }
                                
                                Spacer()
                            }
                            .padding(.leading, 20)
                        } else if category.title.wrappedValue == "Special Features" {
                            HStack {
                                Image(systemName: "iphone")
                                    .font(.system(size: 20))
                                    .overlay {
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 7))
                                    }
                                if #available(iOS 17.0, *) {
                                    Text("\(category.title.wrappedValue)\n")
                                        .bold()
                                    +
                                    Text("Requires iOS 18.1")
                                        .foregroundStyle(.secondary)
                                        .font(.footnote)
                                } else {
                                    Text("\(category.title.wrappedValue)\n")
                                        .bold()
                                    +
                                    Text("Requires iOS 18.1")
                                        .foregroundColor(.secondary)
                                        .font(.footnote)
                                }
                                
                                Spacer()
                            }
                            .padding(.leading, 20)
                        }
                        
                        VStack {
                            ForEach(category.pages.indices, id: \.self) { index in
                                let option = category.pages[index]
                                if option.minVersion.wrappedValue <= userVersion {
                                    NavigationLink(destination: option.view.wrappedValue) {
                                        HStack {
                                            if option.title.wrappedValue == "Internal Options" {
                                                Image(systemName: "arrow.down.circle.fill")
                                                    .symbolRenderingMode(.hierarchical)
                                                    .font(.system(size: 30))
                                                    .foregroundStyle(.clear)
                                                    .overlay(alignment: .center) {
                                                        ZStack {
                                                            Circle()
                                                                .foregroundStyle(colors[index % colors.count])
                                                                .opacity(0.2)
                                                                .frame(width: 30, height: 30)
                                                            
                                                            Image(systemName: option.imageName.wrappedValue)
                                                                .font(.system(size: 16, weight: .regular))
                                                                .foregroundStyle(colors[index % colors.count])
                                                                .symbolRenderingMode(.hierarchical)
                                                        }
                                                    }
                                            } else if option.title.wrappedValue == "Apple Intelligence" {
                                                
                                                Image(systemName: "arrow.down.circle.fill")
                                                    .symbolRenderingMode(.hierarchical)
                                                    .font(.system(size: 30))
                                                    .foregroundStyle(.clear)
                                                    .overlay(alignment: .center) {
                                                        ZStack {
                                                            Circle()
                                                                .foregroundStyle(LinearGradient(colors: [.yellow, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                                .opacity(0.2)
                                                                .frame(width: 30, height: 30)
                                                            
                                                            Image(systemName: option.imageName.wrappedValue)
                                                                .font(.system(size: 16, weight: .regular))
                                                                .foregroundStyle(LinearGradient(colors: [.yellow, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                                .symbolRenderingMode(.hierarchical)
                                                        }
                                                    }
                                            } else if option.title.wrappedValue == "Mobile Gestalt" {
                                                
                                                Image(systemName: "arrow.down.circle.fill")
                                                    .symbolRenderingMode(.hierarchical)
                                                    .font(.system(size: 30))
                                                    .foregroundStyle(.clear)
                                                    .overlay(alignment: .center) {
                                                        ZStack {
                                                            Circle()
                                                                .foregroundStyle(colors[index % colors.count])
                                                                .opacity(0.2)
                                                                .frame(width: 30, height: 30)
                                                            
                                                            Image(systemName: option.imageName.wrappedValue)
                                                                .font(.system(size: 16, weight: .regular))
                                                                .foregroundStyle(colors[index % colors.count])
                                                                .symbolRenderingMode(.hierarchical)
                                                        }
                                                    }
                                            } else {
                                                Image(systemName: option.imageName.wrappedValue)
                                                    .font(.system(size: 30))
                                                    .foregroundColor(colors[index % colors.count])
                                                    .symbolRenderingMode(.hierarchical)
                                            }
                                            Text(option.title.wrappedValue)
                                                .foregroundStyle(colorScheme == .light ? .black : .white)
                                            Spacer()
                                            if applyHandler.isTweakEnabled(option.page.wrappedValue) {
                                                Image(systemName:"checkmark.seal.fill")
                                                    .symbolRenderingMode(.hierarchical)
                                                    .foregroundStyle(.green)
                                                    .font(.system(size: 20))
                                            }
                                        }
                                        .padding(.leading)
                                        .padding(.trailing)
                                    }
                                    // Add a divider if it's not the last element
                                    if index != category.pages.count - 1 {
                                        Divider()
                                    }
                                } else {
                                    VStack {
                                        HStack {
                                            Image(systemName: "gear.circle.fill")
                                                .font(.system(size: 30))
                                                .foregroundColor(.red)
                                                .symbolRenderingMode(.hierarchical)
                                            Text("Update iOS to \(option.minVersionString.wrappedValue)")
                                                .foregroundStyle(colorScheme == .light ? .black : .white)
                                                .fontWeight(.bold)
                                            Spacer()
                                        }
                                        .padding(.leading)
                                        .padding(.trailing)
                                        
                                        if index != category.pages.count - 1 {
                                            Divider()
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .background{
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .foregroundStyle(.regularMaterial)
                                .frame(width: 316)
                        }
                        .frame(width: 316)
                        
                    }
                }
                
                
                Color.clear.frame(height: 30)
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
