//
//  ReAuthView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 7/10/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import Firebase

struct ReAuthView: View {
    
    @State var email = ""
    @State var pass = ""
    @State var error = ""
    @State var title = ""
    @Binding var closeView: Bool
    @State var showAlert = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        
        
        ZStack{
            
            Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)
            
            VStack{
                
                Text("Authorize Account").foregroundColor(.blue).font(.title).fontWeight(.bold).padding(.top, 10).padding(.bottom, 20)
                //Spacer()
                Text("Enter login creditials to reauthorize account.")
                VStack{
                    TextField("Email", text: self.$email)
                    Divider()
                    SecureField("Password", text: self.$pass)
                    Divider()
                    
                    HStack(spacing: 10){
                        
                        Button(action: {
                            
                            withAnimation(.easeOut(duration: 0.5)){
                                self.closeView.toggle()
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            
                        }){
                            Text("Cancel")
                        }
                        
                        Button(action: {
                            
                            if(self.email == "" || self.pass == "")
                            {
                                self.showAlert.toggle()
                                self.error = "All fields must be filled out."
                                self.title = "Error"
                            }
                            else
                            {
                                
                                let user = Auth.auth().currentUser
                                let credential = EmailAuthProvider.credential(withEmail: self.email, password: self.pass)
                                
                                user?.reauthenticate(with: credential) { (result, error) in
                                    if let error = error {
                                        self.showAlert.toggle()
                                        self.error = error.localizedDescription
                                    } else {
                                        // User re-authenticated.
                                        // loading "updating email"

                                        //self.presentationMode.wrappedValue.dismiss()
                                        self.error = "Account authorized."
                                        self.title = "Success"
                                        self.showAlert.toggle()
                                        
                                        
                                        //UserDefaults.standard.set(self.email, forKey: "email")
                                    }
                                }
                            }
                        }){
                            Text("Submit").foregroundColor(.green)
                        }.alert(isPresented: self.$showAlert){
                            
                            Alert(title: Text(self.title), message: Text(self.error), dismissButton: .default(self.title == "Success" ? Text("Done") : Text("Close"), action: {
                                
                                if(self.title == "Success")
                                {
                                    self.presentationMode.wrappedValue.dismiss()
                                    self.closeView.toggle()
                                }

                            }))
                        }
                    }
                }.padding(.horizontal, 45)
            }
        }
        
        
    }
}

//struct ReAuthView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReAuthView()
//    }
//}
