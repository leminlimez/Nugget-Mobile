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
    
    let gestaltManager = MobileGestaltManager.shared
    let ffManager = FeatureFlagManager.shared
//    let statusManager = StatusManagerSwift.shared
    
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
                        print("RUNNING TEST")
                        runTest()
                    }
                }
            }
        }
        .navigationTitle("Log output")
    }
    
    init(resetting: Bool) {
        self.resetting = resetting
        setvbuf(stdout, nil, _IOLBF, 0) // make stdout line-buffered
        setvbuf(stderr, nil, _IONBF, 0) // make stderr unbuffered
        
        // create the pipe and redirect stdout and stderr
        dup2(logPipe.fileHandleForWriting.fileDescriptor, fileno(stdout))
        dup2(logPipe.fileHandleForWriting.fileDescriptor, fileno(stderr))
    }
    
    func runTest() {
        // TODO: Move Applying to its own file
        let deviceList = MobileDevice.deviceList()
        guard deviceList.count == 1 else {
            print("Invalid device count: \(deviceList.count)")
            return
        }
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folder = documentsDirectory.appendingPathComponent(deviceList.first!, conformingTo: .data)
        
        do {
            // Apply mobilegestalt changes
            var mobileGestaltData: Data? = nil
            if resetting {
                mobileGestaltData = try gestaltManager.reset()
            } else {
                mobileGestaltData = try gestaltManager.apply()
            }
            
            try? FileManager.default.removeItem(at: folder)
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: false)
            
            var backupFiles: [BackupFile] = [
                Directory(path: "", domain: "RootDomain"),
                Directory(path: "Library", domain: "RootDomain"),
                Directory(path: "Library/Preferences", domain: "RootDomain")
            ]
//            var backupFiles: [BackupFile] = [
//                Directory(path: "", domain: "HomeDomain"),
//                Directory(path: "Library", domain: "HomeDomain"),
//                Directory(path: "Library/SpringBoard", domain: "HomeDomain")
//            ]
//            var statusBarData: Data = Data()
//            if !resetting {
//                statusBarData = try statusManager.apply()
//            }
//            backupFiles.append(ConcreteFile(path: "Library/SpringBoard/statusBarOverrides", domain: "HomeDomain", contents: statusBarData, owner: 501, group: 501))
            if mobileGestaltData != nil {
                addExploitedConcreteFile(list: &backupFiles, path: "/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches/com.apple.MobileGestalt.plist", contents: mobileGestaltData!)
            }
            // Apply feature flag changes
            var ffData: Data? = nil
            if resetting {
                ffData = try ffManager.reset()
            } else {
                ffData = try ffManager.apply()
            }
            if let ffData = ffData {
                addExploitedConcreteFile(list: &backupFiles, path: "/var/preferences/FeatureFlags/Global.plist", contents: ffData)
            }
            backupFiles.append(ConcreteFile(path: "", domain: "SysContainerDomain-../../../../../../../../crash_on_purpose", contents: Data(), owner: 501, group: 501))
            let mbdb = Backup(files: backupFiles)
            try mbdb.writeTo(directory: folder)
            
            // Restore now
             let restoreArgs = [
             "idevicebackup2",
             "-n", "restore", "--no-reboot", "--system",
             documentsDirectory.path(percentEncoded: false)
             ]
             print("Executing args: \(restoreArgs)")
             var argv = restoreArgs.map{ strdup($0) }
             let result = idevicebackup2_main(Int32(restoreArgs.count), &argv)
             print("idevicebackup2 exited with code \(result)")
             logPipe.fileHandleForReading.readabilityHandler = nil
        } catch {
            print(error.localizedDescription)
            return
        }
    }
    
    func addExploitedConcreteFile(list: inout [BackupFile], path: String, contents: Data, owner: Int32 = 0, group: Int32 = 0) {
        let url = URL(filePath: path)
        list.append(Directory(path: "", domain: "SysContainerDomain-../../../../../../../../var/.backup.i\(url.deletingLastPathComponent().path(percentEncoded: false))", owner: owner, group: group))
        list.append(ConcreteFile(path: "", domain: "SysContainerDomain-../../../../../../../../var/.backup.i\(url.path(percentEncoded: false))", contents: contents, owner: owner, group: group))
    }
}
