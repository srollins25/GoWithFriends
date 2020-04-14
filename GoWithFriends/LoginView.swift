//
//  LoginView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/8/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI

struct SignInView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    
    @EnvironmentObject var session: SessionStore
    
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
        VStack{
            Text("Welcome back").font(.system(size: 32, weight: .heavy))
            
            Text("sign in to continue").font(.system(size: 18, weight: .medium))
            
            VStack{
                TextField("Email", text: $email)
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
            
            Button(action: signIn){
                Text("Sign in")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .bold))
                    .background(LinearGradient(gradient: Gradient(colors: [.red, .green, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(5)
            }
            
            if(error != ""){
                Text(error)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red)
                .padding()
            }
            
            Spacer()
            
            NavigationLink(destination: SignUpView()){
                
                HStack{
                    Text("New user?")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.primary)
                    
                    Text("Create account")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.purple)
                }
                
            }
        }
        .padding(.horizontal, 32)
    }
}

struct SignUpView: View {
    
    @State var email: String = ""
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
