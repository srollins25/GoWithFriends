//
//  Notification.swift
//  GoWithFriends
//
//  Created by stephan rollins on 6/27/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import Foundation

struct Notification: Identifiable{
    var id: String
    var type: String
    var idFor: String
    var userNotificationIsFrom: String
    var userNotificationIsFor: String
    var createdAt: NSNumber
}
