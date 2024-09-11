//
//  StatusManagerSwift.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import Foundation
import SwiftUI

@objc class StatusManagerSwift: NSObject, ObservableObject {
    @objc static let shared = StatusManagerSwift()
    
    func apply() throws -> Data {
        let fm = FileManager.default
        let overridesURL = URL.documents.appendingPathComponent("statusBarOverrides")
        return try Data(contentsOf: overridesURL)
    }
    
    func reset() throws -> Data {
        return Data()
    }
    
    @objc func getDeviceVersion() -> String {
        return UIDevice.current.systemVersion
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
