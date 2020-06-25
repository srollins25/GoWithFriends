//
//  ProfileSettingsView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 6/23/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import Firebase

struct ProfileSettingsView: View {
    
    @Binding var closeView: Bool
    @State var showAlert = false
    @Binding var showDeleteVerify: Bool
    @State var showAfterDismiss = false
    @State var showDeleteView = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        ZStack{
            HStack{
                Spacer()
                VStack{
                    
                    HStack{
                        Button(action: {
                            self.closeView.toggle()
                            
                        }){
                            Text("Cancel") 
                        } 
                        Spacer()
                    }
                    .padding(.top, (UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.safeAreaInsets.top)!)
                    Spacer()
                    Button(action: {
                        self.showAlert = true
                       
                    }){
                        Text("Delete Account").foregroundColor(.red)
                    }.alert(isPresented: self.$showAlert){
                        Alert(title: Text("Delete Account"), message: Text("Do you wish to delete your account?"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete"), action: {
                            self.presentationMode.wrappedValue.dismiss()
                            if(self.showAlert == false)
                            {
                                    self.showAfterDismiss.toggle()

                            }
                        }
                            ))
                    }
                    
                    Spacer()
                }
                Spacer()
            }
        }.onDisappear(perform: {
            if(self.showAfterDismiss == true)
            {
                //DispatchQueue.main.async {
                    self.showDeleteVerify.toggle()
                //}
            }
        })
    }
}

//struct ProfileSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileSettingsView()
//    }
//}
