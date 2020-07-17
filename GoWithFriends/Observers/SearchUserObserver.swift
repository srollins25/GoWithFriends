//
//  SearchUserObserver.swift
//  GoWithFriends
//
//  Created by stephan rollins on 5/27/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import Foundation
import Firebase

class SearchUserObserver: ObservableObject {

    @Published var users = [PokeUser]()
    
    init() {
        
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments{ (snap, error) in
            
            if error != nil{
                print((error?.localizedDescription)!)
                return
            }
            
            for i in snap!.documents{
                
                let id = i.documentID
                let name = i.get("name") as! String
                let trainerId = i.get("trainerId") as! String
                let image = i.get("image") as! String
                let user_posts = i.get("user_posts") as! [String]
                
                let ref = db.collection("users").document(id)
                
                ref.getDocument{ (snapshot, error) in
                    
                    if(error != nil){
                        print((error?.localizedDescription)!)
                        return
                    }
                        
                    else{
                        let data = snapshot?.data()
                        let blocked = data!["blocked"] as? [String]
                        
                        
                        if(!(blocked?.contains((Auth.auth().currentUser!.uid)))!)
                        {
                            self.users.append(PokeUser(id: id, name: name, profileimage: image, email: "", user_posts: user_posts, createdAt: 0, trainerId: trainerId))
                        }
                       
                    }
                }
                
                
                
            }
            
        }
        
    }
    
}


































