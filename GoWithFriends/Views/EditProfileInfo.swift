//
//  EditProfileInfo.swift
//  GoWithFriends
//
//  Created by stephan rollins on 7/8/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import SDWebImageSwiftUI

struct EditProfileInfo: View {
    
    @State var username = UserDefaults.standard.string(forKey: "username")!
    @State var email = UserDefaults.standard.string(forKey: "email")!
    @State var trainerId = UserDefaults.standard.string(forKey: "trainerId")!
    @State var fromLogin = false
    @Environment(\.colorScheme) var scheme
    @State var showAlert = false
    @State var showAuth = false
    @State var imagePicker = false
    @State var accountIsAuthed = false
    @State var imageData: Data = .init(count: 0)
    @State var showLoading = false
    @State var profileImage = AnimatedImage(url: URL(string: UserDefaults.standard.string(forKey: "image")!))
    
    
    var body: some View {
        
        ZStack{
            
            ScrollView{
                        
                        VStack{
                            
                            if(self.imageData.count == 0){
                            self.profileImage.resizable().renderingMode(.original).aspectRatio(contentMode: .fill).frame(width: 95, height: 95).shadow(color: .gray, radius: 5, x: 1, y: 1).clipShape(Circle()).padding(.bottom, 3)
                            }
                            else
                            {
                                Image(uiImage: UIImage(data: self.imageData)!).resizable().renderingMode(.original).aspectRatio(contentMode: .fill).frame(width: 95, height: 95).shadow(color: .gray, radius: 5, x: 1, y: 1).clipShape(Circle()).padding(.bottom, 3)
                            }
                            
                            Button(action: {
                                self.imagePicker.toggle()
                            }){
                                Text("Change Profile Photo").foregroundColor(.blue)
                            }.sheet(isPresented: self.$imagePicker){
                                ImagePicker(picker: self.$imagePicker, imageData: self.$imageData)
                            }
                        }
                        
                        Divider()
                        
                        VStack(spacing: 10){
                            
                            HStack(spacing: 15){
                                Text("Userame")
                                Divider().background(Color.clear)
                                //VStack{
                                TextField(self.username, text: self.$username)
                                    //Divider()
                                //}
                            }
                            
                            HStack(spacing: 15){
                                Text("Trainer Code")
                                Divider().background(Color.clear)
                                VStack{
                                TextField(self.trainerId, text: self.$trainerId)
                                    Divider()
                                }
                            }

                            NavigationLink(destination: ReAuthView(closeView: self.$showAuth)){
                                Text("Update email")
                            }
                            NavigationLink(destination: ForgotPasswordView(fromLogin: self.$fromLogin).navigationBarTitle("").navigationBarHidden(true)){
                                Text("Update password")
                            }
                        }
                    }.padding()
            
            
            if(self.showLoading == true)
            {
                GeometryReader{_ in
                    
                    LoaderView()
                    
                }.background(Color.clear)
                
            }
        }
            
            .navigationBarItems(trailing: Button(action: {
                self.showAlert.toggle()
                self.showLoading = true
            }){
                Text("Done")
            }.alert(isPresented: self.$showAlert){
                Alert(title: Text("Submit?"), primaryButton: .cancel(Text("Cancel"), action: {
                    self.showLoading.toggle()
                }), secondaryButton: .default(Text("Continue"), action: {
                     
                    UIApplication.shared.endEditing()
                    
                    let uid = Auth.auth().currentUser?.uid
                    let db = Firestore.firestore()
                    let storage = Storage.storage().reference()
                    
                    //check image
                    if(self.imageData.count != 0)
                    {
                        storage.child("profilepics").child(uid!).putData(self.imageData, metadata: nil){ (_, error) in
                            
                            if error != nil{
                                print((error?.localizedDescription)!)
//                                self.showAlert.toggle()
//                                self.error = (error?.localizedDescription)!
                                return
                            }
                            
                            storage.child("profilepics").child(uid!).downloadURL{ (url, error) in
                                
                                if error != nil{
                                    print((error?.localizedDescription)!)
//                                    self.showAlert.toggle()
//                                    self.error = (error?.localizedDescription)!
                                    return
                                }
                                
                                UserDefaults.standard.set(url?.absoluteString, forKey: "image")
                                //update image link for user
                                
                                let ref = db.collection("users").document(uid!)
                                ref.updateData(["image": (url?.absoluteString)!])
                                
                                //update image link for posts
                                
                                db.collection("posts").whereField("userId", isEqualTo: (Auth.auth().currentUser?.uid)!).getDocuments { (snap, error) in
                                    if(error != nil)
                                    {
                                        print((error?.localizedDescription)!)
                                        return
                                    }
                                    
                                    for document in snap!.documents {
                                        
                                        let ref = db.collection("posts").document("\(document.documentID)")
                                        ref.updateData(["profileimage": (url?.absoluteString)!])
                                    }
                                }
                            }
                        }

                        
                        
                    }
                    
                    //check username
                    if(UserDefaults.standard.string(forKey: "username")! != self.username)
                    {
                        UserDefaults.standard.set(self.username, forKey: "username")
                        
                        db.collection("posts").whereField("userId", isEqualTo: (Auth.auth().currentUser?.uid)!).getDocuments { (snap, error) in
                            if(error != nil)
                            {
                                print((error?.localizedDescription)!)
                                return
                            }
                            
                            for document in snap!.documents {
                                
                                let ref = db.collection("posts").document("\(document.documentID)")
                                ref.updateData(["name": self.username])
                            }
                        }
                        
                        
                        let ref = db.collection("users").document(uid!)
                        ref.getDocument { (snap, error) in
                            
                            if(error != nil)
                            {
                                print((error?.localizedDescription)!)
                                return
                            }
                            ref.updateData(["name": self.username])
                        }
                        
                    }
                    
                    //check trainer code
                    if(UserDefaults.standard.string(forKey: "trainerId")! != self.trainerId)
                    {
                        UserDefaults.standard.set(self.trainerId, forKey: "trainerId")
                        
                        db.collection("posts").whereField("userId", isEqualTo: (Auth.auth().currentUser?.uid)!).getDocuments { (snap, error) in
                            if(error != nil)
                            {
                                print((error?.localizedDescription)!)
                                return
                            }
                            
                            for document in snap!.documents {
                                
                                let ref = db.collection("posts").document("\(document.documentID)")
                                ref.updateData(["trainerId": self.trainerId])
                            }
                        }
                        
                        let ref = db.collection("users").document(uid!)
                        ref.getDocument { (snap, error) in
                            
                            if(error != nil)
                            {
                                print((error?.localizedDescription)!)
                                return
                            }
                            ref.updateData(["trainerId": self.trainerId])
                        }
                    }
                    
                    //check email
                    if(UserDefaults.standard.string(forKey: "email")! != self.email)
                    {
                        UserDefaults.standard.set(self.email, forKey: "username")
                        
                        let ref = db.collection("users").document(uid!)
                        ref.getDocument { (snap, error) in
                            
                            if(error != nil)
                            {
                                print((error?.localizedDescription)!)
                                return
                            }
                            ref.updateData(["email": self.email])
                        }
                        
                        
                        let user = Auth.auth().currentUser
                        user?.updatePassword(to: self.email, completion: nil)
                    }
                    self.showLoading.toggle()
                }))
            })
    }
}

struct EditProfileInfo_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileInfo()
    }
}
