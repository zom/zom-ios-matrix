//
//  ZomWelcomeViewController.swift
//  Zom 2
//
//  Created by N-Pex on 08.05.19.
//  Copyright © 2019 Zom. All rights reserved.
//

import Keanu
import KeanuCore
import MatrixSDK
import Localize

class ZomWelcomeViewController: WelcomeViewController {

    @IBAction func switchLanguage() {
        var actions = [UIAlertAction]()

        for lang in Bundle.main.localizations {
            guard lang != "Base" else { continue }

            let title = Locale.current.localizedString(forIdentifier: lang)

            actions.append(AlertHelper.defaultAction(title, handler: { [weak self] _ in
                self?.setCurrentLanguage(code: lang)
            }))
        }

        actions.append(AlertHelper.cancelAction())

        AlertHelper.present(
            self, title: "Switch Language".localize(),
            style: .actionSheet, actions: actions)
    }
    
    func setCurrentLanguage(code: String) {
        UserDefaults.standard.set([code, "en"], forKey: "AppleLanguages")

        Localize.update(language: code)
        Localize.update(defaultLanguage: code)
        
        UIApplication.shared.startOnboardingFlow()
    }
}
