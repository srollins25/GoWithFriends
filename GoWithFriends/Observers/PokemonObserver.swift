//
//  PokemonObserver.swift
//  GoWithFriends
//
//  Created by stephan rollins on 6/17/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import Foundation
import FirebaseFirestore

class PokemonObserver: ObservableObject {
    
    @Published var pokemon = [Pokemon]()
    
    init() {
        let db = Firestore.firestore()
        db.collection("pokemon").addSnapshotListener { (snap, error) in
            
            if error != nil{
                print((error?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges {
                
                if(i.type == .added){
                    
                    let id_ = i.document.documentID
                    let user = i.document.get("user") as! String
                    let lat = i.document.get("lat") as! Double
                    let lon = i.document.get("lon") as! Double
                    let name = i.document.get("name") as! String
                    let cp = i.document.get("cp") as! NSNumber
                    let sighted = i.document.get("sighted") as! NSNumber
                    let dexnum = i.document.get("dexnum") as! String

                    //if pokemon sighted time is greater than 10 min remove
                    
                    if(sighted.doubleValue >= sighted.doubleValue + 600)
                    {
                        let db = Firestore.firestore()
                        
                        db.collection("pokemon").document(id_).delete() { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                            }
                        }
                    }
                    else
                    {
                        //else add to array
                        
                        self.pokemon.append(Pokemon(id: id_, user: user, lat: lat, lon: lon, name: name, cp: cp, sighted: sighted, dexnum: dexnum))
                    }
                    

                    //self.posts.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
                    
                }
                
                if(i.type == .removed){
                    
                    let id = i.document.documentID

                    for j in 0..<self.pokemon.count{
                        if (self.pokemon[j].id == id){
                            self.pokemon.remove(at: j)
                            return
                        }
                    }
                }
            }
        }
    }
}

