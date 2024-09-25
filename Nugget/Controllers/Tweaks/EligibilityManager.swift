//
//  EligibilityManager.swift
//  Nugget
//
//  Created by lemin on 9/20/24.
//

import Foundation
import UIKit

class EligibilityManager: ObservableObject {
    static let shared = EligibilityManager()
    
    @Published var spoofingDevice: Bool = false
    
    /* Eligibility Tweaks */
    @Published var euEnabler: Bool = false
    @Published var aiEnabler: Bool = false
    
    func setRegionCode(_ dict: [String: Any], newRegion: String) -> [String: Any] {
        var newDict = dict
        for (k, v) in dict {
            if let v = v as? String, v.contains("US") {
                newDict[k] = v.replacingOccurrences(of: "US", with: newRegion)
                break
            } else if let subDict = v as? [String: Any] {
                newDict[k] = self.setRegionCode(subDict, newRegion: newRegion)
            }
        }
        return newDict
    }
    
    func getEuEnablerPlist(_ name: String) -> Data {
        if let url = Bundle.main.url(forResource: name, withExtension: "plist"), let data = try? Data(contentsOf: url) {
            if var plist = String(data: data, encoding: .utf8) {
                // apply the region code
                if let regionCode = Locale.current.regionCode {
                    print("Applying for region code: \(regionCode)")
                    plist = plist.replacingOccurrences(of: "US", with: regionCode)
                }
                return plist.data(using: .utf8) ?? Data()
            }
        }
        return Data()
    }
    
    func getAiPlist() -> [String: Any] {
        let plist: [String: Any] = [
            "OS_ELIGIBILITY_DOMAIN_CALCIUM": [
                "os_eligibility_answer_source_t": 1,
                "os_eligibility_answer_t": 2,
                "status": [
                    "OS_ELIGIBILITY_INPUT_CHINA_CELLULAR": 2
                ]
            ],
            "OS_ELIGIBILITY_DOMAIN_GREYMATTER": [
                "context": [
                    "OS_ELIGIBILITY_CONTEXT_ELIGIBLE_DEVICE_LANGUAGES": ["en"]
                ],
                "os_eligibility_answer_source_t": 1,
                "os_eligibility_answer_t": 4,
                "status": [
                    "OS_ELIGIBILITY_INPUT_DEVICE_LANGUAGE": 3,
                    "OS_ELIGIBILITY_INPUT_DEVICE_REGION_CODE": 3,
                    "OS_ELIGIBILITY_INPUT_EXTERNAL_BOOT_DRIVE": 3,
                    "OS_ELIGIBILITY_INPUT_GENERATIVE_MODEL_SYSTEM": 3,
                    "OS_ELIGIBILITY_INPUT_SHARED_IPAD": 3,
                    "OS_ELIGIBILITY_INPUT_SIRI_LANGUAGE": 3
                ]
            ]
        ]
        return plist
    }
    
    func toggleAI(_ enabled: Bool) {
        aiEnabler = enabled
        if enabled {
            MobileGestaltManager.shared.setGestaltValue(key: "A62OafQ85EJAiiqKn4agtg", value: 1)
            // add mobile gestalt to enabled tweaks
            ApplyHandler.shared.setTweakEnabled(.MobileGestalt, isEnabled: true)
        } else {
            MobileGestaltManager.shared.removeGestaltValues(keys: ["A62OafQ85EJAiiqKn4agtg", "h9jDsbgj7xIVeIQ8S3/X3Q"])
            if spoofingDevice {
                spoofingDevice = false
            }
            // remove mobile gestalt from enabled tweaks if no other tweak is being applied
            if !MobileGestaltManager.shared.hasGestaltChanges() {
                ApplyHandler.shared.setTweakEnabled(.MobileGestalt, isEnabled: false)
            }
        }
    }
    
    func setDeviceModelCode(_ enabled: Bool) {
        spoofingDevice = enabled
        if enabled {
            var newModel = "iPhone17,3"
            if UIDevice.current.userInterfaceIdiom == .pad {
                newModel = "iPad16,3"
            }
            MobileGestaltManager.shared.setGestaltValue(key: "h9jDsbgj7xIVeIQ8S3/X3Q", value: newModel)
        } else {
            if let model = MobileGestaltManager.shared.deviceModel {
                MobileGestaltManager.shared.setGestaltValue(key: "h9jDsbgj7xIVeIQ8S3/X3Q", value: model)
            } else {
                MobileGestaltManager.shared.removeGestaltValue(key: "h9jDsbgj7xIVeIQ8S3/X3Q")
            }
        }
    }
    
    func apply() throws -> [String: Data] {
        var changes: [String: Data] = [:]
//        if euEnabler {
//            // eligibility.plist
//            let eligData = getEuEnablerPlist("eligibility")
//            changes["/var/db/os_eligibility/eligibility.plist"] = eligData
//            // Config.plist
//            let confData = getEuEnablerPlist("Config")
//            changes["/var/MobileAsset/AssetsV2/com_apple_MobileAsset_OSEligibility/purpose_auto/c55a421c053e10233e5bfc15c42fa6230e5639a9.asset/AssetData/Config.plist"] = confData
//        }
        if aiEnabler {
            // eligibility.plist
            let eligPlist = getAiPlist()
            let eligData = try PropertyListSerialization.data(fromPropertyList: eligPlist, format: .xml, options: 0)
            changes["/var/db/eligibilityd/eligibility.plist"] = eligData
        }
        return changes
    }
    
    func revert() throws -> [String: Data] {
//        var changes: [String: Data] = [
//            "/var/db/os_eligibility/eligibility.plist": Data(),
//            "/var/MobileAsset/AssetsV2/com_apple_MobileAsset_OSEligibility/purpose_auto/c55a421c053e10233e5bfc15c42fa6230e5639a9.asset/AssetData/Config.plist": Data()
//        ]
//        return changes
        return [:]
    }
}
