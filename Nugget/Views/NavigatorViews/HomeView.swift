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
    
    @State var showRevertPage = false
    @State var showPairingFileImporter = false
    @State var showErrorAlert = false
    @State var lastError: String?
    @State var path = NavigationPath()
    
    // Prefs
    @AppStorage("AutoReboot") var autoReboot: Bool = true
    @AppStorage("PairingFile") var pairingFile: String?
    @AppStorage("SkipSetup") var skipSetup: Bool = true
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                // MARK: App Version
                Section {
                    
                } header: {
                    Label("Version \(Bundle.main.releaseVersionNumber ?? "UNKNOWN") (\(Int(buildNumber) != 0 ? "beta \(buildNumber)" : NSLocalizedString("Release", comment:"")))", systemImage: "info")
                }
                .listStyle(InsetGroupedListStyle())
                
                // MARK: Tweak Options
                Section {
                    VStack {
                        // apply all tweaks button
                        HStack {
                            Button("Apply Tweaks") {
                                applyChanges(reverting: false)
                            }
                            .buttonStyle(TintedButton(color: .blue, fullwidth: true))
                            Button {
                                UIApplication.shared.alert(title: NSLocalizedString("Info", comment: "info header"), body: NSLocalizedString("Applies all selected tweaks.", comment: "apply tweaks info"))
                            } label: {
                                Image(systemName: "info")
                            }
                            .buttonStyle(TintedButton(material: .systemMaterial, fullwidth: false))
                        }
                        // remove all tweaks button
                        HStack {
                            Button("Remove All Tweaks") {
                                showRevertPage.toggle()
                            }
                            .buttonStyle(TintedButton(color: .red, fullwidth: true))
                            .sheet(isPresented: $showRevertPage, content: {
                                RevertTweaksPopoverView(revertFunction: applyChanges(reverting:))
                            })
                            Button {
                                UIApplication.shared.alert(title: NSLocalizedString("Info", comment: "info header"), body: NSLocalizedString("Removes and reverts all tweaks, including mobilegestalt.", comment: "remove tweaks info"))
                            } label: {
                                Image(systemName: "info")
                            }
                            .buttonStyle(TintedButton(material: .systemMaterial, fullwidth: false))
                        }
                        // select pairing file button
                        if !ApplyHandler.shared.trollstore {
                                if pairingFile == nil {
                                HStack {
                                    Button("Select Pairing File") {
                                        showPairingFileImporter.toggle()
                                    }
                                    .buttonStyle(TintedButton(color: .green, fullwidth: true))
                                    Button {
                                        UIApplication.shared.helpAlert(title: NSLocalizedString("Info", comment: "info header"), body: NSLocalizedString("Select a pairing file in order to restore the device. One can be gotten from apps like AltStore or SideStore. Tap \"Help\" for more info.", comment: "pairing file selector info"), link: "https://docs.sidestore.io/docs/getting-started/pairing-file")
                                    } label: {
                                        Image(systemName: "info")
                                    }
                                    .buttonStyle(TintedButton(material: .systemMaterial, fullwidth: false))
                                }
                            } else {
                                Button("Reset pairing file") {
                                    pairingFile = nil
                                }
                                .buttonStyle(TintedButton(color: .green, fullwidth: true))
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    // auto reboot option
                    HStack {
                        Toggle(isOn: $autoReboot) {
                            Text("Auto reboot after apply")
                                .minimumScaleFactor(0.5)
                        }
                    }
                    // skip setup
                    Toggle(isOn: $skipSetup) {
                        HStack {
                            Text("Traditional Skip Setup")
                                .minimumScaleFactor(0.5)
                            Spacer()
                            Button {
                                UIApplication.shared.alert(title: NSLocalizedString("Info", comment: "info header"), body: NSLocalizedString("Applies Cowabunga Lite's Skip Setup method to skip the setup for non-exploit files.\n\nThis may cause issues for some people, so turn it off if you use configuration profiles.\n\nThis will not be applied if you are only applying exploit files, as it will use the SparseRestore method to skip setup.", comment: "skip setup info"))
                            } label: {
                                Image(systemName: "info.circle")
                            }
                            .padding(.horizontal)
                        }
                    }
                } header: {
                    Label("Tweak Options", systemImage: "hammer")
                }
                .listStyle(InsetGroupedListStyle())
                .listRowInsets(EdgeInsets())
                .padding()
                .fileImporter(isPresented: $showPairingFileImporter, allowedContentTypes: [UTType(filenameExtension: "mobiledevicepairing", conformingTo: .data)!, UTType(filenameExtension: "mobiledevicepair", conformingTo: .data)!], onCompletion: { result in
                                switch result {
                                case .success(let url):
                                    do {
                                        pairingFile = try String(contentsOf: url)
                                        startMinimuxer()
                                    } catch {
                                        lastError = error.localizedDescription
                                        showErrorAlert.toggle()
                                    }
                                case .failure(let error):
                                    lastError = error.localizedDescription
                                    showErrorAlert.toggle()
                                }
                            })
                            .alert("Error", isPresented: $showErrorAlert) {
                                Button("OK") {}
                            } message: {
                                Text(lastError ?? "???")
                            }
                
                // MARK: App Credits
                Section {
                    // app credits
                    LinkCell(imageName: "leminlimez", url: "https://x.com/leminlimez", title: "leminlimez", contribution: NSLocalizedString("Main Developer", comment: "leminlimez's contribution"), circle: true)
                    LinkCell(imageName: "khanhduytran", url: "https://github.com/khanhduytran0/SparseBox", title: "khanhduytran0", contribution: "SparseBox", circle: true)
                    LinkCell(imageName: "jjtech", url: "https://github.com/JJTech0130/TrollRestore", title: "JJTech0130", contribution: "Sparserestore", circle: true)
                    LinkCell(imageName: "disfordottie", url: "https://x.com/disfordottie", title: "disfordottie", contribution: "Some Global Flag Features", circle: true)
                    LinkCell(imageName: "f1shy-dev", url: "https://gist.github.com/f1shy-dev/23b4a78dc283edd30ae2b2e6429129b5#file-eligibility-plist", title: "f1shy-dev", contribution: "AI Enabler", circle: true)
                    LinkCell(imageName: "app.gift", url: "https://sidestore.io/", title: "SideStore", contribution: "em_proxy and minimuxer", systemImage: true, circle: true)
                    LinkCell(imageName: "cable.connector", url: "https://libimobiledevice.org", title: "libimobiledevice", contribution: "Restore Library", systemImage: true, circle: true)
                } header: {
                    Label("Credits", systemImage: "wrench.and.screwdriver")
                }
            }
            .onOpenURL(perform: { url in
                // for opening the mobiledevicepairing file
                if url.pathExtension.lowercased() == "mobiledevicepairing" {
                    do {
                        pairingFile = try String(contentsOf: url)
                        startMinimuxer()
                    } catch {
                        lastError = error.localizedDescription
                        showErrorAlert.toggle()
                    }
                }
            })
            .onAppear {
                _ = start_emotional_damage("127.0.0.1:51820")
                if let altPairingFile = Bundle.main.object(forInfoDictionaryKey: "ALTPairingFile") as? String, altPairingFile.count > 5000, pairingFile == nil {
                    pairingFile = altPairingFile
                } else if pairingFile == nil, FileManager.default.fileExists(atPath: URL.documents.appendingPathComponent("pairingfile.mobiledevicepairing").path) {
                    pairingFile = try? String(contentsOf: URL.documents.appendingPathComponent("pairingfile.mobiledevicepairing"))
                }
                startMinimuxer()
            }
            .navigationTitle("Nugget")
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
        // Fix file picker
        if let fixMethod = class_getInstanceMethod(UIDocumentPickerViewController.self, Selector(("fix_initForOpeningContentTypes:asCopy:"))), let origMethod = class_getInstanceMethod(UIDocumentPickerViewController.self, #selector(UIDocumentPickerViewController.init(forOpeningContentTypes:asCopy:))) {
            method_exchangeImplementations(origMethod, fixMethod)
        }
    }
    
    func applyChanges(reverting: Bool) {
        if ApplyHandler.shared.trollstore || ready() {
            if !reverting && ApplyHandler.shared.allEnabledTweaks().isEmpty {
                // if there are no enabled tweaks then tell the user
                UIApplication.shared.alert(body: "You do not have any tweaks enabled! Go to the tools page to select some.")
            } else if ApplyHandler.shared.isExploitOnly() {
                path.append(reverting ? "RevertChanges" : "ApplyChanges")
            } else if !ApplyHandler.shared.trollstore {
                // if applying non-exploit files, warn about setup
                UIApplication.shared.confirmAlert(title: "Warning!", body: "You are applying non-exploit related files. This will make the setup screen appear. Click Cancel if you do not wish to proceed.\n\nWhen setting up, you MUST click \"Do not transfer apps & data\".\n\nIf you see a screen that says \"iPhone Partially Set Up\", DO NOT tap the big blue button. You must click \"Continue with Partial Setup\".", onOK: {
                    path.append(reverting ? "RevertChanges" : "ApplyChanges")
                }, noCancel: false)
            }
        } else if pairingFile == nil {
            lastError = "Please select your pairing file to continue."
            showErrorAlert.toggle()
        } else {
            lastError = "minimuxer is not ready. Ensure you have WiFi and WireGuard VPN set up."
            showErrorAlert.toggle()
        }
    }
    
    struct LinkCell: View {
        var imageName: String
        var url: String
        var title: String
        var contribution: String
        var systemImage: Bool = false
        var circle: Bool = false
        
        var body: some View {
            HStack(alignment: .center) {
                Group {
                    if systemImage {
                        Image(systemName: imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        if imageName != "" {
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                }
                .cornerRadius(circle ? .infinity : 0)
                .frame(width: 24, height: 24)
                
                VStack {
                    HStack {
                        Button(action: {
                            if url != "" {
                                UIApplication.shared.open(URL(string: url)!)
                            }
                        }) {
                            Text(title)
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal, 6)
                        Spacer()
                    }
                    HStack {
                        Text(contribution)
                            .padding(.horizontal, 6)
                            .font(.footnote)
                        Spacer()
                    }
                }
            }
            .foregroundColor(.blue)
        }
    }
    
    func startMinimuxer() {
        guard pairingFile != nil else {
            return
        }
        target_minimuxer_address()
        do {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString
            try start(pairingFile!, documentsDirectory)
        } catch {
            lastError = error.localizedDescription
            showErrorAlert.toggle()
        }
    }
    
    public func withArrayOfCStrings<R>(
        _ args: [String],
        _ body: ([UnsafeMutablePointer<CChar>?]) -> R
    ) -> R {
        var cStrings = args.map { strdup($0) }
        cStrings.append(nil)
        defer {
            cStrings.forEach { free($0) }
        }
        return body(cStrings)
    }
}
