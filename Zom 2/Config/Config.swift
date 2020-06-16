//
//  Config.swift
//  Keanu
//
//  Created by Benjamin Erhart on 10.01.19.
//  Copyright © 2019 Guardian Project. All rights reserved.
//

import KeanuCore

/**
 Keanu-compatible configuration object filled with data from `Config.xcconfig`
 via Objective-C `Constants` object.
 */
struct Config: KeanuConfig {
    
    static var defaultHomeServer = Constants.defaultHomeServer as String
    
    static var defaultIdServer = Constants.defaultIdServer as String
    
    static var appUrlScheme: String {
        get {
            if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
                let info = NSDictionary(contentsOfFile: path),
                let urlTypes = info.object(forKey: "CFBundleURLTypes") as? NSArray,
                let urlType = urlTypes[0] as? NSDictionary,
                let schemes = urlType.object(forKey: "CFBundleURLSchemes") as? NSArray,
                let scheme = schemes[0] as? NSString
            {
                return scheme as String
            }
            
            return ""
        }
    }
    
    static var pushAppIdDev = "\(Bundle.main.bundleIdentifier!).ios.dev"
    
    static var pushAppIdRelease = "\(Bundle.main.bundleIdentifier!).ios.release"
    
    static var pushServer = Constants.pushServer as String
    
    static var appGroupId = Constants.appGroup as String?
    
    static var universalLinkHost = Constants.universalLinkHost as String
    
    static var inviteLinkFormat = "https://\(Constants.universalLinkHost as String)/i/#%@"
    
    static var useExperimentalAirShare: Bool = {
        let val = (Constants.useExperimentalAirShare as String?)?
            .trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // "true" in xcconfig *should* evaluate to "1". Anyway, we test for these
        // other trueness values, just in case.
        return val == "1" || val == "true" || val == "yes"
    }()
}

