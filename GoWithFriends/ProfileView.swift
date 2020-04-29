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
    @ObservedObject var userPostsObserver = UserPostObserver()
    @State var arr: [Post] = []
    @State var fetchPosts: Bool = true
    
    
    
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
                    if(userPostsObserver.posts.isEmpty)
                    {
                        Text("No posts").fontWeight(.heavy)
                    }
                        
                    else
                    {
                        //if(self.fetchPosts == true) {
                        ForEach(self.userPostsObserver.posts.reversed()) { post in
                                PostCell(id: post.id, name: post.name, image: post.image, postBody: post.postBody, comments: post.comments, favorites: post.favorites, createdAt: post.createdAt)
                            }
                            //self.fetchPosts = false
                        //}

                        
                    }
                    
                }
            }
        }
    .onAppear(perform: {
            // query for postsview
        //var db = CollectionReference.self
        
//        _ = Firestore.firestore().collection("posts").getDocuments { (snapshot, error) in
//            if let error = error {
//                print(error)
//            }
//            else
//            {
//                // check userdefaults logged in user posts array
//                if self.fetchPosts == true {
//                    for document in snapshot!.documents{
//                        let doc = document.data()
//                        print(doc["userId"] as! String)
//                        if (doc["userId"] as! String) == Auth.auth().currentUser?.uid{
//                            self.arr.append(Post(id: document.documentID, userID: doc["userId"] as! String, name: doc["name"] as! String, image: doc["image"] as! String, postBody: doc["body"] as! String, comments: doc["comments"] as! String, favorites: doc["favorites"] as! String, createdAt: doc["createdAt"] as! NSNumber))
//                        }
//                    }
//                    self.arr.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
//                    self.arr.reverse()
//                    self.fetchPosts.toggle()
//                }
//            }
//        }
    })
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
