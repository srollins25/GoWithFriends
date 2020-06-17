//
//  Raid.swift
//  GoWithFriends
//
//  Created by stephan rollins on 6/16/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import Foundation
import SwiftUI

struct Raid : Identifiable
{
    var id: ObjectIdentifier
    var lat: Double?
    var lon: Double?
    var name: String?
    var cp: NSNumber?
    var timeTillStart: String?
    var timeTillEnd: String?
    var difficulty: NSNumber?
    var dexnum: String?
}

