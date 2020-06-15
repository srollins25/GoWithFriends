//
//  LoginView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/8/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore


struct SignUpView: View {
    
    @State var email: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var error: String = ""
    //@Binding var isloggedin: Bool
    @EnvironmentObject var session: SessionStore
    
    func signUp()
    {
        
        //        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
        //
        //        let uid = Auth.auth().currentUser?.uid
        //        let db = Firestore.firestore()
        //        let ref = db.collection("users").document(uid!)
        //
        //        ref.getDocument{ (snapshot, error) in
        //
        //            if(error != nil){
        //                print((error?.localizedDescription)!)
        //                return
        //            }
        //
        //            else{
        //                let data = snapshot?.data()
        //                let name = data!["name"] as? String
        //                let image = data!["image"] as? String
        //                UserDefaults.standard.set(name, forKey: "username")
        //                UserDefaults.standard.set(image, forKey: "image")
        //                UserDefaults.standard.set(uid, forKey: "userid")
        //                print("name: \(name ?? "nil")")
        //            }
        //        }
        
        //
        
        session.signUp(email: email, password: password) { (result, error) in
            if let error = error {
                self.error = error.localizedDescription
            }
            else
            {
                guard let uid = result?.user.uid else { return }
                let db = Firestore.firestore().document("users/\(uid)")
                let values = ["name": self.username, "image": "", "email": self.email, "id": uid, "createdAt": Date().timeIntervalSince1970 as NSNumber,"user_posts": [String]()] as [String : Any]
                db.setData(values)
                self.email = ""
                self.password = ""
            }
        }
    }
    
    
    var body: some View{
        VStack{
            Text("Signup view").font(.system(size: 32, weight: .heavy))
            Text("Create Account").font(.system(size: 18, weight: .medium))
            
            VStack{
                TextField("Email", text: $email)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(Color.blue, lineWidth: 1))
                TextField("User Name", text: $username)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(Color.blue, lineWidth: 1))
                
                SecureField("Password", text: $password)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(Color.blue, lineWidth: 1))
            }
            .padding(.vertical, 64)
            
            Button(action: {
                
                
            }){
                Text("Sign up")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .bold))
                    .background(LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(5)
            }
            
            if(error != ""){
                Text(error)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }.padding(.horizontal, 32)
    }
}




struct LoginView: View {
    
    let universalSize = UIScreen.main.bounds
    
    @State var isAnimated = false
    
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @Binding var isloggedin: Bool
    
    
    @EnvironmentObject var session: SessionStore
    
    
    func getSinWave(interval: CGFloat, amplitude: CGFloat = 100, baseline: CGFloat = UIScreen.main.bounds.height / 2) -> Path {
        
        Path{ path in
            path.move(to: CGPoint(x: 0, y: universalSize.height / 2))
            path.addCurve(to: CGPoint(x: interval, y: baseline), control1: CGPoint(x: interval * 0.35, y: amplitude + baseline), control2: CGPoint(x: interval * 0.65, y: -amplitude + baseline)
            )
            
            path.addCurve(to: CGPoint(x: 2 * interval, y: baseline), control1: CGPoint(x: interval * 1.35, y: amplitude + baseline), control2: CGPoint(x: interval * 1.65, y: -amplitude + baseline)
            )
            
            path.addLine(to: CGPoint(x: 2 * interval, y: universalSize.height))
            path.addLine(to: CGPoint(x: 0, y: universalSize.height))
        }
        
    }
    
    var body: some View{
        
        
        ZStack{
            
            getSinWave(interval: universalSize.width, amplitude: 100, baseline: -50 + universalSize.height / 2).foregroundColor(.yellow).opacity(0.4).offset(x: isAnimated ? -1 * universalSize.width : 0)
                .animation(
                    Animation.linear(duration: 3)
                        .repeatForever(autoreverses: false))
            
            getSinWave(interval: universalSize.width * 1.2, amplitude: 150, baseline: 50 + universalSize.height / 2)
                .foregroundColor(.red).opacity(0.8).offset(x: isAnimated ? -1 * (universalSize.width * 1.2): 0)
                .animation(
                    Animation.linear(duration: 5.3)
                        .repeatForever(autoreverses: false))
            
            
            getSinWave(interval: universalSize.width * 1.4, amplitude: 110, baseline: 65 + universalSize.height / 2)
                .foregroundColor(.blue).opacity(0.8).offset(x: isAnimated ? -1 * (universalSize.width * 1.2): 0)
                .animation(
                    Animation.linear(duration: 4)
                        .repeatForever(autoreverses: false))
            
            VStack{
                
                Text("Go With Friends").font(.system(size: 32, weight: .heavy))
                Text("sign in to continue").font(.system(size: 18, weight: .medium))
                
                VStack{
                    TextField("Email", text: $email)
                        .font(.system(size: 20))
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(Color.white, lineWidth: 2))
                    
                    SecureField("Password", text: $password).font(.system(size: 20)).padding(12)
                        .background(RoundedRectangle(cornerRadius: 4).strokeBorder(Color.white, lineWidth: 2))
                }.padding(.vertical, 64)
                
                Button(action: {
                    
                    Auth.auth().signIn(withEmail: self.email, password: self.password, completion: { (user, error) in
                        
                        if error != nil{
                            print((error?.localizedDescription)!)
                            return
                        }
                            
                        else
                        {
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
                                    
                                    UserDefaults.standard.set(uid, forKey: "userid")
                                    UserDefaults.standard.set(name, forKey: "username")
                                    UserDefaults.standard.set(image, forKey: "image")
                                    UserDefaults.standard.set(favorites, forKey: "favorites")
                                    self.email = ""
                                    self.password = ""
                                    self.isloggedin.toggle()
                                    UserDefaults.standard.set(self.isloggedin, forKey: "isloggedin")
                                    
                                }
                            }
                        }
                    })
                    
                    
                }){
                    Text("Sign in").frame(minWidth: 0, maxWidth: .infinity).frame(height: 50).foregroundColor(.white).font(.system(size: 20, weight: .bold))
                        .background(RoundedRectangle(cornerRadius: 26).strokeBorder(Color.white, lineWidth: 2)).shadow(color: .gray, radius: 1, x: 1, y: 1)
                        .cornerRadius(5)
                }
                
                if(error != ""){
                    Text(error).font(.system(size: 14, weight: .semibold)).foregroundColor(.red).padding()
                }
                
                Spacer()
                
                NavigationLink(destination: SignUpView()){
                    
                    HStack{
                        Text("New user?").font(.system(size: 14, weight: .heavy)).foregroundColor(.primary)
                        Text("Create account").font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }.padding(.bottom)
                }
            }.padding(.horizontal, 32)
            
        }
        .onAppear(){
            self.isAnimated = true
        }
    }
    
}

