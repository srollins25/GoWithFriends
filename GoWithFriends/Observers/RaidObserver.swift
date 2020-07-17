//
//  RaidObserver.swift
//  GoWithFriends
//
//  Created by stephan rollins on 6/19/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import Foundation
import FirebaseFirestore

class RaidObserver: ObservableObject {
    
    @Published var raids = [Raid]()
    
    init() {
        let db = Firestore.firestore()
        db.collection("raids").addSnapshotListener { (snap, error) in
            
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
                    let timeTillStart = i.document.get("timeToStart") as! NSNumber
                    let dexnum = i.document.get("dexnum") as! String
                    let timeToRemove = i.document.get("timeToRemove") as! NSNumber
                    let difficulty = i.document.get("difficulty") as! NSNumber
                    //print("sighted: ", sighted)
                    //print("sighted time to delete: ", (sighted.doubleValue + 600))
                    //( Date().timeIntervalSince1970 as NSNumber).doubleValue >= timeToRemove.doubleValue &&  timeTillStart.doubleValue == 0 ||  (Date().timeIntervalSince1970 as NSNumber).doubleValue >= timeTillStart.doubleValue && timeToRemove.doubleValue == 0
                    print("current time: ", Date().timeIntervalSince1970 as NSNumber)
                    if((timeToRemove.doubleValue < (Date().timeIntervalSince1970 as NSNumber).doubleValue /* && dexnum != "" */)  )
                    {
                        
                        let db = Firestore.firestore()
                        
                        db.collection("raids").document(id_).delete() { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                            }
                        }
                    }
                    else if (timeTillStart.doubleValue < (Date().timeIntervalSince1970 as NSNumber).doubleValue /* && dexnum == "" */ )
                    {
                        let db = Firestore.firestore()
                        
                        db.collection("raids").document(id_).delete() { err in
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
                        self.raids.append(Raid(id: id_, user: user, lat: lat, lon: lon, name: name, cp: cp, timeTillStart: timeTillStart, timeToRemove: timeToRemove, difficulty: difficulty, dexnum: dexnum))
                        print("pokemon arr: ", self.raids.description)
                    }
                }
                
                if(i.type == .removed){
                    
                    let id = i.document.documentID

                    for j in 0..<self.raids.count{
                        if (self.raids[j].id == id){
                            self.raids.remove(at: j)
                            return
                        }
                    }
                }
            }
        }
    }
}

