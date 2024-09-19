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
//    let skipSetup: Bool
    let resettingTweaks: [TweakPage]
    
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
                            succeeded = ApplyHandler.shared.reset(tweaks: resettingTweaks, udid: udid)
                        } else {
                            succeeded = ApplyHandler.shared.apply(udid: udid/*, skipSetup: skipSetup*/)
                        }
                        if succeeded && autoReboot && (log.contains("Restore Successful") || log.contains("crash_on_purpose")) {
                            print("Rebooting device...")
                            MobileDevice.rebootDevice(udid: udid)
                        } else if log.contains("Find My") {
                            UIApplication.shared.alert(body: "Find My must be disabled in order to use this tool.\n\nDisable Find My from Settings (Settings -> [Your Name] -> Find My) and then try again.")
                        }
                    }
                }
            }
        }
        .navigationTitle("Log output")
    }
    
    init(resetting: Bool, autoReboot: Bool,/* skipSetup: Bool,*/ resettingTweaks: [TweakPage] = []) {
        self.resetting = resetting
        self.autoReboot = autoReboot
//        self.skipSetup = skipSetup
        self.resettingTweaks = resettingTweaks
        setvbuf(stdout, nil, _IOLBF, 0) // make stdout line-buffered
        setvbuf(stderr, nil, _IONBF, 0) // make stderr unbuffered
        
        // create the pipe and redirect stdout and stderr
        dup2(logPipe.fileHandleForWriting.fileDescriptor, fileno(stdout))
        dup2(logPipe.fileHandleForWriting.fileDescriptor, fileno(stderr))
    }
}
