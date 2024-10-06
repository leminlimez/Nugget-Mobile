//
//  SQ_Button.swift
//  Nugget
//
//  Created by sq214 on 1/10/24.
//

import SwiftUI

struct SQ_Button: View {
    @Environment(\.colorScheme) var colorScheme
    var text: String
    var systemimage: String
    var bgcircle: Bool
    var tintcolor: Color?
    var randomColor: Bool
    var needsDivider: Bool
    var action: () -> Void = {}
    var toggleAction: (() -> Void)?
    @Binding var isToggled: Bool
    var important_bolded: Bool
    var indexInput: Int?
    var bg_needed: Bool
    var type: sqbuttontype
    var pickerOptions: [String]
    var NavigationDestination: AnyView? // Make it optional and type-erased
    @Binding var selectedOption: String
    var description: String?
    var infoAlert: Bool = false
    var helpAlert: Bool = false
    var helpAlertLink: String?
    var infoAlertText: String?
    let colors: [Color] = [
        .purple, .yellow, .teal, .blue, .pink, .orange, .red, .green
    ]
    
    enum sqbuttontype {
        case button
        case picker
        case toggle
        case navigation
    }

    var body: some View {
        Group {
            // Handle picker type
            if type == .picker {
                Menu {
                    ForEach(pickerOptions, id: \.self) { option in
                        Button(action: {
                            selectedOption = option
                            action()
                        }) {
                            if selectedOption == option {
                                Label(option, systemImage: "checkmark")
                            } else {
                                Text(option)
                            }
                        }
                    }
                } label: {
                    buttonLabel
                }
            }
            // Handle navigation type
            else if type == .navigation {
                if let destination = NavigationDestination {
                    NavigationLink(destination: destination) {
                        buttonLabel
                    }
                } else {
                    // Fallback if no destination provided
                    Button(action: action) {
                        buttonLabel
                    }
                }
            }
            // Handle toggle type
            else if type == .toggle {
                Button {
                    withAnimation(.easeInOut) {
                        isToggled.toggle()
                        toggleAction?()
                    }
                } label: {
                    buttonLabel
                }
            }
            // Default button type
            else {
                Button(action: action) {
                    buttonLabel
                }
            }

            if needsDivider {
                Divider()
            }
        }
    }

