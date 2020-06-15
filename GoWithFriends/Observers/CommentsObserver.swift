//
//  CommentsObserver.swift
//  GoWithFriends
//
//  Created by stephan rollins on 6/14/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import Foundation
import Firebase

class CommentsObserver: ObservableObject {
    
    @Published var comments = [Post]()
    
    init(parentPost_: String) {
    
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
                    let parentPost = i.document.get("parentPost") as! String
                    if(parentPost_ == parentPost && parentPost != "")
                    {
                        let id = i.document.documentID
                        let name = i.document.get("name") as! String
                        let userId = i.document.get("userId") as! String
                        let image = i.document.get("image") as! String
                        let profileimage = i.document.get("profileimage") as! String
                        let comments = i.document.get("comments") as! NSArray
                        let body = i.document.get("body") as! String
                        let favorites = i.document.get("favorites") as! NSNumber
                        let createdAt = i.document.get("createdAt") as! NSNumber
                        
                        self.comments.append(Post(id: id, userID: userId, name: name, image: image, profileimage: profileimage, postBody: body, comments: comments, favorites: favorites, createdAt: createdAt, parentPost: parentPost))
                        self.comments.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
                        
                    }
                }
                
                if(i.type == .removed){
                    
                    let id = i.document.documentID
                    
                    for j in 0..<self.comments.count{
                        if (self.comments[j].id == id){
                            self.comments.remove(at: j)
                            return
                        }
                    }
                }
                
                if(i.type == .modified)
                {
                    let id = i.document.documentID
                    let favorites = i.document.get("favorites") as! NSNumber
                    let comments = i.document.get("comments") as! NSArray
                    
                    for j in 0..<self.comments.count
                    {
                        if(self.comments[j].id == id)
                        {
                            self.comments[j].favorites = favorites
                            self.comments[j].comments = comments
                            return
                        }
                    }
                }
            }
        }
    }
}
