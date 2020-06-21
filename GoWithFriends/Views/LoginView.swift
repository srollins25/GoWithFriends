//
//  LoginView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/8/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


struct SignUpView: View {
    
    @State var email: String = ""
    @State var name: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var validatePassword: String = ""
    @State var error: String = ""
    @Binding var isloggedin: Bool
    @EnvironmentObject var session: SessionStore
    @Binding var index: Int
    @State var imagePicker = false
    @State var imageData: Data = .init(count: 0)
    
    var body: some View{
        VStack{
            
            ZStack(alignment: .bottom){
                VStack{
                    HStack{
                        Spacer(minLength: 0)
                        VStack(spacing: 10){
                            Text("Sign up").foregroundColor(self.index == 1 ? .gray : Color.gray.opacity(0.5)).font(.title).fontWeight(.bold)
                            Capsule().fill(self.index == 1 ? Color.blue : Color.clear).frame(width: 100, height: 5)
                        }
                    }
                    .padding(.top, 30)
                    
                    
                    if(self.imageData.count == 0){
                        Image(systemName: "person.crop.circle.badge.plus").resizable().renderingMode(.original).aspectRatio(contentMode: .fill).frame(width: 40, height: 40).foregroundColor(.gray).onTapGesture {
                            self.imagePicker.toggle()
                        }.sheet(isPresented: self.$imagePicker){
                            ImagePicker(picker: self.$imagePicker, imageData: self.$imageData)
                        }
                    }
                    else
                    {
                        Image(uiImage: UIImage(data: self.imageData)!).resizable().renderingMode(.original).frame(width: 40, height: 40).clipShape(Circle()).onTapGesture {
                            self.imagePicker.toggle()
                        }.sheet(isPresented: self.$imagePicker){
                            ImagePicker(picker: self.$imagePicker, imageData: self.$imageData)
                        }
                    }
                    

                    
                    VStack{
                        HStack(spacing: 15){
                            Image(systemName: "person.crop.circle.fill")
                            
                            TextField("Username", text: self.$name)
                        }
                        Divider().background(Color.white.opacity(0.5))
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)
                    
                    VStack{
                        HStack(spacing: 15){
                            Image(systemName: "envelope.fill")
                            
                            TextField("Email", text: self.$email).keyboardType(.emailAddress)
                        }
                        Divider().background(Color.white.opacity(0.5))
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)
                    
                    VStack{
                        HStack(spacing: 15){
                            Image(systemName: "eye.slash.fill")
                            
                            SecureField("Password", text: self.$password)
                        }
                        Divider().background(Color.white.opacity(0.5))
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)
                    
                    VStack{
                        HStack(spacing: 15){
                            Image(systemName: "eye.slash.fill")
                            
                            SecureField("Retype Password", text: self.$validatePassword)
                        }
                        Divider().background(Color.white.opacity(0.5))
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)
                    
                }
                .padding()
                .padding(.bottom, 65)
                .background(Color.white)
                .clipShape(CShape2())
                .contentShape(CShape2())
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
                .onTapGesture {
                    self.index = 1
                }
                .cornerRadius(35)
                .padding(.horizontal, 20)
                
                //button
                
                Button(action: {
                    print("singup tapp")
                    Auth.auth().createUser(withEmail: self.email, password: self.password){ authResult, error in
                        
                        if error != nil{
                            print((error?.localizedDescription)!)
                            return
                        }
                        
                        let uid = Auth.auth().currentUser?.uid
                        
                        let storage = Storage.storage().reference()
                        
                        storage.child("profilepics").child(uid!).putData(self.imageData, metadata: nil){ (_, error) in
                            
                            if error != nil{
                                print((error?.localizedDescription)!)
                                return
                            }
                            
                            storage.child("profilepics").child(uid!).downloadURL{ (url, error) in
                                
                                if error != nil{
                                    print((error?.localizedDescription)!)
                                    return
                                }
                                
                            UserDefaults.standard.set(url?.absoluteString, forKey: "image")
                               self.createUser(image: UserDefaults.standard.string(forKey: "image")!, uid: uid!)

                               self.email = ""
                               self.password = ""
                               self.name = ""
                               self.validatePassword = ""
                               self.isloggedin.toggle()
                               UserDefaults.standard.set(self.isloggedin, forKey: "isloggedin")
                               self.index = 0
                                self.imageData.count = 0
                            }
                        }
                        
                        
                    }

                }){
                    Text("Sign up").foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .padding(.horizontal, 50)
                        .background(Color.green.opacity(0.8))
                        .clipShape(Capsule())
                        .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
                }
                .offset(y: 25)
                .opacity(self.index == 1 ? 1 : 0)
            }
        }
    }
    
