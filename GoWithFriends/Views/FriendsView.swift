//
//  FriendsView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 6/25/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI

struct FriendsView: View {
    
    @Binding var closeView: Bool
    @ObservedObject var friends = FriendsObserver()
    @State var name = ""
    @State var uid = ""
    @State var pic = ""
    @State var isFriend: Bool = true
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> 
    @State var isLoggedIn = (UserDefaults.standard.bool(forKey: "isloggedin"))
    @State var fromSearch = true
    @State var user: PokeUser = PokeUser(id: "", name: "", profileimage: "", email: "", user_posts: [String](), createdAt: 0, trainerId: "")
    @State var show = false
    @State var showDeleteView = false
    
    var body: some View {
        NavigationView{
            VStack(spacing: 12){
                List(friends.friends){ i in
                        
                    ZStack{
                     
                        UserCell(id: i.id, name: i.name, image: i.profileimage).edgesIgnoringSafeArea(.all)
                        
                        NavigationLink(destination: ProfileView( user: self.$user, show: self.$show, isLoggedIn: self.$isLoggedIn, showDeleteView: self.$showDeleteView).navigationBarTitle("").edgesIgnoringSafeArea(.top)){
                             
                             EmptyView()
                         }.frame(width: 0)

                     
                     Button(action: {
                         self.user = i
                         self.show.toggle()
                         UIApplication.shared.endEditing()
                         UserDefaults.standard.set(self.user.id, forKey: "friendId")
                     }){
                         Text("")
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
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}


