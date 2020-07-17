//
//  PostObserver.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/24/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//
// for profileview

import Foundation
import Firebase

class UserPostObserver: ObservableObject {
    
    @Published var currentuserposts = [Post]()
    
    
    init() {
        
        let uid: String = Auth.auth().currentUser!.uid
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
                    if((i.document.get("userId") as! String) == uid)
                    {
                        
                        let name = i.document.get("name") as! String
                        let userId = i.document.get("userId") as! String
                        let image = i.document.get("image") as! String
                        let trainerId = i.document.get("trainerId") as! String
                        let profileimage = i.document.get("profileimage") as! String
                        let comments = i.document.get("comments") as! NSArray
                        let body = i.document.get("body") as! String
                        let favorites = i.document.get("favorites") as! NSNumber
                        let parentPost = i.document.get("parentPost") as! String
                        let createdAt = i.document.get("createdAt") as! NSNumber
                        
                        
                        self.currentuserposts.append(Post(id: id, userID: userId, name: name, trainerId: trainerId, image: image, profileimage: profileimage, postBody: body, comments: comments, favorites: favorites, createdAt: createdAt, parentPost: parentPost))
                        self.currentuserposts.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
                        
                    }
                }
                
                if(i.type == .removed){
                    
                    let id = i.document.documentID
                    
                    for j in 0..<self.currentuserposts.count{
                        if (self.currentuserposts[j].id == id){
                            self.currentuserposts.remove(at: j)
                            return
                        }
                    }
                }
                
                if(i.type == .modified)
                {
                    let id = i.document.documentID
                    let favorites = i.document.get("favorites") as! NSNumber
                    let comments = i.document.get("comments") as! NSArray
                    
                    for j in 0..<self.currentuserposts.count
                    {
                        if(self.currentuserposts[j].id == id)
                        {
                            self.currentuserposts[j].favorites = favorites
                            self.currentuserposts[j].comments = comments
                            return
                        }
                    }
                }
            }
        }
    }
}
