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
    @ObservedObject var friends = getFriends()
    @State var name = ""
    @State var uid = ""
    @State var pic = ""
    @State var isFriend: Bool = true
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView{
            VStack(spacing: 12){
                List{
                    ForEach(friends.users){ i in
                        
                        Button(action: {
                            
                            self.uid = i.id
                            self.name = i.name
                            self.pic = i.profileimage
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
        }
    }
}

//struct FriendsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsView()
//    }
//}
