//
//  LoginView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/8/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import Firebase
import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


struct SignUpView: View {
    
    @State var email: String = ""
    @State var name: String = ""
    @State var trainerId: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var validatePassword: String = ""
    @State var error: String = ""
    @Binding var isloggedin: Bool
    @Binding var index: Int
    @State var imagePicker = false
    @State var imageData: Data = .init(count: 0)
    @State var showAlert = false
    @State var namefiltered = ""
    @State var trainercodefiltered = ""
    @State var pwfiltered = ""
    @State var vpwfiltered = ""
    @Binding var showLoading: Bool
    @Binding var isChecked: Bool
    @Environment(\.colorScheme) var scheme
    
    var body: some View{
        VStack{
            
            ZStack(alignment: .bottom){
                VStack{
                
                    // profile image selecter
                    if(self.imageData.count == 0){
                        Image(systemName: "person.crop.circle.badge.plus").resizable().aspectRatio(contentMode: .fill).frame(width: 40, height: 40).foregroundColor(.white).onTapGesture {
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
                            Image(systemName: "person.crop.circle.fill").foregroundColor(.white)
                            
                            TextField("Username", text: self.$name).foregroundColor(.white)
                        }
                        Divider().background(Color.white)
                    }
                    .padding(.horizontal)
                    .padding(.top, 6)
                    
                    VStack{
                        HStack(spacing: 15){
                            Image(systemName: "envelope.fill").foregroundColor(.white)
                            
                            TextField("Email", text: self.$email).keyboardType(.emailAddress).foregroundColor(.white)
                        }
                        Divider().background(Color.white)
                    }
                    .padding(.horizontal)
                    .padding(.top, 6)
                    
                    VStack{
                        HStack(spacing: 15){
                            Image(systemName: "number.square.fill").foregroundColor(.white)
                            
                            TextField("Trainer Code", text: self.$trainerId).keyboardType(.numberPad).foregroundColor(.white)
                        }
                        Divider().background(Color.white)
                    }
                    .padding(.horizontal)
                    .padding(.top, 6)
                    
                    VStack{
                        HStack(spacing: 15){
                            Image(systemName: "eye.slash.fill").foregroundColor(.white)
                            
                            SecureField("Password", text: self.$password).foregroundColor(.white)
                        }
                        Divider().background(Color.white)
                    }
                    .padding(.horizontal)
                    .padding(.top, 6)
                    
                    VStack{
                        HStack(spacing: 15){
                            Image(systemName: "eye.slash.fill").foregroundColor(.white)
                            
                            SecureField("Retype Password", text: self.$validatePassword).foregroundColor(.white)
                        }
                        Divider().background(Color.white)
                    }
                    .padding(.horizontal)
                    .padding(.top, 6)
                    
                }
                .padding()
                .padding(.bottom, 60)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                    self.index = 1
                }
                .padding(.horizontal, 20)
                
                // sign up button
                Button(action: {
                    UIApplication.shared.endEditing()
                    
                    
                    if(self.email.isBlank == true || self.password.isBlank == true || self.validatePassword.isBlank == true || self.trainerId.isBlank == true)
                    {
                        self.showAlert.toggle()
                        self.error = "All fields must be filled."
                    }
                    else if(self.password != self.validatePassword)
                    {
                        self.showAlert.toggle()
                        self.error = "Passwords do not match."
                    }
                    else if(self.imageData.count == 0)
                    {
                        self.showAlert.toggle()
                        self.error = "Image must be selected."
                    }
                    else if(self.isChecked == false)
                    {
                        self.showAlert.toggle()
                        self.error = "You must agree to the Terms of Service to continue."
                    }
                    else if(self.trainerId.count != 12)
                    {
                        self.showAlert.toggle()
                        self.error = "Trainer Code must be 12 digits."
                    }
                    else
                    {
                        self.showLoading = true
                        AuthCreatedUser()
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
                .alert(isPresented: self.$showAlert){
                    Alert(title: Text("Invalid Form"), message: Text(error), dismissButton: .cancel(Text("Cancel"),action: {
                        self.showLoading = false
                    }))
                }
                .offset(y: 25)
                .opacity(self.index == 1 ? 1 : 0)
            }
        }
    }
}


struct LoginView: View {
    
    @State var index = 0
    @Binding var isloggedin: Bool
    @State var showLoading = false
    @State var isChecked = false
    @State var showTerms = false
    
    var body: some View{
        
        GeometryReader{_ in
            ZStack(alignment: .center){

            VStack{
                
                Text(self.index == 0 ? "Login" : "Create Account").font(.largeTitle).foregroundColor(.white).padding(10)
                Picker(selection: $index, label: Text("")) {
                    Text("Sign in").tag(0)
                    Text("Register").tag(1)
                }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal, 10)
                
                //ZStack{

                    index == 0 ? AnyView(LoginFormView(isloggedin: self.$isloggedin, index: self.$index, showLoading: self.$showLoading)) : AnyView( SignUpView(isloggedin: self.$isloggedin, index: self.$index, showLoading: self.$showLoading, isChecked: self.$isChecked).zIndex(Double(self.index)))


                //}
                
//                if(self.index == 0)
//                {
//                    HStack(spacing: 15){
//                        Rectangle()
//                            .fill(Color.gray)
//                            .frame(height: 1)
//                        Text("Or")
//                        Rectangle()
//                            .fill(Color.gray)
//                            .frame(height: 1)
//                    }.padding(.horizontal, 20)
//                        .padding(.top, 50)
//
//
//                    //other login buttons
//                    HStack(spacing: 25){
//                        Button(action: {
//
//                        }){
//
//                            Text("test")
//                        }
//                    }.padding(.top, 30)
//                }
                
                if(self.index == 1)
                {
                    // show terms of service checkbox + button under sign up view
                    HStack(spacing: 10){
                        Button(action: {
                            self.isChecked.toggle()
                        }){
                            Image(systemName: self.isChecked ? "checkmark.square.fill" : "square").frame(width: 15, height: 15)
                        }
                        
                        Button(action: {
                            self.showTerms.toggle()
                        }){
                            Text("Terms of Service")
                        }.sheet(isPresented: self.$showTerms){
                            NavigationView{
                                TermsofServiceView()
                            }.navigationViewStyle(StackNavigationViewStyle())
                        }
                    }.padding(.vertical).padding(.top, 15)
                }

                    
            }.padding([ .top], UIScreen.main.bounds.height / 4)
                
                if(self.showLoading)
                {
                    LoaderView()
                }
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [.yellow, .blue, .red]), startPoint: .top, endPoint: .bottom)).edgesIgnoringSafeArea(.all)
    }
}

