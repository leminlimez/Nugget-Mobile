//
//  Extensions.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import Foundation

extension URL {
    static var documents: URL {
        return FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    static var tweaksDirectory: URL {
        if !FileManager.default.fileExists(atPath: URL.documents.appendingPathComponent("Tweaks").path) {
            try? FileManager.default.createDirectory(at: URL.documents.appendingPathComponent("Tweaks"), withIntermediateDirectories: true)
        }
        return URL.documents.appendingPathComponent("Tweaks")
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
