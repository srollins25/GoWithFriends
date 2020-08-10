//
//  NewMessageView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 5/4/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct NewMessageView: View{
    
    @ObservedObject var friends = FriendsObserver()
    @Binding var name: String
    @Binding var uid: String
    @Binding var pic: String
    @Binding var show: Bool
    @Binding var chat: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var openchat = false
    @State var isFriend: Bool = false
    
    
    var body: some View{
        
        
        NavigationView{
            VStack(spacing: 12){
                List{
                    ForEach(friends.friends){ i in
                        
                        
                        ZStack{
                            
                            UserCell(id: i.id, name: i.name, image: i.profileimage).edgesIgnoringSafeArea(.all)
                            
                            NavigationLink(destination: ChatView(pic: self.pic, name: self.name, uid: self.uid, chat: self.$openchat)){
                                
                                EmptyView()
                            }.frame(width: 0)
                            
                            
                            Button(action: {
                                self.uid = i.id
                                self.name = i.name
                                self.pic = i.profileimage
                                
                                
                            }){
                                Text("")
                            }
                            
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Friends"))
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }){
                Text("Cancel")
            })
            .onAppear(perform: {

            })
            .onDisappear(perform: {
                    
            })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}











