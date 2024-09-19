//
//  HelperFuncs.swift
//  Nugget
//
//  Created by lemin on 9/19/24.
//

import Foundation

class HelperFuncs {
    // from here: https://stackoverflow.com/questions/32929981/how-to-deep-merge-2-swift-dictionaries
    static func deepMerge(_ d1: [String: Any], _ d2: [String: Any]) -> [String: Any] {
        var result = d1
        for (k2, v2) in d2 {
            if let v1 = result[k2] as? [String: Any], let v2 = v2 as? [String: Any] {
                result[k2] = deepMerge(v1, v2)
            } else {
                result[k2] = v2
            }
        }
        return result
    }
}
