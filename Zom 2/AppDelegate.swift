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
        
        // Initialize theme
        let _ = Theme.shared
        
        // Overridden to provide config data
        Keanu.setUp(with: Config.self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("[\(String(describing: type(of: self)))] Background fetch initiated")

        // Initialize theme
        let _ = Theme.shared

        // Overridden to provide config data
        Keanu.setUp(with: Config.self)
        
        // App entry point. Setup needs to be done.
        super.application(application, performFetchWithCompletionHandler: completionHandler)
    }
    
    /**
     Listen to events when storyboard view controllers are instantiated. This allows us to override specific styles, set delegates etc.
     */
    override func storyboard(_ storyboard: UIStoryboard, instantiatedInitialViewController viewController: UIViewController?) {
        if let viewController = viewController as? UINavigationController,
            let roomViewController = viewController.viewControllers[0] as? RoomViewController {
            roomViewController.initializeForZom()
        } else if let tabViewController = viewController as? UITabBarController {
            for tabVC in tabViewController.viewControllers ?? [] {
                if let tabVC = tabVC as? UINavigationController,
                    let discoverVC = tabVC.viewControllers[0] as? UITableViewController {
                    //discoverVC.tableView.dataSource = nil
                    //discoverVC.tableView.delegate = nil
                }
            }
        }
    }
}
