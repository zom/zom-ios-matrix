//
//  AppDelegate.swift
//  Zom 2
//
//  Created by N-Pex on 28.01.19.
//  Copyright © 2019 Zom. All rights reserved.
//

import UIKit
import UserNotifications
import KeanuCore
import Keanu
import MatrixKit

@UIApplicationMain
class AppDelegate: BaseAppDelegate {
    
    static let userDefaultsKeyMigratedZom1 = "migratedZom1"
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

// For debugging purposes: These are the folders, where all the stuff is stored.
// You can have a look at it, while running in the simulator!
//
//        let fm = FileManager.default
//
//        if let appGroupId = Config.appGroupId,
//            let container = fm.containerURL(forSecurityApplicationGroupIdentifier: appGroupId) {
//            print(container)
//        }
//        print(fm.urls(for: .libraryDirectory, in: .userDomainMask))


        // Initialize theme
        let _ = Theme.shared

        // Uncomment to take itunes snapshots!
        // NOTE! Also return "false" som RoomDataSource.canPageBackwards, otherwise the
        // mocking will show "Loading messages..." when it unsuccesfully tries to page back
        // to fill the screen!
        //if ProcessInfo.processInfo.arguments.contains("--mock") {
        //    MockData.setup()
        //}
        
        // Overridden to provide config data
        setUp()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("[\(String(describing: type(of: self)))] Background fetch initiated")

        // Initialize theme
        let _ = Theme.shared

        // Overridden to provide config data
        setUp()
        
        // App entry point. Setup needs to be done.
        super.application(application, performFetchWithCompletionHandler: completionHandler)
    }
    
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        setUp()
        super.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
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
                    let discoverVC = tabVC.viewControllers[0] as? DiscoverViewController {
                    discoverVC.initializeForZom()
                }
            }
        }
    }
    
    /**
     Inject configuration and set up localization.
     */
    private func setUp() {
        Bundle.swizzle()
        KeanuCore.setUp(with: Config.self)
        KeanuCore.setUpLocalization(fileName: "Localizable", bundle: Bundle.main)
        
        // Set formatter for "last message" so we can remove sticker short codes.
        MXRoomSummary.lastMessageFormatter = { summary in
            if let lastEvent = summary.lastMessageEvent, RoomViewController.isStickerEvent(event: lastEvent) {
                    return "Sticker".localize()
                }
            return nil
        }
        
        // Override the normal room toolbar to show a sticker button
        //
        RoomViewController.toolbarNibNormalMode = UINib(nibName: String(describing: RoomToolbar.self), bundle: Bundle.main)
        
        MessageCell.iconSecure = ""
        MessageCell.iconUnsecure = ""
        
        // If upgrading from "old" Zom, make sure to wipe all old data before proceeding
        //
        if let buildVersion = Int(Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String),
            buildVersion >= 201,
            !UserDefaults.standard.bool(forKey: AppDelegate.userDefaultsKeyMigratedZom1) {
            Scrubber.scrub()
            UserDefaults.standard.set(true, forKey: AppDelegate.userDefaultsKeyMigratedZom1)
        }
    }
}
