//
//  PostThreadView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 6/2/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct PostThreadView: View {
    
    @Binding var closeView: Bool
    @Binding var mainPost: Post
    
    @ObservedObject var commentsObserver = CommentsObserver(parentPost_: UserDefaults.standard.string(forKey: "parentPost")!)
    
    var body: some View {
        
        ZStack{
            
            Color.white
            
            VStack{
                CustomNavBar(closeView: $closeView)
                Text("test")
//                VStack{
//
//                    HStack(alignment: .top){
//                        AnimatedImage(url: URL(string: mainPost.profileimage)).resizable().renderingMode(.original).frame(width: 60, height: 60).clipShape(Circle())
//
//                        Text(mainPost.name).font(.title)
//                        Spacer()
//                        Image(systemName: "ellipsis")
//                    }
//
//                    Text(mainPost.postBody)
//
//                    if(mainPost.image != ""){
//                        AnimatedImage(url: URL(string: mainPost.image)).resizable().renderingMode(.original).frame(height: 140).cornerRadius(8)
//                    }
//
//                    HStack{
//                        Button(action: {
//
//                        }){
//
//                            HStack{
//                                Image(systemName: "bubble.right")
//                                Text(mainPost.comments.count == 0 ? "" : "\(mainPost.comments.count)")
//                            }
//                        }.buttonStyle(BorderlessButtonStyle())
//
//                        Button(action: {
//
//                        }){
//
//                            HStack{
//                                Image(systemName: "star")
//                                Text(mainPost.favorites == 0 ? "" : "\(mainPost.favorites)")
//                            }
//                        }.buttonStyle(BorderlessButtonStyle())
//
//                        Button(action: {
//
//                        }){
//
//                                Image(systemName: "paperplane")
//                        }.buttonStyle(BorderlessButtonStyle())
//
//                        Text("\(Date(timeIntervalSince1970: TimeInterval(truncating: mainPost.createdAt)), formatter: RelativeDateTimeFormatter())").font(.footnote)
//                    }
//                }.padding()
                
    
                List{
                    ForEach(commentsObserver.comments) { post in
                        
                        if((post.id == self.commentsObserver.comments[0].id) || self.commentsObserver.comments.isEmpty)
                        {
                            PostCell(id: self.mainPost.id, user: self.mainPost.userID, name: self.mainPost.name, image: self.mainPost.image, profileimage: self.mainPost.profileimage, postBody: self.mainPost.postBody, comments: self.mainPost.comments, favorites: self.mainPost.favorites, createdAt:  self.mainPost.createdAt, parentPost: self.mainPost.parentPost)
                        }
                        
                        PostCell(id: post.id, user: post.userID, name: post.name, image: post.image, profileimage: post.profileimage, postBody: post.postBody, comments: post.comments, favorites: post.favorites, createdAt:  post.createdAt, parentPost: post.parentPost)
                    }
                }
            }
        }.edgesIgnoringSafeArea(.all)
        .onDisappear(perform: {
            UserDefaults.standard.set("", forKey: "parentPost")
            print("parent post close: ", UserDefaults.standard.string(forKey: "parentPost")!)
        })
    }
}

// when closing view set parent post to empty UserDefaults.standard.set(post.parentPost, forKey: "parentPost")

//struct PostThreadView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostThreadView()
//    }
//}