    // A computed property for the button label to avoid repetition
    private var buttonLabel: some View {
        HStack {
            if !bgcircle {
                Image(systemName: systemimage)
                    .symbolRenderingMode(.hierarchical)
                    .font(.system(size: 30))
                    .foregroundStyle(type == .toggle ? (isToggled ? (randomColor ? randomColorForIndex() : tintcolor ?? .blue) : .gray) : (randomColor ? randomColorForIndex() : tintcolor ?? .blue))
            } else {
                Image(systemName: "arrow.down.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .font(.system(size: 30))
                    .foregroundStyle(.clear)
                    .overlay(alignment: .center) {
                        ZStack {
                            Circle()
                                .foregroundStyle(type == .toggle ? (isToggled ? (randomColor ? randomColorForIndex() : tintcolor ?? .blue) : .gray) : (randomColor ? randomColorForIndex() : tintcolor ?? .blue))
                                .opacity(0.2)
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: systemimage)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundStyle(type == .toggle ? (isToggled ? (randomColor ? randomColorForIndex() : tintcolor ?? .blue) : .gray) : (randomColor ? randomColorForIndex() : tintcolor ?? .blue))
                                .symbolRenderingMode(.hierarchical)
                        }
                    }
            }

            
            if type == .picker {
                
                    VStack {
                        if #available(iOS 17.0, *) {
                            Text(text)
                                .foregroundStyle(colorScheme == .light ? .black : .white)
                                .fontWeight(important_bolded ? .bold : .regular)
                        } else {
                            Text(text)
                                .foregroundColor(colorScheme == .light ? .black : .white)
                                .fontWeight(important_bolded ? .bold : .regular)
                        }
                    }
                    .multilineTextAlignment(.leading)
                    
            } else if description != nil {
                VStack {
                    if #available(iOS 17.0, *) {
                        Text("\(text)\n")
                            .foregroundStyle(colorScheme == .light ? .black : .white)
                            .fontWeight(important_bolded ? .bold : .regular)
                        +
                        Text(description!)
                            .foregroundStyle(.gray)
                            .font(.footnote)
                    } else {
                        Text("\(text)\n")
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            .fontWeight(important_bolded ? .bold : .regular)
                        
                        +
                        Text(description!)
                            .foregroundColor(.secondary)
                            .font(.footnote)
                    }
                }
                .opacity(type == .toggle && !isToggled ? 0.3 : 1) // Adjust opacity for toggle
                .multilineTextAlignment(.leading)
            } else {
                VStack {
                    Text(text)
                        .foregroundStyle(colorScheme == .light ? .black : .white)
                        .fontWeight(important_bolded ? .bold : .regular)
                        .opacity(type == .toggle && !isToggled ? 0.3 : 1) // Adjust opacity for toggle
                }
            }
            Spacer()
            if type == .picker {
                HStack {
                    if #available(iOS 17.0, *) {
                        Text(selectedOption)
                            .foregroundStyle(.gray)
                            .font(.footnote)
                    } else {
                        Text(selectedOption)
                            .foregroundColor(.secondary)
                            .font(.footnote)
                    }
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundStyle(.gray)
                        .font(.caption)
                }
            } else if infoAlert {
                Button {
                    showInfoAlert(NSLocalizedString(infoAlertText!, comment: "SQButton Info Popup"))
                } label: {
                    Image(systemName:"info.circle")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.blue)
                        .font(.system(size: 20))
                }
            } else if helpAlert {
                Button {
                    UIApplication.shared.helpAlert(title: NSLocalizedString("Info", comment: "info header"), body: NSLocalizedString(infoAlertText!, comment: "SQButton Info Help Popup"), link: helpAlertLink!)
                } label: {
                    Image(systemName:"info.circle")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.blue)
                        .font(.system(size: 20))
                }
            }
        }
    }

    func showInfoAlert(_ body: String) {
        UIApplication.shared.alert(title: "Info", body: body)
    }
    private func randomColorForIndex() -> Color {
        return colors[(indexInput ?? Int.random(in: 0..<colors.count)) % colors.count]
    }
}


#Preview {
    PreviewWrapper()
}

struct PreviewWrapper: View {
    @State private var autoReboot: Bool = false
    @State private var selectedOption: String = "Option 1"
    
    var body: some View {
        VStack(spacing: 20) {
            SQ_Button(text: "Auto reboot after apply",
                      systemimage: "restart.circle.fill",
                      bgcircle: false,
                      tintcolor: nil,
                      randomColor: false,
                      needsDivider: false,
                      action: {},
                      toggleAction: {
                          print("Auto reboot toggled: \(autoReboot)")
                      },
                      isToggled: $autoReboot,
                      important_bolded: false,
                      indexInput: nil,
                      bg_needed: false,
                      type: .toggle,
                      pickerOptions: [],
                      selectedOption: $selectedOption) // Pass the binding for selectedOption

            SQ_Button(text: "Select Option",
                      systemimage: "arrow.down.circle.fill",
                      bgcircle: false,
                      tintcolor: nil,
                      randomColor: false,
                      needsDivider: false,
                      action: {
                          print("Selected: \(selectedOption)")
                      },
                      toggleAction: nil,
                      isToggled: .constant(false),
                      important_bolded: false,
                      indexInput: nil,
                      bg_needed: false,
                      type: .picker,
                      pickerOptions: ["Option 1", "Option 2", "Option 3"],
                      selectedOption: $selectedOption) // Pass the binding for selectedOption
        }
        .padding()
    }
    
}


