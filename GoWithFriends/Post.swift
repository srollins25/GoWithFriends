//
//  Post.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/17/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import Foundation

struct Post: Identifiable{
    
    //create seperate file for posts
    
    var id: String
    var userID: String
    var name: String
    var image: String
    var postBody: String
    var comments: String
    var favorites: String
    var createdAt: NSNumber
}
