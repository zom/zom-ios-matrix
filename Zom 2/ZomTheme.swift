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
    
    public func createProfileViewController() -> ProfileViewController {
        return BaseTheme.shared.createProfileViewController()
    }
}
