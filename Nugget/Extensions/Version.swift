//
//  Version.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import Foundation

class Version: Comparable {
    static func < (lhs: Version, rhs: Version) -> Bool {
        return lhs.compareTo(other: rhs) == -1
    }
    static func == (lhs: Version, rhs: Version) -> Bool {
        return lhs.compareTo(other: rhs) == 0
    }
    
    let major: Int
    let minor: Int
    let patch: Int
    
    init(string: String) {
        let nums = string.split(separator: ".")
        self.major = Int(nums[0])!
        self.minor = (nums.count > 1) ? Int(nums[1]) ?? 0 : 0
        self.patch = (nums.count > 2) ? Int(nums[2]) ?? 0 : 0
    }
    
    private func compareTo(other: Version) -> Int {
        if self.major > other.major {
            return 1
        } else if self.major < other.major {
            return -1
        }
        if self.minor > other.minor {
            return 1
        } else if self.minor < other.minor {
            return -1
        }
        if self.patch > other.patch {
            return 1
        } else if self.patch < other.patch {
            return -1
        }
        return 0
    }
}
