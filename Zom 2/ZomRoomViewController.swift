//
//  RoomViewController+Zom.swift
//  Zom 2
//
//  Created by N-Pex on 30.01.19.
//  Copyright © 2019 Zom. All rights reserved.
//

import Keanu
import MatrixSDK

class ZomRoomViewController: RoomViewController {
    
    override func viewDidLoad() {
        initializeForZom()
        super.viewDidLoad()
    }
    
    func initializeForZom() {
        // Set the delegate for the attachment picker, please see the RoomViewController extension.
        attachmentPickerDelegate = self
    }
    
    @IBAction open func stickerButtonPressed(_ sender: Any) {
        let vc = UIApplication.shared.router.stickerPack()
        vc.pickDelegate = self
        present(UINavigationController(rootViewController: vc), animated: true)
    }
}

/**
 Extension to RoomViewController, handles styling of attachent picker actions
 */
extension RoomViewController: RoomViewControllerAttachmentPickerDelegate {
    public func addActions(attachmentPicker: AttachmentPicker, room: MXRoom?) {
        // Style the buttons
        for actionButton in attachmentPicker.actions {
            actionButton.backgroundColor = UITheme.shared.mainThemeColor
            actionButton.tintColor = UIColor.white
        }
    }
}
