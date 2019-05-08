//
//  ZomWelcomeViewController.swift
//  Zom 2
//
//  Created by N-Pex on 08.05.19.
//  Copyright © 2019 Zom. All rights reserved.
//

import Keanu
import MatrixSDK
import Localize

class ZomWelcomeViewController: UIViewController {
    @IBAction func switchLanguage() {
        let alert = UIAlertController(title: "Switch Language".localize(), message: nil, preferredStyle: .actionSheet)
        
        for lang in Bundle.main.localizations {
            guard lang != "Base" else {continue}
            let title = Locale.current.localizedString(forIdentifier: lang)
            alert.addAction(UIAlertAction(title: title, style: .default , handler:{ (UIAlertAction)in
                self.setCurrentLanguage(code: lang)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel".localize(), style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }
    
    func setCurrentLanguage(code: String) {
        UserDefaults.standard.set([code, "en"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        Localize.update(language: code)
        Localize.update(defaultLanguage: code)
        UIApplication.shared.startOnboardingFlow()
    }
}
