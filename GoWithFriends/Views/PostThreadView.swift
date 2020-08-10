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
    
    @Binding var mainPost: Post
    @State var showSubThread = false
    @Binding var subParentPost: Post
    @State var subPost2 = Post(id: "", userID: "", name: "", trainerId: "", image: "", profileimage: "", postBody: "", comments: [String]() as NSArray, favorites: 0, createdAt: 0, parentPost: "", isReported: false)
    let transition = AnyTransition.move(edge: .trailing)
    @Binding var showDeleteView: Bool
    @EnvironmentObject var commentsObserver: CommentsObserver
    @State var isFavorite: Bool = false
    @State var isSubFavorite: Bool = false
    @State var favPic = Image(systemName: "star")
    @State var needSubRefresh: Bool = false
    
    var body: some View {
        
        ZStack{
            
            VStack{
                
                if(self.mainPost.isReported == false)
                {
                PostCell(id: self.mainPost.id, user: self.mainPost.userID, name: self.mainPost.name, trainerId: self.mainPost.trainerId, image: self.mainPost.image, profileimage: self.mainPost.profileimage, postBody: self.mainPost.postBody, comments: self.mainPost.comments, favorites: self.mainPost.favorites, createdAt:  self.mainPost.createdAt, parentPost: self.mainPost.parentPost, isFavorite: self.$isFavorite, showDeleteView: self.$showDeleteView).padding()
                }
                else
                {
                    
                    ReportedPostCell(id: self.mainPost.id, user: self.mainPost.userID, name: self.mainPost.name, trainerId: self.mainPost.trainerId, image: self.mainPost.image, profileimage: self.mainPost.profileimage, comments: self.mainPost.comments, favorites: self.mainPost.favorites, createdAt: self.mainPost.createdAt, parentPost: self.mainPost.parentPost, isFavorite: self.$isFavorite, showDeleteView: self.$showDeleteView).padding()
                }
                
                Divider()
                List(commentsObserver.comments) { post in
                        
                        if(post.id != self.mainPost.id)
                        {
                            ZStack{
                                
                                PostCell(id: post.id, user: post.userID, name: post.name, trainerId: post.trainerId, image: post.image, profileimage: post.profileimage, postBody: post.postBody, comments: post.comments, favorites: post.favorites, createdAt:  post.createdAt, parentPost: post.parentPost, isFavorite: self.$isFavorite, showDeleteView: self.$showDeleteView)
                                
                                NavigationLink(destination: PostThreadView(mainPost: self.$subParentPost, subParentPost: self.$subPost2, showDeleteView: self.$showDeleteView)){
                                    
                                    EmptyView()
                                }
                                
                                Button(action: {
                                    self.subParentPost = post
                                    
                                    UserDefaults.standard.set(self.subParentPost.id, forKey: "parentPost")
                                    self.showSubThread.toggle()
                                    self.isSubFavorite = (UserDefaults.standard.object(forKey: "favorites")! as? [String])!.contains(self.subParentPost.id)

                                    UIApplication.shared.endEditing()
                                    
                                }){
                                    Text("")
                                }
                                
                            }
                        }
                }
            }
            
        }.navigationBarTitle(Text("Thread"), displayMode: .inline).background(Color(UIColor.systemBackground))
            .onAppear(perform: {
                self.isFavorite = (UserDefaults.standard.object(forKey: "favorites")! as? [String])!.contains(self.mainPost.id)
            })
            .onDisappear(perform: {
                
                if(self.showSubThread == false)
                {
                    UserDefaults.standard.set("", forKey: "parentPost")
                }
                    
                else
                {
                    UserDefaults.standard.set(self.mainPost.id, forKey: "parentPost")
                }
                
               
            })
    }
}

// when closing view set parent post to empty UserDefaults.standard.set(post.parentPost, forKey: "parentPost")

//struct PostThreadView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostThreadView()
//    }
//}
