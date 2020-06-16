//
//  PokeUser.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/21/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import Foundation
import Combine

struct PokeUser: Identifiable{
    
    var id: String
    var name: String
    var profileimage: String
    var email: String
    //var comments: [Post] = []
    var user_posts: [String] = []
    var createdAt: NSNumber
    
    init(id: String, name: String, profileimage: String, email: String,  user_posts: [String], createdAt: NSNumber){
        self.id = id
        self.name = name
        self.profileimage = profileimage
        self.email = email
        self.user_posts = user_posts
        self.createdAt = createdAt
        
    }
}
