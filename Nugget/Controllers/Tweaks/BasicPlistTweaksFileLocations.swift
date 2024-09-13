//
//  BasicPlistTweaksFileLocations.swift
//  Nugget
//
//  Created by lemin on 9/13/24.
//

import Foundation

enum FileLocation: String {
    // Springboard Options
    case springboard = "ManagedPreferencesDomain/mobile/com.apple.springboard.plist"
    case footnote = "SysSharedContainerDomain-systemgroup.com.apple.configurationprofiles/Library/ConfigurationProfiles/SharedDeviceConfiguration.plist"
    case wifi = "SystemPreferencesDomain/SystemConfiguration/com.apple.wifi.plist"
    case uikit = "ManagedPreferencesDomain/mobile/com.apple.UIKit.plist"
    case wifiDebug = "ManagedPreferencesDomain/mobile/com.apple.MobileWiFi.debug.plist"
    case airdrop = "ManagedPreferencesDomain/mobile/com.apple.sharingd.plist"
    
    // Internal Options
    case globalPreferences = "ManagedPreferencesDomain/mobile/.GlobalPreferences.plist"
    case appStore = "ManagedPreferencesDomain/mobile/com.apple.AppStore.plist"
    case backboardd = "ManagedPreferencesDomain/mobile/com.apple.backboardd.plist"
    case coreMotion = "ManagedPreferencesDomain/mobile/com.apple.CoreMotion.plist"
    case pasteboard = "HomeDomain/Library/Preferences/com.apple.Pasteboard.plist"
    case notes = "ManagedPreferencesDomain/mobile/com.apple.mobilenotes.plist"
}

func getURLFromFileLocation(_ fileLocation: FileLocation) -> URL {
    let fileURL = URL.tweaksDirectory.appendingPathComponent(fileLocation.rawValue.components(separatedBy: "/").last ?? "temp")
    if !FileManager.default.fileExists(atPath: fileURL.path) {
        guard let data = try? PropertyListSerialization.data(fromPropertyList: [:], format: .xml, options: 0) else { return fileURL }
        try? data.write(to: fileURL)
    }
    return fileURL
}
