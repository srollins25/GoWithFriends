//
//  ForgotPasswordView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 6/25/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import Firebase

struct ForgotPasswordView: View {
    
    @State var email = ""
    @State var alertMessage = ""
    @State var alertTitle = ""
    @State var showAlert = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        NavigationView{
            VStack{
                       
                Text("Enter your email address and an email will be sent to recover your account.").fontWeight(.bold).padding(.top, 10).padding(.bottom, 20).lineLimit(6)
                       TextField("", text: self.$email)
                       Divider()
                       Button(action: {
                        
                        Auth.auth().sendPasswordReset(withEmail: self.email) { error in
                            if error != nil{
                                print((error?.localizedDescription)!)
                                self.alertTitle = "Error"
                                self.alertMessage = (error?.localizedDescription)!
                                self.showAlert.toggle()
                                return
                            }
                            self.alertTitle = "Success"
                            self.alertMessage = "An email has been sent."
                            self.showAlert.toggle()
                            //alert email send then close view
                        }
                        
                        self.email = ""
                       }){
                           Text("Send")
                       }.alert(isPresented: self.$showAlert){
                        Alert(title: Text(self.alertTitle), message: Text(self.alertMessage), dismissButton: .cancel(Text("Done"), action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }))
                }
            }.padding(.horizontal, 45)
            .navigationBarItems(leading: Button(action: {
                 self.email = ""
                self.presentationMode.wrappedValue.dismiss()
            }){
                Text("Cancel")
            })
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
