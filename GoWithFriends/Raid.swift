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
    var id: String
    var user: String
    var lat: Double
    var lon: Double
    var name: String
    var cp: NSNumber
    var timeTillStart: NSNumber?
    var timeToRemove: NSNumber?
    var difficulty: NSNumber
    var dexnum: String
}

