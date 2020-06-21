//
//  SessionStore.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/8/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import Foundation
import Firebase
import Combine
import FirebaseAuth
import FirebaseFirestore

class SessionStore: ObservableObject {
    
    
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User? {didSet {self.didChange.send(self) }}
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen() {
        
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
           
            if let user = user {
                
                self.session = User(id: user.uid, email: user.email, name: "", profileimage: "")
                
                let uid = Auth.auth().currentUser?.uid
                //print("userid: ", uid!)
                //UserDefaults.standard.set(uid, forKey: "userid")
                //print("signin1: ", UserDefaults.standard.string(forKey: "username")!)
                //print("userid2: ",  UserDefaults.standard.set(uid, forKey: "userid"))
                let db = Firestore.firestore()
                let ref = db.collection("users").document(uid!)
                
                ref.getDocument{ (snapshot, error) in
                    
                    if(error != nil){
                        print((error?.localizedDescription)!)
                        return
                    }
                    
                    else{
                        let data = snapshot?.data()
                        let name = data!["name"] as? String
                        let image = data!["image"] as? String
                        //print("session name: ", name)
                        //print("session name2: ", name)
                        //self.session?.name = name!
                        //self.session?.profileimage = image!
                         UserDefaults.standard.set(uid, forKey: "userid")
                        
                        UserDefaults.standard.set(name, forKey: "username")
                        
                        UserDefaults.standard.set(image, forKey: "image")
                    }
                }
            }
            else
            {
                self.session = nil
                print("inside session: session is nil")
            }
        })
    }
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback)
    {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
        
        let uid = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        let ref = db.collection("users").document(uid!)

        ref.getDocument{ (snapshot, error) in

            if(error != nil){
                print((error?.localizedDescription)!)
                return
            }

            else{
                let data = snapshot?.data()
                let name = data!["name"] as? String
                let image = data!["image"] as? String
                UserDefaults.standard.set(name, forKey: "username")
                UserDefaults.standard.set(image, forKey: "image")
                UserDefaults.standard.set(uid, forKey: "userid")
                print("name: \(name ?? "nil")")
            }
        }
        
    }
    
    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback)
    {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signOut() {
        
        do{

            try Auth.auth().signOut()


            self.session = nil
        }
        catch{
            print("Problem signing out.")
        }
        //print("signout1: ", UserDefaults.standard.string(forKey: "username")!)
        UserDefaults.standard.set("", forKey: "username")
        //print("signout1: ", UserDefaults.standard.string(forKey: "username")!)
        UserDefaults.standard.set("", forKey: "image")
        UserDefaults.standard.set("", forKey: "userid")
        
    }
    
    func unbind() {
        if let handle = handle{
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    deinit {
        unbind()
    }
}

struct User: Identifiable {
    var id: String
    var email: String?
    var name: String
    var profileimage: String
    
    init(id: String, email: String?, name: String, profileimage: String){
        self.id = id
        self.email = email
        self.name = name
        self.profileimage = profileimage
    }
}
