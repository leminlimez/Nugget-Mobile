//
//  HomeView.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct HomeView: View {
    private let buildNumber = 1
    
    @AppStorage("PairingFile") var pairingFile: String?
    @State var showPairingFileImporter = false
    @State var showErrorAlert = false
    @State var lastError: String?
    
    var body: some View {
        NavigationView {
            List {
                // MARK: App Version
                Section {
                    
                } header: {
                    Label("Version \(Bundle.main.releaseVersionNumber ?? "UNKNOWN") (\(buildNumber != 0 ? "beta \(buildNumber)" : NSLocalizedString("Release", comment:"")))", systemImage: "info")
                }
                
                // MARK: Tweak Options
                Section {
                    // apply all tweaks button
                    HStack {
                        ZStack {
                            NavLinkButton(label: "Apply Tweaks", color: .blue)
                            NavigationLink("") {
                                LogView(resetting: false)
                            }.opacity(0)
                        }
                        Button {
                            UIApplication.shared.alert(title: NSLocalizedString("Info", comment: "info header"), body: NSLocalizedString("Applies all selected tweaks.", comment: "apply tweaks info"))
                        } label: {
                            Image(systemName: "info")
                        }
                        .buttonStyle(TintedButton(material: .systemMaterial, fullwidth: false))
                    }
                    // remove all tweaks button
                    HStack {
                        ZStack {
                            NavLinkButton(label: "Remove All Tweaks", color: .red)
                            NavigationLink("") {
                                LogView(resetting: true)
                            }.opacity(0)
                        }
                        Button {
                            UIApplication.shared.alert(title: NSLocalizedString("Info", comment: "info header"), body: NSLocalizedString("Removes and reverts all tweaks, including mobilegestalt.", comment: "remove tweaks info"))
                        } label: {
                            Image(systemName: "info")
                        }
                        .buttonStyle(TintedButton(material: .systemMaterial, fullwidth: false))
                    }
                    // select pairing file button
                    if pairingFile == nil {
                        HStack {
                            Button("Select Pairing File") {
                                showPairingFileImporter.toggle()
                            }
                            .buttonStyle(TintedButton(color: .green, fullwidth: true))
                            Button {
                                UIApplication.shared.alert(title: NSLocalizedString("Info", comment: "info header"), body: NSLocalizedString("Select a pairing file in order to restore the device. One can be gotten from apps like AltStore or SideStore.", comment: "pairing file selector info"))
                            } label: {
                                Image(systemName: "info")
                            }
                            .buttonStyle(TintedButton(material: .systemMaterial, fullwidth: false))
                        }
                    }
                } header: {
                    Label("Tweak Options", systemImage: "hammer")
                }
                .listRowInsets(EdgeInsets())
                .padding()
                .fileImporter(isPresented: $showPairingFileImporter, allowedContentTypes: [UTType(filenameExtension: "mobiledevicepairing", conformingTo: .data)!], onCompletion: { result in
                                switch result {
                                case .success(let url):
                                    guard url.startAccessingSecurityScopedResource() else {
                                        return
                                    }
                                    pairingFile = try! String(contentsOf: url)
                                    url.stopAccessingSecurityScopedResource()
                                    startMinimuxer()
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
                } header: {
                    Label("Credits", systemImage: "wrench.and.screwdriver")
                }
            }
            .onAppear {
                _ = start_emotional_damage("127.0.0.1:51820")
                if let altPairingFile = Bundle.main.object(forInfoDictionaryKey: "ALTPairingFile") as? String, altPairingFile.count > 5000, pairingFile == nil {
                    pairingFile = altPairingFile
                }
                startMinimuxer()
            }
        }
        .navigationTitle("Nugget")
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK") {}
        } message: {
            Text(lastError ?? "???")
        }
    }
    
    struct NavLinkButton: View {
        var label: String
        var color: Color
        var material: UIBlurEffect.Style?
        
        var body: some View {
            VStack(alignment: .center) {
                Text(label)
                    .padding(15)
                    .frame(maxWidth: .infinity)
                    .background(material == nil ? AnyView(color.opacity(0.2)) : AnyView(MaterialView(material!)))
                    .cornerRadius(8)
                    .foregroundColor(color)
            }
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
