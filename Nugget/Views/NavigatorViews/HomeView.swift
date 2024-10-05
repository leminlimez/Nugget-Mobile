//
//  HomeView.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct HomeView: View {
    private let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""

    @Environment(\.colorScheme) var colorScheme

    @State var showRevertPage = false
    @State var showPairingFileImporter = false
    @State var showErrorAlert = false
    @State var lastError: String?
    @State var path = NavigationPath()
    @State var minimuxerReady = false

    @AppStorage("AutoReboot") var autoReboot: Bool = true
    @AppStorage("PairingFile") var pairingFile: String?
    @AppStorage("SkipSetup") var skipSetup: Bool = true

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                Image("nuggetlogo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.top)
                Text("Nugget (SQ214)")
                    .font(.largeTitle.weight(.bold))

                Text("Version \(Bundle.main.releaseVersionNumber ?? "UNKNOWN") (\(Int(buildNumber) != 0 ? "Beta \(buildNumber)" : "Release"))")
                    .foregroundStyle(.secondary)
                    .bold()

                HStack {
                    Image(systemName: "switch.2")
                        .font(.system(size: 20))
                    Text("Tweak Options")
                        .bold()
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.top)

                Section {
                    VStack {
                        SQ_Button(text: "Apply Tweaks", systemimage: "hammer.circle.fill", bgcircle: false, tintcolor: .blue, randomColor: false, needsDivider: true, action: { applyChanges(reverting: false) }, toggleAction: nil, isToggled: .constant(false), important_bolded: false, indexInput: nil, bg_needed: false, type: .button, pickerOptions: [], NavigationDestination: nil, selectedOption: .constant(""), infoAlert: true, infoAlertText: "Applies all selected tweaks.")

                        SQ_Button(text: "Remove All Tweaks", systemimage: "minus.circle.fill", bgcircle: false, tintcolor: .red, randomColor: false, needsDivider: true, action: { showRevertPage.toggle() }, toggleAction: nil, isToggled: .constant(false), important_bolded: false, indexInput: nil, bg_needed: false, type: .button, pickerOptions: [], NavigationDestination: nil, selectedOption: .constant(""), infoAlert: true, infoAlertText: "Removes all tweaks and reverts the device to its original state, including resetting the mobilegestalt plist.")
                            .sheet(isPresented: $showRevertPage) {
                                RevertTweaksPopoverView(revertFunction: applyChanges(reverting:))
                            }

                        let pairingFileButtonImage = pairingFile == nil ? "document.circle.fill" : "arrow.uturn.left.circle.fill"
                        let pairingFileButtonText = pairingFile == nil ? "Select Pairing File" : "Reset Pairing File"
                        let pairingFileButtonAction = pairingFile == nil ? { showPairingFileImporter.toggle() } : { pairingFile = nil }
                        let pairingFileButtonTintColor = pairingFile == nil ? Color.green : Color.orange
                        let pairingFileButtonHelpAlert = pairingFile == nil
                        let pairingFileButtonInfoAlertText = pairingFile == nil ?  "Select a pairing file. Tap \"Help\" for more info." : ""

                        SQ_Button(text: pairingFileButtonText, systemimage: pairingFileButtonImage, bgcircle: false, tintcolor: pairingFileButtonTintColor, randomColor: false, needsDivider: false, action: pairingFileButtonAction, toggleAction: nil, isToggled: .constant(false), important_bolded: false, indexInput: nil, bg_needed: false, type: .button, pickerOptions: [], NavigationDestination: nil, selectedOption: .constant(""), helpAlert: pairingFileButtonHelpAlert, helpAlertLink: "https://docs.sidestore.io/docs/getting-started/pairing-file", infoAlertText: pairingFileButtonInfoAlertText)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .foregroundStyle(.regularMaterial)
                            .frame(width: 316)
                    }
                    .frame(width: 316)

                    VStack {
                        SQ_Button(text: "Auto reboot after apply", systemimage: "restart.circle.fill", bgcircle: false, tintcolor: .green, randomColor: false, needsDivider: true, action: {}, toggleAction: nil, isToggled: $autoReboot, important_bolded: false, indexInput: nil, bg_needed: false, type: .toggle, pickerOptions: [], NavigationDestination: nil, selectedOption: .constant(""), infoAlert: true, infoAlertText: "Automatically restarts your device after applying changes.")

                        SQ_Button(text: "Traditional Skip Setup", systemimage: "arrow.left.arrow.right.circle.fill", bgcircle: false, tintcolor: .green, randomColor: false, needsDivider: false, action: {}, toggleAction: nil, isToggled: $skipSetup, important_bolded: false, indexInput: nil, bg_needed: false, type: .toggle, pickerOptions: [], NavigationDestination: nil, selectedOption: .constant(""), infoAlert: true, infoAlertText: "Applies Cowabunga Lite's Skip Setup method.")
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .foregroundStyle(.regularMaterial)
                            .frame(width: 316)
                    }
                    .frame(width: 316)
                }
                .listStyle(.insetGrouped)
                .listRowInsets(EdgeInsets())
                .fileImporter(isPresented: $showPairingFileImporter, allowedContentTypes: [UTType(filenameExtension: "mobiledevicepairing", conformingTo: .data)!, UTType(filenameExtension: "mobiledevicepair", conformingTo: .data)!]) { result in
                    switch result {
                    case .success(let url):
                        if let pairingFileData = try? String(contentsOf: url) {
                            pairingFile = pairingFileData
                            startMinimuxer()
                        } else {
                            handlePairingFileError("Failed to read pairing file contents.")
                        }
                    case .failure(let error):
                        handlePairingFileError(error.localizedDescription)
                    }
                }


                // MARK: App Credits
                HStack {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 20))
                    Text("Credits & Contributions")
                        .bold()
                    Spacer()
                }
                VStack {
                    Button {
                        UIApplication.shared.open(URL(string: "https://github.com/Singapore214")!)
                    } label: {
                        HStack {
                            Image("LeminLimez")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                            if #available(iOS 17.0, *) {
                                VStack {
                                    Text("leminlimez\n")
                                        .foregroundStyle(colorScheme == .light ? .black : .white)
                                        .fontWeight(.bold)
                                    +
                                    Text("Main Logic")
                                        .foregroundStyle(.gray)
                                        .font(.footnote)
                                }
                                .multilineTextAlignment(.leading)
                            } else {
                                VStack {
                                    Text("leminlimez4\n")
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                        .fontWeight(.bold)
                                    +
                                    Text("Main Logic")
                                        .foregroundColor(.gray)
                                        .font(.footnote)
                                }
                                .multilineTextAlignment(.leading)
                            }
                            Spacer()
                        }
                        .padding(.leading)
                        .padding(.trailing)
                    }
                    Divider()
                    Button {
                        UIApplication.shared.open(URL(string: "https://github.com/Singapore214")!)
                    } label: {
                        HStack {
                            Image("sq214")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                            if #available(iOS 17.0, *) {
                                VStack {
                                    Text("Singapore214\n")
                                        .foregroundStyle(colorScheme == .light ? .black : .white)
                                        .fontWeight(.bold)
                                    +
                                    Text("UI Design & Logic Updates")
                                        .foregroundStyle(.gray)
                                        .font(.footnote)
                                }
                                .multilineTextAlignment(.leading)
                            } else {
                                VStack {
                                    Text("Singapore214\n")
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                        .fontWeight(.bold)
                                    +
                                    Text("UI Design & Logic Updates")
                                        .foregroundColor(.gray)
                                        .font(.footnote)
                                }
                                .multilineTextAlignment(.leading)
                            }
                            Spacer()
                        }
                        .padding(.leading)
                        .padding(.trailing)
                    }
                    Divider()
                    Button {
                        UIApplication.shared.open(URL(string: "https://discord.com")!)
                    } label: {
                        HStack {
                            Image("fun")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                            if #available(iOS 17.0, *) {
                                VStack {
                                    Text("long\n")
                                        .foregroundStyle(colorScheme == .light ? .black : .white)
                                        .fontWeight(.bold)
                                    +
                                    Text("Idea Giver")
                                        .foregroundStyle(.gray)
                                        .font(.footnote)
                                }
                                .multilineTextAlignment(.leading)
                            } else {
                                VStack {
                                    Text("long\n")
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                        .fontWeight(.bold)
                                    +
                                    Text("Idea Giver")
                                        .foregroundColor(.gray)
                                        .font(.footnote)
                                }
                                .multilineTextAlignment(.leading)
                            }
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        Spacer()
                    }
                    Divider()
                    Button {
                        UIApplication.shared.open(URL(string: "https://github.com/khanhduytran0/SparseBox")!)
                    } label: {
                        HStack {
                            Image("khanhduytran")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                            if #available(iOS 17.0, *) {
                                VStack {
                                    Text("khanhduytran\n")
                                        .foregroundStyle(colorScheme == .light ? .black : .white)
                                        .fontWeight(.bold)
                                    +
                                    Text("SparseBox")
                                        .foregroundStyle(.gray)
                                        .font(.footnote)
                                }
                                .multilineTextAlignment(.leading)
                            } else {
                                VStack {
                                    Text("khanhduytran\n")
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                        .fontWeight(.bold)
                                    +
                                    Text("SparseBox")
                                        .foregroundColor(.gray)
                                        .font(.footnote)
                                }
                                .multilineTextAlignment(.leading)
                            }
                            Spacer()
                        }
                        .padding(.leading)
                        .padding(.trailing)
                    }
                    Divider()
                    Button {
                        UIApplication.shared.open(URL(string: "https://github.com/JJTech0130/TrollRestore")!)
                    } label: {
                        HStack {
                            Image("jjtech")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                            
                            if #available(iOS 17.0, *) {
                                VStack {
                                    Text("JJTech0130\n")
                                        .foregroundStyle(colorScheme == .light ? .black : .white)
                                        .fontWeight(.bold)
                                    +
                                    Text("Sparserestore")
                                        .foregroundStyle(.gray)
                                        .font(.footnote)
                                }
                                .multilineTextAlignment(.leading)
                            } else {
                                VStack {
                                    Text("JJTech0130\n")
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                        .fontWeight(.bold)
                                    +
                                    Text("Sparserestore")
                                        .foregroundColor(.gray)
                                        .font(.footnote)
                                }
                                .multilineTextAlignment(.leading)
                            }
                            Spacer()
                        }
                        .padding(.leading)
                        .padding(.trailing)
                    }
                    Divider()
                    Button {
                        UIApplication.shared.open(URL(string: "https://x.com/disfordottie")!)
                    } label: {
                        HStack {
                            Image("disfordottie")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                            if #available(iOS 17.0, *) {
                                VStack {
                                    Text("disfordottie\n")
                                        .foregroundStyle(colorScheme == .light ? .black : .white)
                                        .fontWeight(.bold)
                                    +
                                    Text("Some Global Flag Features")
                                        .foregroundStyle(.gray)
                                        .font(.footnote)
                                }
                                .multilineTextAlignment(.leading)
                            } else {
                                VStack {
                                    Text("disfordottie\n")
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                        .fontWeight(.bold)
                                    +
                                    Text("Some Global Flag Features")
                                        .foregroundColor(.gray)
                                        .font(.footnote)
                                }
                                .multilineTextAlignment(.leading)
                            }
                            Spacer()
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        
                    }
                    Divider()
                    Button {
                        UIApplication.shared.open(URL(string: "https://gist.github.com/f1shy-dev/23b4a78dc283edd30ae2b2e6429129b5#file-eligibility-plist")!)
                    } label: {
                        HStack {
                            Image("f1shy-dev")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                            if #available(iOS 17.0, *) {
                                VStack {
                                    Text("f1shy-dev\n")
                                        .foregroundStyle(colorScheme == .light ? .black : .white)
                                        .fontWeight(.bold)
                                    +
                                    Text("AI Enabler")
                                        .foregroundStyle(.gray)
                                        .font(.footnote)
                                }
                                .multilineTextAlignment(.leading)
                            } else {
                                VStack {
                                    Text("f1shy-dev\n")
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                        .fontWeight(.bold)
                                    +
                                    Text("AI Enabler")
                                        .foregroundColor(.gray)
                                        .font(.footnote)
                                }
                                .multilineTextAlignment(.leading)
                            }
                            Spacer()
                        }
                        .padding(.leading)
                        .padding(.trailing)
                    }
                    Divider()
                    
                    Button {
                        UIApplication.shared.open(URL(string: "https://sidestore.io/")!)
                    } label: {
                        HStack {
                            Image("SideStore")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                            if #available(iOS 17.0, *) {
                                VStack {
                                    Text("SideStore\n")
                                        .foregroundStyle(colorScheme == .light ? .black : .white)
                                        .fontWeight(.bold)
                                    +
                                    Text("em_proxy and minimuxer")
                                        .foregroundStyle(.gray)
                                        .font(.footnote)
                                }
                                .multilineTextAlignment(.leading)
                            } else {
                                VStack {
                                    Text("SideStore\n")
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                        .fontWeight(.bold)
                                    +
                                    Text("em_proxy and minimuxer")
                                        .foregroundColor(.gray)
                                        .font(.footnote)
                                }
                                .multilineTextAlignment(.leading)
                            }
                            Spacer()
                        }
                        .padding(.leading)
                        .padding(.trailing)
                    }
                    Divider()
                    Button {
                        UIApplication.shared.open(URL(string: "https://libimobiledevice.org")!)
                    } label: {
                        HStack {
                            Image("libimobile")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                            if #available(iOS 17.0, *) {
                                VStack {
                                    Text("libimobiledevice\n")
                                        .foregroundStyle(colorScheme == .light ? .black : .white)
                                        .fontWeight(.bold)
                                    +
                                    Text("Restore Library")
                                        .foregroundStyle(.gray)
                                        .font(.footnote)
                                }
                                .multilineTextAlignment(.leading)
                            } else {
                                VStack {
                                    Text("libimobiledevice\n")
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                        .fontWeight(.bold)
                                    +
                                    Text("Restore Library")
                                        .foregroundColor(.gray)
                                        .font(.footnote)
                                }
                                .multilineTextAlignment(.leading)
                            }
                            Spacer()
                        }
                        .padding(.leading)
                        .padding(.trailing)
                    }
                }
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .foregroundStyle(.regularMaterial)
                        .frame(width: 316)
                }
                .frame(width: 316)
                .padding(.bottom)

            }
            .overlay(alignment: .top) {
                VariableBlurView()
                    .frame(height: getStatusBarHeight())
                    .edgesIgnoringSafeArea(.top)
            }
            .onOpenURL { url in
                if url.pathExtension.lowercased() == "mobiledevicepairing" {
                    do {
                        pairingFile = try String(contentsOf: url)
                        startMinimuxer()
                    } catch {
                        lastError = error.localizedDescription
                        showErrorAlert.toggle()
                    }
                }
            }
            .onAppear {
                _ = start_emotional_damage("127.0.0.1:51820")
                if let altPairingFile = Bundle.main.object(forInfoDictionaryKey: "ALTPairingFile") as? String, altPairingFile.count > 5000, pairingFile == nil {
                    pairingFile = altPairingFile
                } else if pairingFile == nil, FileManager.default.fileExists(atPath: URL.documents.appendingPathComponent("pairingfile.mobiledevicepairing").path) {
                    pairingFile = try? String(contentsOf: URL.documents.appendingPathComponent("pairingfile.mobiledevicepairing"))
                }
                startMinimuxer()
            }
            .navigationDestination(for: String.self) { view in
                if view == "ApplyChanges" {
                    LogView(resetting: false, autoReboot: autoReboot, skipSetup: skipSetup)
                } else if view == "RevertChanges" {
                    LogView(resetting: true, autoReboot: autoReboot, skipSetup: skipSetup)
                }
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK") {}
            } message: {
                Text(lastError ?? "???")
            }
        }
    }

    init() {
        if let fixMethod = class_getInstanceMethod(UIDocumentPickerViewController.self, Selector(("fix_initForOpeningContentTypes:asCopy:"))), let origMethod = class_getInstanceMethod(UIDocumentPickerViewController.self, #selector(UIDocumentPickerViewController.init(forOpeningContentTypes:asCopy:))) {
            method_exchangeImplementations(origMethod, fixMethod)
        }
    }

    func applyChanges(reverting: Bool) {
        guard pairingFile != nil else {
            UIApplication.shared.alert(body: "Please add a pairing file.")
            return
        }

        guard minimuxerReady else {
            lastError = "minimuxer is not ready. Ensure you have WiFi and a working VPN connection if necessary, then try selecting your pairing file again."
            showErrorAlert = true
            return
        }

        if !reverting && ApplyHandler.shared.allEnabledTweaks().isEmpty {
            UIApplication.shared.alert(body: "You do not have any tweaks enabled! Go to the tools page to select some.")
            return
        }


        if ApplyHandler.shared.isExploitOnly() || skipSetup {
            path.append(reverting ? "RevertChanges" : "ApplyChanges")
        } else {
            UIApplication.shared.confirmAlert(title: "Warning!", body: "You are applying non-exploit related files. This will make the setup screen appear. Click Cancel if you do not wish to proceed.\n\nWhen setting up, you MUST click \"Do not transfer apps & data\".\n\nIf you see a screen that says \"iPhone Partially Set Up\", DO NOT tap the big blue button. You must click \"Continue with Partial Setup\".", onOK: {
                path.append(reverting ? "RevertChanges" : "ApplyChanges")
            }, noCancel: false)
        }
    }



    func getStatusBarHeight() -> CGFloat {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.statusBarManager?.statusBarFrame.height ?? 44
    }

    func startMinimuxer() {
        guard pairingFile != nil else { return }

        // 1. Dispatch to a background thread to avoid blocking the UI
        DispatchQueue.global(qos: .userInitiated).async {
            target_minimuxer_address() // Call this on the background thread

            var success = false
            do {
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString
                try start(pairingFile!, documentsDirectory)
                success = true

            } catch {
                print("Error starting minimuxer: \(error)")
            }

            
            DispatchQueue.main.async {
                minimuxerReady = success
                if !success {
                    lastError = "Failed to start minimuxer. Check your network connection, VPN, and pairing file."
                    showErrorAlert = true
                }
            }
        }
    }




    public func withArrayOfCStrings<R>(_ args: [String], _ body: ([UnsafeMutablePointer<CChar>?]) -> R) -> R {
        var cStrings = args.map { strdup($0) }
        cStrings.append(nil)
        defer { cStrings.forEach { free($0) } }
        return body(cStrings)
    }
    
    private func handlePairingFileError(_ errorMessage: String) {
        lastError = errorMessage
        showErrorAlert = true
    }
}
