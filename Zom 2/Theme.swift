//
//  Theme.swift
//  Zom 2
//
//  Created by N-Pex on 29.01.19.
//

import UIKit
import Keanu

extension UIColor {
    public static let zomRed = UIColor(hexString: "#FFE7275A")
    public static let zomGreen = UIColor(hexString: "#FF7ED321")
    public static let zomGray = UIColor(hexString: "#FFF1F2F3")
    public static let zomDarkerGray = UIColor(hexString: "#FFCECECE")
}

class Theme: NSObject {
    
    private static let USER_DEFAULTS_THEME_COLOR_KEY = "zom_ThemeColor"
    
    /**
     Singleton instance.
     */
    public static let shared: Theme = {
        return Theme().setupAppearance()
    }()
    
    override init() {
        if let themeColorString = UserDefaults.standard.string(forKey: Theme.USER_DEFAULTS_THEME_COLOR_KEY) {
            mainThemeColor = UIColor(hexString: themeColorString)
        }
        else {
            mainThemeColor = UIColor.zomRed
        }
    }
    
    /**
     Resets the main theme color and the appearance of all `UIView`s to the given color.
     
     - parameter color: If nil, will use the default red-ish color.
     */
    func selectMainThemeColor(_ color: UIColor?) {
        let color = color ?? UIColor.zomRed
        
        mainThemeColor = color
        let _ = setupAppearance()
        
        let defaults = UserDefaults.standard
        defaults.set(color.hexString(), forKey: Theme.USER_DEFAULTS_THEME_COLOR_KEY)
        defaults.synchronize()
    }
    
    
    // MARK: AppColors
    
    var mainThemeColor: UIColor
    var lightThemeColor = UIColor.zomGray
    var buttonLabelColor = UIColor.white
    
    // MARK: AppAppearance
    
    func setupAppearance() -> Theme {
        UIView.appearance().tintColor = mainThemeColor
        
        var navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.isTranslucent = false
        navBarAppearance.tintColor = .white
        navBarAppearance.barTintColor = mainThemeColor
        navBarAppearance.backgroundColor = mainThemeColor
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        // On iOS 11 bar button items are descendants of button...
        UIButton.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = UIColor.white
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = .white
        tabBarAppearance.barTintColor = mainThemeColor
        tabBarAppearance.backgroundColor = mainThemeColor
        if #available(iOS 10.0, *) {
            tabBarAppearance.unselectedItemTintColor = .white
        }
        tabBarAppearance.selectionIndicatorImage = UIImage(named: "tab_background")
        
        UITableView.appearance().backgroundColor = lightThemeColor
        
        //UIApplication.shared.statusBarStyle = .lightContent
        
        UISwitch.appearance().tintColor = .zomDarkerGray
        UISwitch.appearance().onTintColor = mainThemeColor

        // Style segmented controls in title (active/archive)
        //
        UIView.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).tintColor = UIColor.white
        UISegmentedControl.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).backgroundColor = UIColor.clear
        UISegmentedControl.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = UIColor.green
        UISegmentedControl.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes([.foregroundColor: mainThemeColor], for: .selected)
        
        //UILabel.appearance(whenContainedInInstancesOf: [ZomTableViewSectionHeader.self]).textColor = mainThemeColor
        
        var buttonAppearance = UIButton.appearance(whenContainedInInstancesOf: [UITableView.self])
        buttonAppearance.backgroundColor = mainThemeColor
        buttonAppearance.tintColor = .white
        
        buttonAppearance = UIButton.appearance(whenContainedInInstancesOf: [UITableViewCell.self, UITableView.self])
        buttonAppearance.backgroundColor = nil
        buttonAppearance.tintColor = nil

//        buttonAppearance = UIButton.appearance(whenContainedInInstancesOf: [EnablePushViewController.self])
//        buttonAppearance.backgroundColor = nil
//        buttonAppearance.tintColor = nil

        // Buttons on photo overlay
        UIBarButtonItem.appearance(whenContainedInInstancesOf:
            [UIToolbar.self, UIView.self, PhotosViewController.self]).tintColor = .white
        UIButton.appearance(whenContainedInInstancesOf:
            [UIToolbar.self, UIView.self, PhotosViewController.self]).tintColor = .white
        
        let photosBarColor = UIColor.black.withAlphaComponent(0.7)
        navBarAppearance = UINavigationBar.appearance(whenContainedInInstancesOf: [PhotosViewController.self])
        navBarAppearance.tintColor = .white
        navBarAppearance.isTranslucent = true
        navBarAppearance.barTintColor = photosBarColor
        navBarAppearance.backgroundColor = photosBarColor
        
        let pageControlAppearance = UIPageControl.appearance()
        pageControlAppearance.pageIndicatorTintColor = mainThemeColor
        pageControlAppearance.currentPageIndicatorTintColor = .black
        pageControlAppearance.backgroundColor = .white
        
        return self
    }
}
