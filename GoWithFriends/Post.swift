//
//  Post.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/17/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import Foundation

struct Post: Identifiable{
    
    var id: String
    var userID: String
    var name: String
    var trainerId: String
    var image: String
    var profileimage: String
    var postBody: String
    var comments: NSArray
    var favorites: NSNumber
    var createdAt: NSNumber
    var parentPost: String
    var isReported: Bool
}


