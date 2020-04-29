//
//  PokeUser.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/21/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import Foundation

struct PokeUser: Identifiable{
    
    var id: String
    var name: String
    var image: String
    var email: String
    var comments: [Post] = []
    var posts: [Post] = []
    var createdAt: NSNumber
}
