//
//  DeleteAccountVerifyView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 6/24/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import Firebase

struct DeleteAccountVerifyView: View {
    
    @Binding var closeView: Bool
    //@Binding var closePreviousView: Bool
    @State var email = ""
    @State var pass = ""
    @State var showAlert = false
    @State var showLoading = false
    @State var error = ""
    @Binding var isLoggedIn: Bool
    @Environment(\.colorScheme) var scheme 
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        
        ZStack{
            
            Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)
            
            VStack{
                
                Text("Delete Account").foregroundColor(.red).font(.title).fontWeight(.bold).padding(.top, 10).padding(.bottom, 20)
                //Spacer()
                Text("Enter login creditials to delete account.")
                VStack{
                    TextField("Email", text: self.$email)
                    Divider()
                    SecureField("Password", text: self.$pass)
                    Divider()
                    
                    HStack(spacing: 10){
                        
                        Button(action: {
                            
                            withAnimation(.easeOut(duration: 0.5)){
                                self.closeView.toggle()
                            }
                            
                        }){
                            Text("Cancel")
                        }
                        
                        Button(action: {
                            
                            if(self.email == "" || self.pass == "")
                            {
                                self.showAlert.toggle()
                                self.error = "All fields must be filled out."
                            }
                            else
                            {
                                self.presentationMode.wrappedValue.dismiss()
                                self.showLoading.toggle()
                                
                                //self.closePreviousView = false
                                
                                
                                
                                let user = Auth.auth().currentUser
                                let credential = EmailAuthProvider.credential(withEmail: self.email, password: self.pass)
                                
                                user?.reauthenticate(with: credential) { (result, error) in
                                    if let error = error {
                                        self.showAlert.toggle()
                                        self.error = error.localizedDescription
                                    } else {
                                        // User re-authenticated.
                                        // loading "deleting account"
                                        
                                        
                                        let db = Firestore.firestore()
                                        
                                        //remove posts from user favorites
                                        db.collection("posts").whereField("userId", isEqualTo: (Auth.auth().currentUser?.uid)!).getDocuments { snap, error  in
                                            if let error = error {

                                                self.showAlert.toggle()
                                                self.error = (error.localizedDescription)
                                                return
                                            }
                                            
                                            for document in snap!.documents {
                                                
                                                db.collection("users").whereField("favorites", arrayContains: document.documentID).getDocuments { (snap, error) in
                                                    if(error != nil)
                                                    {

                                                        self.showAlert.toggle()
                                                        self.error = (error?.localizedDescription)!
                                                        return
                                                    }
                                                    
                                                    for document in snap!.documents {
                                                        
                                                        let ref = db.collection("users").document("\(document.documentID)")
                                                        ref.updateData(["favorites": FieldValue.arrayRemove([document.documentID])])
                                                    }
                                                }
                                                
                                                let ref = db.collection("posts").document("\(document.documentID)")
                                                ref.delete()
                                                
                                            }
                                        }
                                        
                                        //delete posts by user and change all posts parent posts to ""
                                        
                                        db.collection("posts").whereField("userId", isEqualTo: (Auth.auth().currentUser?.uid)!).getDocuments { snap, error  in
                                            if let error = error {

                                                self.showAlert.toggle()
                                                self.error = (error.localizedDescription)
                                                return
                                            }
                                            
                                            for document in snap!.documents {
                                                
                                                db.collection("posts").whereField("parentPost", isEqualTo: document.documentID).getDocuments { (snap, error) in
                                                    if(error != nil)
                                                    {

                                                        self.showAlert.toggle()
                                                        self.error = (error?.localizedDescription)!
                                                        return
                                                    }
                                                    
                                                    for document in snap!.documents {
                                                        
                                                        let ref = db.collection("posts").document("\(document.documentID)")
                                                        ref.updateData(["parentPost": ""])
                                                    }
                                                }
                                                
                                                let ref = db.collection("posts").document("\(document.documentID)")
                                                ref.delete()
                                                
                                            }
                                        }
                                        
                                        
                                        
                                        // remove userid from users who has current users as a friend
                                        db.collection("users").whereField("friends", arrayContains: (Auth.auth().currentUser?.uid)!).getDocuments { snap, error  in
                                            if let error = error {
                                                print("Error removing document: \(error)")
                                                self.showAlert.toggle()
                                                self.error = (error.localizedDescription)
                                                return
                                            }
                                            
                                            for document in snap!.documents {
                                                
                                                let ref = db.collection("users").document("\(document.documentID)")
                                                ref.updateData(["friends": FieldValue.arrayRemove([(Auth.auth().currentUser?.uid)!])])
                                            }
                                        }
                                        
                                        //delete messages
                                        db.collection("messages").document((Auth.auth().currentUser?.uid)!).delete()
                                        
                                        //delete pictures
                                        let storageRef = Storage.storage().reference()
                                        
                                        let desertRef = storageRef.child("profilepics").child("\((Auth.auth().currentUser?.uid)!)")
                                        
                                        desertRef.delete { error in
                                            if let error = error {
                                                // Uh-oh, an error occurred!
                                                self.showAlert.toggle()
                                                self.error = (error.localizedDescription)
                                                return
                                            }
                                        }
                                        
                                        //delete user from database
                                        
                                        db.collection("users").document(UserDefaults.standard.string(forKey: "userid")!).delete() { error in
                                            
                                            if let error = error{
                                                self.showAlert.toggle()
                                                self.error = (error.localizedDescription)
                                                return
                                            }
                                        }
                                        
                                        //delete user from firebase
                                        
                                        let user = Auth.auth().currentUser
                                        user?.delete { error in
                                            
                                            if let error = error{
                                                self.showAlert.toggle()
                                                self.error = (error.localizedDescription)
                                                return
                                            }
                                        }
                                        
                                        //erase all userdefault data then signout
                                        UserDefaults.standard.set("", forKey: "userid")
                                        UserDefaults.standard.set("", forKey: "username")
                                        UserDefaults.standard.set("", forKey: "image")
                                        UserDefaults.standard.set("", forKey: "favorites")
//                                        let encoder = JSONEncoder()
//                                        if let encoded = try? encoder.encode([PokeUser]())
//                                        {
//                                            UserDefaults.standard.set(encoded, forKey: "friends")
//                                        }
                                        UserDefaults.standard.set("", forKey: "friendId")
                                        UserDefaults.standard.set("", forKey: "email")
                                        UserDefaults.standard.set(false, forKey: "isloggedin")
                                        self.showLoading.toggle()
                                        self.isLoggedIn.toggle()
                                    }
                                }
                                
                                
                            }
                        }){
                            Text("Delete").foregroundColor(.red)
                        }.alert(isPresented: self.$showAlert){
                            
                            Alert(title: Text("Error"), message: Text(self.error), dismissButton: .cancel())
                        }
                    }
                }.padding(.horizontal, 45)
                Spacer()
            }
            
//            if(self.showLoading == true)
//            {
//                GeometryReader{_ in
//
//                    LoaderView()
//
//                }.background(Color.clear)
//
//            }
            
        }
        .onDisappear{
            //self.showProfileView.toggle()
            //self.closePreviousView.toggle()
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

//struct DeleteAccountVerifyView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeleteAccountVerifyView()
//    }
//}

