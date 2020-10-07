//
//  Bundle+Zom.swift
//  Zom 2
//
//  Created by N-Pex on 08.05.19.
//  Copyright © 2019 Zom. All rights reserved.
//

import Localize

extension Bundle {
    
    /**
     Need to swizzle the localizedString(forKey:value:table:) API in order to support hot-swapping of languages (via the "Switch Language" button in onboarding).
     */
    @objc public static func swizzle() {
        ZomUtil.swizzle(self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), swizzledSelector:#selector(Bundle.zom_localizedString(forKey:value:table:)))
    }
    
    @objc public func zom_localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        var language = UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String ?? "Base"
        if language == "en" {
            language = "Base"
        }
        if
            !self.bundlePath.hasSuffix(language + ".lproj"),
            let path = path(forResource: language, ofType: "lproj"),
            let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: key, value: value, table: tableName) 
        } else {
            return zom_localizedString(forKey: key, value: value, table: tableName)
        }
    }
}
