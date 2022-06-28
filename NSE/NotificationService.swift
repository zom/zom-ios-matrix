//
//  NotificationService.swift
//  NSE
//
//  Created by N-Pex on 17.6.22.
//  Copyright © 2022 Zom. All rights reserved.
//

import KeanuNSE

class NotificationService: BaseNotificationService {
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        BaseNotificationService.config = Config.self
        BaseNotificationService.applicationGroupIdentifier = Constants.appGroup as String?
        super.didReceive(request, withContentHandler: contentHandler)
    }
}
