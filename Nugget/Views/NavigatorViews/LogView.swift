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
                        ApplyHandler.shared.apply(resetting: resetting, udid: udid)
                        if autoReboot && log.contains("crash_on_purpose") {
                            print("Rebooting device...")
                            MobileDevice.rebootDevice(udid: udid)
                        }
                    }
                }
            }
        }
        .navigationTitle("Log output")
    }
    
    init(resetting: Bool, autoReboot: Bool) {
        self.resetting = resetting
        self.autoReboot = autoReboot
        setvbuf(stdout, nil, _IOLBF, 0) // make stdout line-buffered
        setvbuf(stderr, nil, _IONBF, 0) // make stderr unbuffered
        
        // create the pipe and redirect stdout and stderr
        dup2(logPipe.fileHandleForWriting.fileDescriptor, fileno(stdout))
        dup2(logPipe.fileHandleForWriting.fileDescriptor, fileno(stderr))
    }
}
