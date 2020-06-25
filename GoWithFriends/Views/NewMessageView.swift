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
    
    @ObservedObject var users = getFriends()
    @Binding var name: String
    @Binding var uid: String
    @Binding var pic: String
    @Binding var show: Bool
    @Binding var chat: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var openchat = false
    @State var isFriend: Bool = false
    @EnvironmentObject var showTabBar: ShowTabBar
    
    var body: some View{
        
        
        NavigationView{
            VStack(spacing: 12){
                List{
                    ForEach(users.users){ i in
                        
                        Button(action: {
                            
                            self.uid = i.id
                            self.name = i.name
                            self.pic = i.profileimage
                            self.show = false
                            self.openchat = true
                        }){
                            UserCell(id: i.id, name: i.name, image: i.profileimage)
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
                self.showTabBar.showTabBar = false
            })
            .onDisappear(perform: {
                    if(self.openchat == true){
                        
                        self.chat.toggle()
                    }
                })
        }
    }
}

class getFriends: ObservableObject{
    
    @Published var users = [PokeUser]()
    
    
    init(){
        let db = Firestore.firestore()
        
        let friends = UserDefaults.standard.array(forKey: "friends") as? [String]
        db.collection("users").getDocuments{ (snapshot, error) in //user friends
            
            
            if(error != nil)
            {
                print((error?.localizedDescription)!)
                return
            }
            
            for i in snapshot!.documents{
                let id = i.documentID
                let name = i.get("name") as! String
                //let email = i.get("email") as! String
                let image = i.get("image") as! String
                if(friends!.contains(id))
                {
                    self.users.append(PokeUser(id: id, name: name, profileimage: image, email: "", user_posts: [String](), createdAt: 0))
                } 
            }
        }
    }
}


























