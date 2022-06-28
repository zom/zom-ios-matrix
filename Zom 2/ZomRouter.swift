//
//  ZomTheme.swift
//  Zom 2
//
//  Created by N-Pex 07.02.20.
//  Copyright © 2020 Zom. All rights reserved.
//

import Keanu

public class ZomRouter: Router {
        
    /**
     Singleton instance.
     */
    public static let shared = ZomRouter()
    
    public func welcome() -> WelcomeViewController {
        return ZomWelcomeViewController(nibName: String(describing: ZomWelcomeViewController.self),
                                        bundle: Bundle(for: type(of: self)))
    }

    public func addAccount() -> AddAccountViewController {
        return AddAccountViewController(nibName: "ZomAddAccountViewController",
                                        bundle: Bundle(for: type(of: self)))
    }

    public func enablePush() -> EnablePushViewController {
        return EnablePushViewController(nibName: "ZomEnablePushViewController",
                                        bundle: Bundle(for: type(of: self)))
    }

    public func main() -> MainViewController {
        return BaseRouter.shared.main()
    }

    public func chatList() -> ChatListViewController {
        return BaseRouter.shared.chatList()
    }

    public func discover() -> DiscoverViewController {
        return ZomDiscoverViewController()
    }

    public func me() -> MeViewController {
        return BaseRouter.shared.me()
    }

    public func myProfile() -> MyProfileViewController {
        return BaseRouter.shared.myProfile()
    }
    
    public func profileEdit() -> EditProfileViewController {
        return BaseRouter.shared.profileEdit()
    }

    public func profileNotifications() -> NotificationsViewController {
        return BaseRouter.shared.profileNotifications()
    }
    
    public func profilePreferences() -> PreferencesViewController {
        return BaseRouter.shared.profilePreferences()
    }

    public func profileAccount() -> AccountViewController {
        return BaseRouter.shared.profileAccount()
    }
    
    public func profileAbout() -> AboutViewController {
        return BaseRouter.shared.profileAbout()
    }

    public func room() -> RoomViewController {
        let vc = ZomRoomViewController()
        vc.hidesBottomBarWhenPushed = true
        return vc
    }

    public func roomSettings() -> RoomSettingsViewController {
        return BaseRouter.shared.roomSettings()
    }

    public func profile() -> ProfileViewController {
        return BaseRouter.shared.profile()
    }

    public func story() -> StoryViewController {
        return BaseRouter.shared.story()
    }

    public func storyAddMedia() -> StoryAddMediaViewController {
        return BaseRouter.shared.storyAddMedia()
    }

    public func storyGallery() -> StoryGalleryViewController {
        return BaseRouter.shared.storyGallery()
    }

    public func storyEditor() -> StoryEditorViewController {
        return BaseRouter.shared.storyEditor()
    }

    public func stickerPack() -> StickerPackViewController {
        return BaseRouter.shared.stickerPack()
    }

    public func pickSticker() -> PickStickerViewController {
        return BaseRouter.shared.pickSticker()
    }

    public func chooseFriends() -> ChooseFriendsViewController {
        return BaseRouter.shared.chooseFriends()
    }

    public func addFriend() -> AddFriendViewController {
        return BaseRouter.shared.addFriend()
    }

    public func showQr() -> ShowQrViewController {
        return BaseRouter.shared.showQr()
    }

    public func qrScan() -> QrScanViewController {
        return BaseRouter.shared.qrScan()
    }
    
    public func newDevice() -> NewDeviceViewController {
        return BaseRouter.shared.newDevice()
    }

    public func manualCompare() -> ManualCompareViewController {
        return BaseRouter.shared.manualCompare()
    }

    public func intrusion() -> IntrusionViewController {
        return BaseRouter.shared.intrusion()
    }

    public func verification() -> VerificationViewController {
        return BaseRouter.shared.verification()
    }
    
    public func photoStream() -> PhotoStreamViewController {
        return BaseRouter.shared.photoStream()
    }
    
    public func chatBubble(type: BubbleViewType, rect: CGRect) -> CGPath? {
        return BaseRouter.shared.chatBubble(type: type, rect: rect)
    }
}
