//
//  HomeHelpView.swift
//  Nugget
//
//  Created by Singapore214 on 30/9/24.
//

import SwiftUI

struct HomeHelpView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
            VStack {
            ScrollView {
                Image(systemName: "house.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.blue.opacity(0.3))
                    .symbolRenderingMode(.hierarchical)
                    .overlay(alignment: .bottomTrailing) {
                        Circle()
                            .foregroundStyle(colorScheme == .light ? .white : .black)
                            .frame(width: 30, height: 30)
                            .offset(x: 3, y: 7)
                            .overlay {
                                Image(systemName: "questionmark.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundStyle(.blue)
                                    .offset(x: 3, y: 7)
                            }
                            .overlay {
                                Circle()
                                    .stroke(colorScheme == .light ? .white : .black, lineWidth: 3)
                                    .frame(width: 30, height: 30)
                                    .offset(x: 3, y: 7)
                            }
                    }
                Text("Home Help")
                    .font(.largeTitle.weight(.bold))
                    .padding(.top, 5)
                Text("Get to know what buttons and toggles do on the home page.")
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                HStack {
                    Image(systemName: "slider.vertical.3")
                        .font(.system(size: 20))
                    Text("Tweak Options")
                        .bold()
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.top)
                    VStack {
                        HStack {
                            Image(systemName: "hammer.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 30))
                                .foregroundStyle(.blue)
                            Spacer()
                            Text("Apply Tweaks")
                                .foregroundStyle(colorScheme == .light ? .black : .white)
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        Text("Applies all selected tweaks to the current iOS device, customizing and optimizing your device based on your chosen settings.")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                            .padding(.top, 3)
                        Divider()
                        HStack {
                            Image(systemName: "minus.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 30))
                                .foregroundStyle(.red)
                            Spacer()
                            Text("Remove All Tweaks")
                                .foregroundStyle(colorScheme == .light ? .black : .white)
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        Text("Removes all tweaks and reverts the device to its original state, including resetting the mobilegestalt plist.")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                            .padding(.top, 3)
                        Divider()
                        HStack {
                            if #available(iOS 18.0, *) {
                                Image(systemName: "document.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.system(size: 30))
                                    .foregroundStyle(.green)
                            } else {
                                Image(systemName: "doc.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.system(size: 30))
                                    .foregroundStyle(.green)
                            }
                            Spacer()
                            Text("Select Pairing File")
                                .foregroundStyle(colorScheme == .light ? .black : .white)
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        Text("Select a pairing file in order to restore the device. One can be gotten from apps like AltStore or SideStore. Tap \"Help\" for more info.")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                            .padding(.top, 3)
                            .padding(.bottom, 3)
                        Button {
                            UIApplication.shared.open(URL(string: "https://docs.sidestore.io/docs/getting-started/pairing-file")!)
                        } label: {
                            HStack {
                                Spacer()
                                Text("Help")
                                    .bold()
                                    .foregroundStyle(.red)
                                Spacer()
                            }
                            .padding()
                            .background{
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .foregroundStyle(.red.opacity(0.3))
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
                HStack {
                    Image(systemName: "switch.2")
                        .font(.system(size: 20))
                    Text("Tweak Toggles")
                        .bold()
                    Spacer()
                }
                .padding(.leading, 20)
                VStack {
                    HStack {
                        Image(systemName: "restart.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.system(size: 30))
                            .foregroundStyle(.blue)
                        Spacer()
                        Text("Auto reboot after apply")
                            .foregroundStyle(colorScheme == .light ? .black : .white)
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    Text("\"Auto Reboot After Apply Tweaks\" simplifies the process by automatically restarting your device after applying changes, ensuring tweaks take effect without requiring manual intervention.")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                        .padding(.top, 3)
                    Divider()
                    HStack {
                        Image(systemName: "arrow.left.arrow.right.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.system(size: 30))
                            .foregroundStyle(.green)
                        Spacer()
                        Text("Traditional Skip Setup")
                            .foregroundStyle(colorScheme == .light ? .black : .white)
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    Text("Applies Cowabunga Lite's Skip Setup method to skip the setup for non-exploit files.\n\nThis may cause issues for some people, so turn it off if you use configuration profiles.\n\nThis will not be applied if you are only applying exploit files, as it will use the SparseRestore method to skip setup.")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                        .padding(.top, 3)
                }
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .foregroundStyle(.regularMaterial)
                        .frame(width: 316)
                }
                .frame(width: 316)
                Color.clear.frame(height: 130)
                }
            }
    }
}

#Preview {
    HomeHelpView()
}
