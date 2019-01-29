//
//  AppDelegate.swift
//  Zom 2
//
//  Created by N-Pex on 28.01.19.
//  Copyright © 2019 Zom. All rights reserved.
//

import UIKit
import UserNotifications
import Keanu

@UIApplicationMain
class AppDelegate: BaseAppDelegate {
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Overridden to provide config data
        Keanu.setUp(with: Config.self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("[\(String(describing: type(of: self)))] Background fetch initiated")
        
        // Overridden to provide config data
        Keanu.setUp(with: Config.self)
        
        // App entry point. Setup needs to be done.
        super.application(application, performFetchWithCompletionHandler: completionHandler)
    }
}
