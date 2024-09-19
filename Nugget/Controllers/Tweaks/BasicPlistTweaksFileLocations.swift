//
//  BasicPlistTweaksFileLocations.swift
//  Nugget
//
//  Created by lemin on 9/13/24.
//

import Foundation

enum FileLocation: String {
    // MobileGestalt Options
    case resolution = "/var/Managed Preferences/mobile/com.apple.iokit.IOMobileGraphicsFamily.plist"
    
    // Springboard Options
    case springboard = "/var/Managed Preferences/mobile/com.apple.springboard.plist"
    case footnote = "/var/containers/Shared/SystemGroup/systemgroup.com.apple.configurationprofiles/Library/ConfigurationProfiles/SharedDeviceConfiguration.plist"
    case uikit = "/var/Managed Preferences/mobile/com.apple.UIKit.plist"
    case wifiDebug = "/var/Managed Preferences/mobile/com.apple.MobileWiFi.debug.plist"
    case airdrop = "/var/Managed Preferences/mobile/com.apple.sharingd.plist"
    
    // Internal Options
    case globalPreferences = "/var/Managed Preferences/mobile/.GlobalPreferences.plist"
    case appStore = "/var/Managed Preferences/mobile/com.apple.AppStore.plist"
    case backboardd = "/var/Managed Preferences/mobile/com.apple.backboardd.plist"
    case coreMotion = "/var/Managed Preferences/mobile/com.apple.CoreMotion.plist"
    case pasteboard = "/var/Managed Preferences/mobile/com.apple.Pasteboard.plist"
    case notes = "/var/Managed Preferences/mobile/com.apple.mobilenotes.plist"
}

func getURLFromFileLocation(_ fileLocation: FileLocation) -> URL {
    let fileURL = URL.tweaksDirectory.appendingPathComponent(URL(fileURLWithPath: fileLocation.rawValue).lastPathComponent)
    if !FileManager.default.fileExists(atPath: fileURL.path) {
        guard let data = try? PropertyListSerialization.data(fromPropertyList: [:], format: .xml, options: 0) else { return fileURL }
        try? data.write(to: fileURL)
    }
    return fileURL
}
