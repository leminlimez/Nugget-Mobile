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
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
