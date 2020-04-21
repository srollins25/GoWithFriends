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

struct SignInView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    
    @EnvironmentObject var session: SessionStore
    
    @State private var gradientColor: [Color] = [Color.blue, Color.yellow, Color.red ]
    let unitPointArr = [UnitPoint.bottom, .bottomLeading, .bottomTrailing, .center, .leading, .top, .topLeading, .topTrailing, .trailing]
    @State private var startPoint: UnitPoint
    @State private var endPoint: UnitPoint
    //@State private var count = 0
    
    init() {
        _startPoint = State(initialValue: .topLeading)
        _endPoint = State(initialValue: .bottomTrailing)
    }
    
    func signIn() {
        session.signIn(email: email, password: password) { (result, error) in
            if let error = error{
                self.error = error.localizedDescription
            }
            else
            {
                self.email = ""
                self.password = ""
            }
        }
    }

    var body: some View{
        
        ZStack{
            LinearGradient(gradient: Gradient(colors: gradientColor), startPoint: startPoint, endPoint: endPoint).edgesIgnoringSafeArea(.all).blur(radius: 2)
                .animation(Animation.easeInOut(duration: 5).repeatForever(autoreverses: true))
                .onAppear(){
                    self.startPoint = self.unitPointArr[0]
                    self.endPoint = self.unitPointArr[self.unitPointArr.count - 1]
            }
            
        VStack{
            
            Text("Welcome back").font(.system(size: 32, weight: .heavy))
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
            
            Button(action: signIn){
                Text("Sign in").frame(minWidth: 0, maxWidth: .infinity).frame(height: 50).foregroundColor(.white).font(.system(size: 20, weight: .bold))
                    .background(RoundedRectangle(cornerRadius: 26).strokeBorder(Color.white, lineWidth: 2))
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
    }
}

struct SignUpView: View {
    
    @State var email: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @EnvironmentObject var session: SessionStore
    
    func signUp()
    {
        
        session.signUp(email: email, password: password) { (result, error) in
            if let error = error {
                self.error = error.localizedDescription
            }
            else
            {
                guard let uid = result?.user.uid else { return }
                let db = Firestore.firestore().document("users/\(uid)")
                let values = ["name": self.username, "image": "", "email": self.email, "id": UUID().uuidString, "posts": [String].self] as [String : Any]
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
                
            Button(action: signUp){
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
    
    var body: some View{
        NavigationView{
            SignInView()
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
