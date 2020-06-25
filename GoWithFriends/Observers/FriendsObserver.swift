//
//  FriendsObserver.swift
//  GoWithFriends
//
//  Created by stephan rollins on 5/14/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import Foundation
import Firebase

class FriendsObserver: ObservableObject {
    
    @Published var friends = [Message]()
    
    init()
    {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        db.collection("users").document(uid!).collection("messages").addSnapshotListener{ (snap, error) in
            
            if error != nil{
                print((error?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges {
                
                if(i.type == .added){
                    let id = i.document.documentID
                    let name = i.document.get("name") as! String
                    let image = i.document.get("image") as! String
                    let text = i.document.get("message") as! String
                    let createdAt = i.document.get("createdAt") as! NSNumber
                    
                    self.friends.append(Message(id: id, image: image, name: name, text: text, createdAt: createdAt))
                    self.friends.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending})
                }
                
                if(i.type == .modified){
                    let id = i.document.documentID
                    let text = i.document.get("message") as! String
                    //let name = i.document.get("name") as! String
                    //let image = i.document.get("image") as! String
                    let createdAt = i.document.get("createdAt") as! NSNumber
                    
                    
                    for j in 0..<self.friends.count{
                        if (self.friends[j].id == id){
                            
                            self.friends[j].text = text
                            //self.friends[j].name = name
                            //self.friends[j].image = image
                            self.friends[j].createdAt = createdAt
                        }
                    }
                    
                    self.friends.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending})
                    
                }
                
                
                
                if(i.type == .removed){
                    
                    let id = i.document.documentID

                    for j in 0..<self.friends.count{
                        if (self.friends[j].id == id){
                            self.friends.remove(at: j)
                            return
                        }
                    }
                }
            }
        }
    }
}
