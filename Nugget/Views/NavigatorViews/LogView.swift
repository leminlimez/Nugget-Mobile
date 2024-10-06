//
//  LogView.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import SwiftUI

let logPipe = Pipe()

struct LogView: View {
    let resetting: Bool
    let autoReboot: Bool
    let skipSetup: Bool
    
    @State var log: String = ""
    @State var ran = false
    @State private var selectedUDID: String?
    @State private var showDevicePicker = false
    @State private var deviceList: [String] = []

    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView {
                    Text(log)
                        .font(.system(size: 12).monospaced())
                        .fixedSize(horizontal: false, vertical: false)
                        .textSelection(.enabled)
                    Spacer()
                        .id(0)
                }
                .onAppear {
                    guard !ran else { return }
                    ran = true
                    
                    logPipe.fileHandleForReading.readabilityHandler = { fileHandle in
                        let data = fileHandle.availableData
                        if !data.isEmpty, let logString = String(data: data, encoding: .utf8) {
                            log.append(logString)
                            proxy.scrollTo(0)
                        }
                    }
                    
                    DispatchQueue.global(qos: .background).async {
                        print("APPLYING")
                        self.deviceList = MobileDevice.deviceList()

                        if deviceList.isEmpty {
                            DispatchQueue.main.async {
                                UIApplication.shared.alert(body: "No devices connected.")
                            }
                            return
                        } else if deviceList.count > 1 {
                            DispatchQueue.main.async {
                                self.showDevicePicker = true
                            }
                        } else {
                            let udid = deviceList.first!
                            applyOrRevert(udid: udid)
                        }
                    }
                }
            }
            .sheet(isPresented: $showDevicePicker) {
                VStack {
                    Picker("Select Device", selection: $selectedUDID) {
                        ForEach(deviceList, id: \.self) { udid in
                            Text(udid).tag(udid as String?)
                        }
                    }
                    .pickerStyle(.wheel)

                    Button("Apply/Revert") {
                        guard let chosenUDID = selectedUDID else {
                            showDevicePicker = false
                            return
                        }
                        showDevicePicker = false
                        applyOrRevert(udid: chosenUDID)
                    }
                }
                .padding()
            }
            .navigationTitle("Log output")
        }
    }

    func applyOrRevert(udid: String) {
        let succeeded = resetting ? ApplyHandler.shared.reset(udid: udid) : ApplyHandler.shared.apply(udid: udid, skipSetup: skipSetup)

        if succeeded && (log.contains("Restore Successful") || log.contains("crash_on_purpose")) {
            if autoReboot {
                print("Rebooting device...")
                MobileDevice.rebootDevice(udid: udid)
            } else {
                UIApplication.shared.alert(title: "Success!", body: "Restart your device to see changes.")
            }
        } else if log.contains("Find My") {
            UIApplication.shared.alert(body: "Disable Find My to use this tool.")
        } else if log.contains("Could not receive from mobilebackup2") {
            UIApplication.shared.alert(body: "Error: mobilebackup2. Restart the app.")
        }
    }

    init(resetting: Bool, autoReboot: Bool, skipSetup: Bool) {
        self.resetting = resetting
        self.autoReboot = autoReboot
        self.skipSetup = skipSetup
        setvbuf(stdout, nil, _IOLBF, 0)
        setvbuf(stderr, nil, _IONBF, 0)
        dup2(logPipe.fileHandleForWriting.fileDescriptor, fileno(stdout))
        dup2(logPipe.fileHandleForWriting.fileDescriptor, fileno(stderr))
    }
}
