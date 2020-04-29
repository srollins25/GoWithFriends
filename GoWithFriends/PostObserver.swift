//
//  PostObserver.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/17/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import Foundation
import FirebaseFirestore

class PostObserver: ObservableObject {
    
    @Published var posts = [Post]()
    //@Published var users = [PokeUser]()
    
    init() {
        let db = Firestore.firestore()
        db.collection("posts").addSnapshotListener { (snap, error) in
            
            if error != nil{
                print((error?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges {
                
                if(i.type == .added){
                    
                    let id = i.document.documentID
                    let name = i.document.get("name") as! String
                    let userId = i.document.get("userId") as! String
                    let image = i.document.get("image") as! String
                    let comments = i.document.get("comments") as! String
                    let body = i.document.get("body") as! String
                    let favorites = i.document.get("favorites") as! String
                    let createdAt = i.document.get("createdAt") as! NSNumber
                    
                    self.posts.append(Post(id: id, userID: userId, name: name, image: image, postBody: body, comments: comments, favorites: favorites, createdAt: createdAt))
                    self.posts.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
                }
                
                if(i.type == .removed){
                    
                    let id = i.document.documentID

                    for j in 0..<self.posts.count{
                        if (self.posts[j].id == id){
                            self.posts.remove(at: j)
                            return
                        }
                    }
                }
                
                if(i.type == .modified)
                {
                    let id = i.document.documentID
                    let favorites = i.document.get("favorites") as! String
                    let comments = i.document.get("comments") as! String
                    
                    for j in 0..<self.posts.count{
                        if (self.posts[j].id == id){
                            self.posts[j].favorites = favorites
                            self.posts[j].comments = comments
                            return
                        }
                    }
                }
                
            }
        
        }
    }
}

