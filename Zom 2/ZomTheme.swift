//
//  ZomTheme.swift
//  Zom 2
//
//  Created by N-Pex 07.02.20.
//  Copyright © 2020 Zom. All rights reserved.
//

import Keanu

public class ZomTheme: Theme {

    /**
     Singleton instance.
     */
    public static let shared = ZomTheme()
    
    public func createRoomViewController() -> RoomViewController {
        let vc = ZomRoomViewController()
        vc.hidesBottomBarWhenPushed = true
        return vc
    }

    public func createRoomSettingsViewController() -> RoomSettingsViewController {
        return BaseTheme.shared.createRoomSettingsViewController()
    }

    public func createProfileViewController() -> ProfileViewController {
        return BaseTheme.shared.createProfileViewController()
    }

    public func createStoryViewController() -> StoryViewController {
        return BaseTheme.shared.createStoryViewController()
    }

    public func createStoryEditorViewController() -> StoryEditorViewController {
        return BaseTheme.shared.createStoryEditorViewController()
    }

    public func createChooseFriendsViewController() -> ChooseFriendsViewController {
        return BaseTheme.shared.createChooseFriendsViewController()
    }

    public func createAddFriendViewController() -> AddFriendViewController {
        return BaseTheme.shared.createAddFriendViewController()
    }

    public func createShowQrViewController() -> ShowQrViewController {
        return BaseTheme.shared.createShowQrViewController()
    }

    public func createVerificationViewController() -> VerificationViewController {
        return BaseTheme.shared.createVerificationViewController()
    }

    public func createPhotoStreamViewController() -> PhotoStreamViewController {
        BaseTheme.shared.createPhotoStreamViewController()
    }
}