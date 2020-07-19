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
    
    @Published var friends = [PokeUser]()
    
    init(){
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        var _friends = [String]()

        db.collection("users").document(uid!).collection("friends").getDocuments{ (snap, error) in //user friends
            
            if(error != nil)
            {
                print((error?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges {
                
                if(i.type == .added){
                    let id = i.document.documentID
                    let name = i.document.get("name") as! String
                    let image = i.document.get("image") as! String
                    let trainerId = i.document.get("trainerId") as! String
                    
                    self.friends.append(PokeUser(id: id, name: name, profileimage: image, email: "", user_posts: [String](), createdAt: 0, trainerId: trainerId))
                    self.friends.sort(by: { $0.name.compare($1.name) == .orderedDescending})
                    _friends = self.friends.map{ $0.id }
                    UserDefaults.standard.set(_friends, forKey: "friends")
                }

                if(i.type == .modified){
                    
                    let id = i.document.documentID
                    let name = i.document.get("name") as! String
                    let image = i.document.get("image") as! String
                    let trainerId = i.document.get("trainerId") as! String


                    for j in 0..<self.friends.count{
                        if (self.friends[j].id == id){
                            self.friends[j].name = name
                            self.friends[j].trainerId = trainerId
                            self.friends[j].profileimage = image
                            return
                        }

                    }
                    _friends = self.friends.map{ $0.id }
                    UserDefaults.standard.set(_friends, forKey: "friends")
                }
                
                if(i.type == .removed){
                    
                    let id = i.document.documentID

                    for j in 0..<self.friends.count{
                        if (self.friends[j].id == id){
                            self.friends.remove(at: j)
                            return
                        }
                    }
                    _friends = self.friends.map{ $0.id }
                    UserDefaults.standard.set(_friends, forKey: "friends")
                }
            }
        }
    }
}
