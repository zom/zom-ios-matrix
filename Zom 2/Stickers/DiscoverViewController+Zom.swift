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
    public func initializeRows(identifiers: [String]) -> [String] {
        var rows = identifiers
        rows.append("changeTheme")
        return rows
    }
    
    public func setupRow(identifier: String, cell: ActionButtonCell) -> Bool {
        if identifier == "changeTheme" {
            cell.apply("", "Change Theme".localize())
            return true
        }
        return false
    }
    
    public func didSelectRow(identifier: String) -> Bool {
        if identifier == "changeTheme" {
            if let vc = ZomPickColorViewController.instantiate(selectionCallback: { (color) in
                // Select new color as theme color
                Theme.shared.selectMainThemeColor(color)
            }){
                present(vc, animated: true, completion: nil)
            }
            return true
        }
        return false
    }
}