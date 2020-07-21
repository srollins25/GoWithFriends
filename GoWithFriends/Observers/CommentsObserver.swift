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
        let mutedArr = (UserDefaults.standard.array(forKey: "mutedWords")! as? [String])!
        
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
                        let trainerId = i.document.get("trainerId") as! String
                        let userId = i.document.get("userId") as! String
                        let image = i.document.get("image") as! String
                        let profileimage = i.document.get("profileimage") as! String
                        let comments = i.document.get("comments") as! NSArray
                        let body = i.document.get("body") as! String
                        let favorites = i.document.get("favorites") as! NSNumber
                        let createdAt = i.document.get("createdAt") as! NSNumber
                        let reported = i.document.get("isReported") as! Bool
                        
                        //check if in user blocked list
                        let ref = db.collection("users").document(userId)
                        
                        ref.getDocument{ (snapshot, error) in
                            
                            if(error != nil){
                                print((error?.localizedDescription)!)
                                return
                            }
                                
                            else{
                                let data = snapshot?.data()
                                let blocked = data!["blocked"] as? [String]
                                var hasMuted = false
                                var i = 0
                                while(i < mutedArr.count && hasMuted == false)
                                {
                                    if(body.contains(mutedArr[i]))
                                    {
                                        hasMuted = true
                                    }
                                    i = i + 1
                                }
                                
                                
                                if(!(blocked?.contains((Auth.auth().currentUser!.uid)))! && hasMuted == false)
                                {
                                    self.comments.append(Post(id: id, userID: userId, name: name, trainerId: trainerId, image: image, profileimage: profileimage, postBody: body, comments: comments, favorites: favorites, createdAt: createdAt, parentPost: parentPost, isReported: reported))
                                    self.comments.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
                                }
                            }
                        }
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
                    let name = i.document.get("name") as! String
                    let profileimage = i.document.get("profileimage") as! String
                    let favorites = i.document.get("favorites") as! NSNumber
                    let comments = i.document.get("comments") as! NSArray
                    let reported = i.document.get("isReported") as! Bool
                    
                    for j in 0..<self.comments.count
                    {
                        if(self.comments[j].id == id)
                        {
                            self.comments[j].favorites = favorites
                            self.comments[j].comments = comments
                            self.comments[j].name = name
                            self.comments[j].profileimage = profileimage
                            self.comments[j].isReported = reported
                            return
                        }
                    }
                }
            }
        }
    }
}
