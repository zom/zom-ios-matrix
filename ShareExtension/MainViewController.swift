//
//  MainViewController.swift
//  ShareExtension
//
//  Created by Benjamin Erhart on 19.02.19.
//  Copyright © 2019 Guardian Project. All rights reserved.
//

import UIKit
import KeanuCore
import KeanuExtension

@objc(MainViewController)
class MainViewController: BaseMainViewController {
    
    override func viewDidLoad() {
        KeanuCore.setUp(with: Config.self)
        KeanuCore.setUpLocalization(fileName: "Localizable", bundle: Bundle.main)
        super.viewDidLoad()
    }
}

