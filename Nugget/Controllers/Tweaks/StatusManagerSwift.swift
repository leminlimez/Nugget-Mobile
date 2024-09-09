//
//  StatusManagerSwift.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import Foundation

@objc class StatusManagerSwift: NSObject, ObservableObject {
    @objc static let shared = StatusManagerSwift()
    
    @Published var deviceVersion: String = "17.0"
    
    func apply() throws -> Data {
        let fm = FileManager.default
        let overridesURL = URL.documents.appendingPathComponent("statusBarOverrides")
        return try Data(contentsOf: overridesURL)
    }
    
    func reset() throws -> Data {
        return Data()
    }
    
    @objc func getDeviceVersion() -> String {
        return deviceVersion
    }
    
    @objc func getOverridesFileURL() -> URL {
        let fm = FileManager.default
        let overridesURL = URL.documents.appendingPathComponent("statusBarOverrides")
        if !fm.fileExists(atPath: overridesURL.path) {
            // write new file to the app's documents directory
            do {
                try Data().write(to: overridesURL)
            } catch {
                print(error.localizedDescription)
            }
        }
        return overridesURL
    }
}
