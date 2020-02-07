//
//  DiscoverViewController+Zom.swift
//  Zom 2
//
//  Created by N-Pex on 20.03.19.
//  Copyright © 2019 Zom. All rights reserved.
//

import Keanu
import MatrixSDK

extension DiscoverViewController {
    func initializeForZom() {
        delegate = self
    }
}

extension DiscoverViewController: DiscoverViewControllerDelegate {
    
    static let identifierBots = "bots"
    static let identifierChangeTheme = "changeTheme"

    public func initializeRows(identifiers: [String]) -> [String] {
        var rows = identifiers
        rows.insert(DiscoverViewController.identifierBots, at: 0)
        rows.append(DiscoverViewController.identifierChangeTheme)
        return rows
    }
    
    public func setupRow(identifier: String, cell: ActionButtonCell) -> Bool {
        switch identifier {
        case DiscoverViewController.identifierBots:
            cell.apply("", "Zom Services".localize())
            return true
        case DiscoverViewController.identifierChangeTheme:
            cell.apply("", "Change Theme".localize())
            return true
        default: return false
        }
    }
    
    public func didSelectRow(identifier: String) -> Bool {
        switch identifier {
        case DiscoverViewController.identifierBots:
            if let vc = ZomBotsViewController.instantiate(){
                navigationController?.pushViewController(vc, animated: true)
            }
            return true
        case DiscoverViewController.identifierChangeTheme:
            if let vc = ZomPickColorViewController.instantiate(selectionCallback: { (color) in
                // Select new color as theme color
                UITheme.shared.selectMainThemeColor(color)
            }){
                // Ideally we would want a "push" here like above, but then selecting a color and getting back here would not update all of the UI without ugly hacks.
                // See: https://stackoverflow.com/questions/21652957/uinavigationbar-appearance-refresh/21653004
                present(vc, animated: true, completion: nil)
            }
            return true
        default: return false
        }
    }
}
