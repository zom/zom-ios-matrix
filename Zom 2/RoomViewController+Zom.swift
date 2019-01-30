//
//  RoomViewController+Zom.swift
//  Zom 2
//
//  Created by N-Pex on 30.01.19.
//  Copyright © 2019 Zom. All rights reserved.
//

import Keanu
import MatrixSDK

/**
 Extension to RoomViewController, handles attachent picker actions
 */
extension RoomViewController: RoomViewControllerAttachmentPickerDelegate {
    public func addActions(attachmentPicker: AttachmentPicker, room: MXRoom?) {
        // Add sticker options last
        attachmentPicker.addAction("") {
            // Pick sticker!
            print("Pick")
        }
        
        // Style the buttons
        for actionButton in attachmentPicker.actions() {
            actionButton.backgroundColor = Theme.shared.mainThemeColor
            actionButton.tintColor = UIColor.white
        }
    }
}
