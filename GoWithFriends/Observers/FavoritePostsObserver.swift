//
//  FavoritePostsObserver.swift
//  GoWithFriends
//
//  Created by stephan rollins on 6/17/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import Foundation
import Firebase
import SwiftUI

class FavoritePostsObserver: ObservableObject {
    
    @Published var favoritePosts = [Post]()
    @State var favorites = UserDefaults.standard.array(forKey: "favorites") as? [String]
    
    init() {
        
        //let uid: String = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        
        db.collection("posts").addSnapshotListener { (snap, error) in
            
            if error != nil{
                print((error?.localizedDescription)!)
                return
            }

            
            for i in snap!.documentChanges
            {
                if(i.type == .added)
                {
                    
                    
                    let id = i.document.documentID
                    

                    
                    print("favorite posts2: ", self.favorites!.description)

                    //search id in posts
                    if(self.favorites!.contains(id))
                    {
                        let name = i.document.get("name") as! String
                        let userId = i.document.get("userId") as! String
                        let image = i.document.get("image") as! String
                        let profileimage = i.document.get("profileimage") as! String
                        let comments = i.document.get("comments") as! NSArray
                        let body = i.document.get("body") as! String
                        let favorites = i.document.get("favorites") as! NSNumber
                        let parentPost = i.document.get("parentPost") as! String
                        let createdAt = i.document.get("createdAt") as! NSNumber
                        
                        self.favoritePosts.append(Post(id: id, userID: userId, name: name, image: image, profileimage: profileimage, postBody: body, comments: comments, favorites: favorites, createdAt: createdAt, parentPost: parentPost))
                    }
                }
                
                if(i.type == .removed){
                    
                    let id = i.document.documentID
                    
                    for j in 0..<self.favoritePosts.count{
                        if (self.favoritePosts[j].id == id){
                            self.favoritePosts.remove(at: j)
                            return
                        }
                    }
                }
                
                if(i.type == .modified)
                {
                    let id = i.document.documentID
                    let favorites = i.document.get("favorites") as! NSNumber
                    let comments = i.document.get("comments") as! NSArray
                    
                    for j in 0..<self.favoritePosts.count
                    {
                        if(self.favoritePosts[j].id == id)
                        {
                            self.favoritePosts[j].favorites = favorites
                            self.favoritePosts[j].comments = comments
                            return
                        }
                    }
                }
            }
        }
    }
}