struct LoginFormView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @Binding var isloggedin: Bool
    @Binding var index: Int
    @State var showAlert = false
    @State var showForgotPass = false
    @Binding var showLoading: Bool
    @Environment(\.colorScheme) var scheme
    @State var fromLogin = true
    
    
    var body: some View{
        
        ZStack(alignment: .bottom){
            VStack{
                Spacer().frame(width: 45, height: 35)
                VStack{
                    HStack(spacing: 15){
                        Image(systemName: "envelope.fill").foregroundColor(.white)
                        
                        TextField("Email", text: self.$email).keyboardType(.emailAddress).foregroundColor(.white)
                    }
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                VStack{
                    HStack(spacing: 15){
                        Image(systemName: "eye.slash.fill").foregroundColor(.white)
                        
                        SecureField("Password", text: self.$password).foregroundColor(.white)
                    }
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                HStack{
                    Spacer(minLength: 0)
                    
                    Button(action: {
                        self.showForgotPass.toggle()
                    }){
                        Text("Forgot Password?").foregroundColor(Color.white.opacity(0.6))
                    }.sheet(isPresented: self.$showForgotPass){
                        ForgotPasswordView(fromLogin: self.$fromLogin)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 30)
            }
            .padding()
            .padding(.bottom, 65)
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            .onTapGesture {
                UIApplication.shared.endEditing()
                self.index = 0
            }
            .cornerRadius(35)
            .padding(.horizontal, 20)
            
            // login button
            Button(action: {
                
                UIApplication.shared.endEditing()
                if(self.email == "" || self.password == "")
                {
                    self.showAlert.toggle()
                    self.error = "All fields must be filled."
                }
                else
                {
                    self.showLoading.toggle()
                    LoginUser()
                }
                
            }){
                Text(" Login ").foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color.green.opacity(0.8))
                    .clipShape(Capsule())
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
            }
            .alert(isPresented: self.$showAlert){
                Alert(title: Text("Error"), message: Text(self.error), dismissButton: .cancel(Text("Cancel"), action: {
                    self.showLoading = false//.toggle()
                }))
            }
            .offset(y: 25)
            .opacity(self.index == 0 ? 1 : 0)
        }
    }

}