    func createUser(image: String, uid: String)
    {
        let db = Firestore.firestore()
        
        let name = self.name
        let image = image
        let favorites = [String]()
        let friends = [String]()
        let blocked = [String]()
        let comments = [String]()
        let user_posts = [String]()
        let createdAt = Date().timeIntervalSince1970
        let email = self.email
        
        let values = ["blocked": blocked, "comments": comments, "createdAt": createdAt, "email": email, "favorites": favorites, "friends": friends, "id": uid, "image": image, "name": name, "user_posts": user_posts] as [String: Any]
        db.collection("users").document(uid).setData(values)

        UserDefaults.standard.set(uid, forKey: "userid")
        UserDefaults.standard.set(name, forKey: "username")
        UserDefaults.standard.set(image, forKey: "image")
        UserDefaults.standard.set(favorites, forKey: "favorites")
        UserDefaults.standard.set(friends, forKey: "friends")
        UserDefaults.standard.set("", forKey: "friendId")
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var picker: Bool
    @Binding var imageData: Data
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePicker.Coordinator(parent1: self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(parent1: ImagePicker){
            
            parent = parent1
            
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.picker.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as! UIImage
            let data = image.jpegData(compressionQuality: 0.45)
            self.parent.imageData = data!
            self.parent.picker.toggle()
        }
        
    }
    
}


struct LoginView: View {
    
    
    @State var index = 0
    @Binding var isloggedin: Bool
    
    @EnvironmentObject var session: SessionStore
    
    var body: some View{
        
        GeometryReader{_ in
            VStack{
                
                //for logo Image("").resizable().frame(width: 60, height: 60)
                
                ZStack{
                    
                    SignUpView(isloggedin: self.$isloggedin, index: self.$index).zIndex(Double(self.index))
                    
                    LoginView2(isloggedin: self.$isloggedin, index: self.$index)
                    
                }
                
                HStack(spacing: 15){
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 1)
                    Text("Or")
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 1)
                }.padding(.horizontal, 20)
                    .padding(.top, 50)
                    
                    
                    //other login buttons
                    //                HStack(spacing: 25){
                    //                    Button(action: {
                    //
                    //                    }){
                    //
                    //                    }
                    //                }.padding(.top, 30)
                    .padding(.vertical)
            }
            
        }
        .background(Color("background")).edgesIgnoringSafeArea(.all)
    }
}

struct LoginView2: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @Binding var isloggedin: Bool
    @Binding var index: Int
    
    var body: some View{
        
        
        
        ZStack(alignment: .bottom){
            VStack{
                HStack{
                    
                    VStack(spacing: 10){
                        Text("Login").foregroundColor(self.index == 0 ? .gray : Color.gray.opacity(0.5)).font(.title).fontWeight(.bold)
                        Capsule().fill(self.index == 0 ? Color.blue : Color.clear).frame(width: 100, height: 5)
                    }
                    
                    
                    Spacer(minLength: 0)
                }
                .padding(.top, 30)
                
                Spacer().frame(width: 45, height: 55)
                VStack{
                    HStack(spacing: 15){
                        Image(systemName: "envelope.fill")
                        
                        TextField("Email", text: self.$email).keyboardType(.emailAddress)
                    }
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                VStack{
                    HStack(spacing: 15){
                        Image(systemName: "eye.slash.fill")
                        
                        SecureField("Password", text: self.$password)
                    }
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                HStack{
                    Spacer(minLength: 0)
                    
                    Button(action: {
                        
                    }){
                        Text("Forgot Password?").foregroundColor(Color.gray.opacity(0.6))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 30)
            }
            .padding()
            .padding(.bottom, 65)
            .background(Color.white)
            .clipShape(CShape())
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            .onTapGesture {
                
                self.index = 0
            }
            .contentShape(CShape())
            .cornerRadius(35)
            .padding(.horizontal, 20)
            
            //button
            
            Button(action: {
                print("login tapp")
                Auth.auth().signIn(withEmail: self.email, password: self.password, completion: { (user, error) in
                    
                    if error != nil{
                        print((error?.localizedDescription)!)
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
                                print((error?.localizedDescription)!)
                                return
                            }
                                
                            else{
                                let data = snapshot?.data()
                                let name = data!["name"] as? String
                                let image = data!["image"] as? String
                                let favorites = data!["favorites"] as? [String]
                                let friends = data!["friends"] as? [String]
                                
                                UserDefaults.standard.set(uid, forKey: "userid")
                                UserDefaults.standard.set(name, forKey: "username")
                                UserDefaults.standard.set(image, forKey: "image")
                                UserDefaults.standard.set(favorites, forKey: "favorites")
                                UserDefaults.standard.set(friends, forKey: "friends")
                                UserDefaults.standard.set("", forKey: "friendId")
                                self.email = ""
                                self.password = ""
                                self.isloggedin.toggle()
                                UserDefaults.standard.set(self.isloggedin, forKey: "isloggedin")
                                UserDefaults.standard.synchronize()
                            }
                        }
                    }
                })
            }){
                Text(" Login ").foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color.green.opacity(0.8))
                    .clipShape(Capsule())
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
            }
            .offset(y: 25)
            .opacity(self.index == 0 ? 1 : 0)
        }
    }
}

struct CShape: Shape {
    
    func path(in rect: CGRect) -> Path{
        
        return Path{ path in
            // right curve
            path.move(to: CGPoint(x: rect.width, y: 100 + 20))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
            
        }
        
    }
}

struct CShape2: Shape {
    
    func path(in rect: CGRect) -> Path{
        
        return Path{ path in
            // left curve
            path.move(to: CGPoint(x: 0, y: 100 + 20))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            
        }
        
    }
}


