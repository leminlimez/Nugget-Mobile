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
                        if ApplyHandler.shared.trollstore {
                            // apply with trollstore
                            var succeeded: Bool = false
                            if resetting {
                                succeeded = ApplyHandler.shared.reset(udid: "", trollstore: true)
                            } else {
                                succeeded = ApplyHandler.shared.apply(udid: "", skipSetup: false, trollstore: true)
                            }
                            if succeeded {
                                // respring device
                                UIApplication.shared.alert(title: "Success!", body: "Please respring your device to apply changes.")
                            } else {
                                UIApplication.shared.alert(body: "Please read logs for full error info")
                            }
                            return
                        }
                        // get the device and create a directory for the backup files
                        let deviceList = MobileDevice.deviceList()
                        var udid: String
                        guard deviceList.count == 1 else {
                            print("Invalid device count: \(deviceList.count)")
                            return
                        }
                        
                        udid = deviceList.first!
                        var succeeded: Bool = false
                        if resetting {
                            succeeded = ApplyHandler.shared.reset(udid: udid, trollstore: false)
                        } else {
                            succeeded = ApplyHandler.shared.apply(udid: udid, skipSetup: skipSetup, trollstore: false)
                        }
                        if succeeded && (log.contains("Restore Successful") || log.contains("crash_on_purpose")) {
                            if autoReboot {
                                print("Rebooting device...")
                                MobileDevice.rebootDevice(udid: udid)
                            } else {
                                UIApplication.shared.alert(title: "Success!", body: "Please restart your device to see changes.")
                            }
                        /* Error Dialogs Below */
                        } else if log.contains("Find My") {
                            UIApplication.shared.alert(body: "Find My must be disabled in order to use this tool.\n\nDisable Find My from Settings (Settings -> [Your Name] -> Find My) and then try again.")
                        } else if log.contains("Could not receive from mobilebackup2") {
                            UIApplication.shared.alert(body: "Failed to receive requests from mobilebackup2. Please restart the app and try again.")
                        }
                    }
                }
            }
        }
        .navigationTitle("Log output")
    }
    
    init(resetting: Bool, autoReboot: Bool, skipSetup: Bool) {
        self.resetting = resetting
        self.autoReboot = autoReboot
        self.skipSetup = skipSetup
        setvbuf(stdout, nil, _IOLBF, 0) // make stdout line-buffered
        setvbuf(stderr, nil, _IONBF, 0) // make stderr unbuffered
        
        // create the pipe and redirect stdout and stderr
        dup2(logPipe.fileHandleForWriting.fileDescriptor, fileno(stdout))
        dup2(logPipe.fileHandleForWriting.fileDescriptor, fileno(stderr))
    }
}
