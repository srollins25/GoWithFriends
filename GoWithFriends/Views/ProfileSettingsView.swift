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
    @Binding var closeProfileView: Bool
    @State var showAlert = false
    @Binding var showDeleteVerify: Bool
    @State var showAfterDismiss = false
    //@State var showDeleteView = false
    @Binding var showDeleteView: Bool//final delete screen
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        NavigationView{
        
        ZStack{
                VStack{

                    List{
                        Section{
                            NavigationLink(destination: EditProfileInfo())
                            {
                                Text("Edit Profile")
                            }
                        }
                        
                        
                        Section{

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
                                    self.showDeleteView.toggle()
                                }
                            }))
                        }
                        }
                        
                    }.listStyle(GroupedListStyle())
                }
        }.onDisappear(perform: {
            if(self.showAfterDismiss == true)
            {
                self.closeProfileView.toggle()
                
            }
        })
            .navigationBarTitle(Text("Settings"))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

//struct ProfileSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileSettingsView()
//    }
//}
