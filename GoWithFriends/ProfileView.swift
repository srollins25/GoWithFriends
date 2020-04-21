//
//  ProfileView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/9/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ProfileView: View {
    
    @EnvironmentObject var session: SessionStore
    @ObservedObject var postsObserver = PostObserver()
    
    func getUser()
    {
        session.listen()
    }
    
    var body: some View {

        VStack{
            HStack{
                Spacer()
                VStack{
                
                //Spacer()
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .clipped()
                    .padding(.top, 44)
                
                    Text("name")
                   
            }
                 Spacer()
        }
            Spacer()
            VStack{
            List{
//                if(postsObserver.posts.isEmpty)
//                {
//                    Text("No posts").fontWeight(.heavy)
//                }
//
//                else
//                {
//                    ForEach(postsObserver.posts.reversed()){ i in
//                        PostCell(id: i.id, name: i.name, image: i.image, postBody: i.postBody, comments: i.comments, favorites: i.favorites, createdAt: i.createdAt)
//                    }
//
//                }
                Text("test")
                Text("test")
                Text("test")
                
            }
        }
        }

    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
