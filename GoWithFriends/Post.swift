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
}

//UserDefaults.standard.set(name, forKey: "username")
//UserDefaults.standard.set("\(url!)", forKey: "image")
//UserDefaults.standard.set(uid, forKey: "userid")
//UserDefaults.standard.set(favorites, forKey: "favorites")
//UserDefaults.standard.set(friends, forKey: "friends")
//UserDefaults.standard.set("", forKey: "friendId")
//UserDefaults.standard.set(self.isloggedin, forKey: "isloggedin")
