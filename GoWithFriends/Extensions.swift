//
//  Extensions.swift
//  GoWithFriends
//
//  Created by stephan rollins on 8/8/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

extension String {
  var isBlank: Bool {
    return allSatisfy({ $0.isWhitespace })
  }
}

extension SignUpView{
    func AuthCreatedUser()
    {
        Auth.auth().createUser(withEmail: self.email, password: self.password){ authResult, error in
            
            if error != nil{
                
                self.showAlert.toggle()
                self.error = (error?.localizedDescription)!
                return
            }
            
            let uid = Auth.auth().currentUser?.uid
            
            let storage = Storage.storage().reference()
            
            storage.child("profilepics").child(uid!).putData(self.imageData, metadata: nil){ (_, error) in
                
                if error != nil{
                    
                    self.showAlert.toggle()
                    self.error = (error?.localizedDescription)!
                    return
                }
                
                storage.child("profilepics").child(uid!).downloadURL{ (url, error) in
                    
                    if error != nil{
                        
                        self.showAlert.toggle()
                        self.error = (error?.localizedDescription)!
                        return
                    }
                    
                    UserDefaults.standard.set(url?.absoluteString, forKey: "image")
                    self.createUser(image: UserDefaults.standard.string(forKey: "image")!, uid: uid!)
                    
                    self.email = ""
                    self.password = ""
                    self.name = ""
                    self.trainerId = ""
                    self.validatePassword = ""
                    self.showLoading.toggle()
                    self.isloggedin.toggle()
                    UserDefaults.standard.set(self.isloggedin, forKey: "isloggedin")
                    self.index = 0
                    self.imageData.count = 0
                }
            }
        }
    }
    
    func createUser(image: String, uid: String)
    {
        let db = Firestore.firestore()
        
        let name = self.name
        let image = image
        let trainerId = self.trainerId
        let favorites = [String]()
        let friends = [String]()
        let blocked = [String]()
        let comments = [String]()
        let user_posts = [String]()
        let mutedWords = [String]()
        let createdAt = Date().timeIntervalSince1970
        let email = self.email
        let isOnline = true
        
        let values = ["blocked": blocked, "comments": comments, "createdAt": createdAt, "email": email, "favorites": favorites, "friends": friends, "id": uid, "image": image, "name": name, "trainerId": trainerId, "user_posts": user_posts, "mutedWords": mutedWords, "isOnline": isOnline] as [String: Any]
        db.collection("users").document(uid).setData(values)
        
        UserDefaults.standard.set(uid, forKey: "userid")
        UserDefaults.standard.set(isOnline, forKey: "isOnline")
        UserDefaults.standard.set(name, forKey: "username")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(image, forKey: "image")
        UserDefaults.standard.set(friends, forKey: "friends")
        UserDefaults.standard.set(trainerId, forKey: "trainerId")
        UserDefaults.standard.set(favorites, forKey: "favorites")
        UserDefaults.standard.set(mutedWords, forKey: "mutedWords")
        UserDefaults.standard.set("", forKey: "friendId")
    }
}

extension LoginFormView{
    
    func LoginUser()
    {
        Auth.auth().signIn(withEmail: self.email, password: self.password, completion: { (user, error) in
            
            if error != nil{
                
                self.showAlert.toggle()
                self.error = (error?.localizedDescription)!
                return
            }
                
            else
            {
                UIApplication.shared.endEditing()
                let uid = Auth.auth().currentUser?.uid
                let db = Firestore.firestore()
                let ref = db.collection("users").document(uid!)
                
                ref.getDocument{ (snapshot, error) in
                    
                    if(error != nil){
                        self.showAlert.toggle()
                        self.error = (error?.localizedDescription)!
                        return
                    }
                        
                    else{
                        let data = snapshot?.data()
                        let name = data!["name"] as? String
                        let trainerId = data!["trainerId"] as? String
                        let image = data!["image"] as? String
                        let email = data!["email"] as? String
                        let favorites = data!["favorites"] as? [String]
                        let mutedWords = data!["mutedWords"] as? [String]
                        let friends_ = data!["friends"] as? [String]
                        
                        
                        UserDefaults.standard.set(uid, forKey: "userid")
                        UserDefaults.standard.set(name, forKey: "username")
                        UserDefaults.standard.set(image, forKey: "image")
                        UserDefaults.standard.set(favorites, forKey: "favorites")
                        UserDefaults.standard.set(friends_, forKey: "friends")
                        UserDefaults.standard.set(mutedWords, forKey: "mutedWords")
                        UserDefaults.standard.set(trainerId, forKey: "trainerId")
                        UserDefaults.standard.set("", forKey: "friendId")
                        UserDefaults.standard.set(email, forKey: "email")
                        self.email = ""
                        self.password = ""
                        self.showLoading.toggle()
                        self.isloggedin.toggle()
                        UserDefaults.standard.set(self.isloggedin, forKey: "isloggedin")
                        UserDefaults.standard.synchronize()
                        ref.updateData(["isOnline": UserDefaults.standard.bool(forKey: "isloggedin")])
                    }
                }
            }
        })
    }
    
}

extension SideMenu{
    
    func SignOut()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
            
            do{
                
                try Auth.auth().signOut()
            }
            catch{
                print("Problem signing out.")
            }
            
            let ref = Firestore.firestore().collection("users").document(UserDefaults.standard.string(forKey: "userid")!)
            UserDefaults.standard.set("", forKey: "username")
            UserDefaults.standard.set("", forKey: "image")
            UserDefaults.standard.set("", forKey: "userid")
            UserDefaults.standard.set("", forKey: "email")
            UserDefaults.standard.set("", forKey: "trainerId")
            let emptyArr = [String]()
            UserDefaults.standard.set(emptyArr, forKey: "favorites")
            UserDefaults.standard.set([String](), forKey: "friends")
            self.showLoading.toggle()
            self.isLoggedIn.toggle()
            UserDefaults.standard.set(self.isLoggedIn, forKey: "isloggedin")
            
            ref.updateData(["isOnline": false])
            
        }
    }
}
