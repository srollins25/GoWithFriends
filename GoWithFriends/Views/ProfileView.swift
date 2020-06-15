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
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @ObservedObject var currentUserPostsObserver = UserPostObserver()
    @ObservedObject var favoritePostsObserver = FavoritePostsObserver()
    @State var userPosts: [Post] = []
    @State var userFavorites: [Post] = []
    @State var fetchPosts: Bool = true
    @State private var name: String = ""
    @State private var image: String = ""
    @State var profileArrIndex = 0
    @Binding var user: User
    @Binding var show: Bool
    @Binding var fromSearch: Bool
    
    
    var body: some View {
        
        ZStack(alignment: .top){
            VStack{
                HStack{
                    Spacer()
                    VStack{
                        
                        AnimatedImage(url: URL(string: user.profileimage))
                            .resizable()
                            .renderingMode(.original)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .clipped()
                            .padding(.top, 40)
                        Text("\(user.name) hello")
                    }
                    Spacer()
                }
                Spacer()
                
                VStack{
                    
                    if(currentUserPostsObserver.currentuserposts.isEmpty)
                    {
                        Text("No posts").fontWeight(.heavy)
                        Spacer()
                    }
                        
                    else
                    {
    
                        List{
                            
                            Picker(selection: $profileArrIndex, label: Text("")) {
                                Text("Posts").tag(0)
                                Text("Favorites").tag(1)
                            }.pickerStyle(SegmentedPickerStyle())
                            
                            if(profileArrIndex == 0)
                            {
                                if(self.user.id == UserDefaults.standard.string(forKey: "userid"))
                                {
                                    ForEach(self.currentUserPostsObserver.currentuserposts.reversed()) { post in
                                        PostCell(id: post.id, user: post.userID, name: post.name, image: post.image, profileimage: post.profileimage, postBody: post.postBody, comments: post.comments, favorites: post.favorites, createdAt: post.createdAt, parentPost: post.parentPost)
                                    }
                                }
                                else
                                {
                                    ForEach(self.userPosts.reversed()) { post in
                                        PostCell(id: post.id, user: post.userID, name: post.name, image: post.image, profileimage: post.profileimage, postBody: post.postBody, comments: post.comments, favorites: post.favorites, createdAt: post.createdAt, parentPost: post.parentPost)
                                    }
                                }
                            }
                                
                                
                                
                            else
                            {
                                if(favoritePostsObserver.favoritePosts.isEmpty)
                                {
                                    Text("No favorites").fontWeight(.heavy)
                                    Spacer()
                                }
                                else
                                {
                                    if(self.user.id == UserDefaults.standard.string(forKey: "userid"))
                                    {
                                        ForEach(self.favoritePostsObserver.favoritePosts){ post in
                                            
                                            PostCell(id: post.id, user: post.userID, name: post.name, image: post.image, profileimage: post.profileimage, postBody: post.postBody, comments: post.comments, favorites: post.favorites, createdAt: post.createdAt, parentPost: post.parentPost)
                                            
                                        }
                                    }
                                    else
                                    {
                                        ForEach(self.userFavorites){ post in
                                            
                                            PostCell(id: post.id, user: post.userID, name: post.name, image: post.image, profileimage: post.profileimage, postBody: post.postBody, comments: post.comments, favorites: post.favorites, createdAt: post.createdAt, parentPost: post.parentPost)
                                            
                                        }
                                    }
                                    
                                    

                                }
                            }
                        }
                    }
                }
            }
            
            if(fromSearch == true)
            {
                CustomNavBar(closeView: self.$show).edgesIgnoringSafeArea(.top)
            }
        }
            
        .background(Color.white)
        .onAppear(perform: {
            print("userid1: ", self.user.id)
            print("username: ", self.user.name)
            if(self.user.id != UserDefaults.standard.string(forKey: "userid"))
            {
                // this gets posts for the user thats been searched for
                self.getUserPosts()
            }
        })
    }
    
    func getUserPosts()
    {
        if(self.user.id != UserDefaults.standard.string(forKey: "userid"))
        {
            let uid = user.id
            let db = Firestore.firestore()
            var favorites: [String] = []
            
            db.collection("users").document(uid).addSnapshotListener{ (snap, error) in
                
                if error != nil{
                    print((error?.localizedDescription)!)
                    return
                }
                
                guard let document = snap else {
                  print("Error fetching document: \(error!)")
                  return
                }
                guard let data = document.data() else {
                  print("Document data was empty.")
                  return
                }
                
                favorites = ((data["favorites"] as? [String])!)
                print("favorites count: ", favorites.count)
                
            }
            
            
//            ref.getDocument{ (snap, error) in
//
//                if(error != nil){
//                    print((error?.localizedDescription)!)
//                    return
//                }
//
//                let data = snap?.data()
//                favorites = (data!["favorites"] as? [String])!
//
//            }
            
            db.collection("posts").addSnapshotListener { (snap, error) in
                
                if error != nil{
                    print((error?.localizedDescription)!)
                    return
                }
                
                for i in snap!.documentChanges
                {
                    if(i.type == .added){
                        if((i.document.get("userId") as! String) == uid){
                            let id = i.document.documentID
                            let name = i.document.get("name") as! String
                            let userId = i.document.get("userId") as! String
                            let image = i.document.get("image") as! String
                            let profileimage = i.document.get("profileimage") as! String
                            let comments = i.document.get("comments") as! NSArray
                            let body = i.document.get("body") as! String
                            let favorites = i.document.get("favorites") as! NSNumber
                            let parentPost = i.document.get("parentPost") as! String
                            let createdAt = i.document.get("createdAt") as! NSNumber
                            
                            self.userPosts.append(Post(id: id, userID: userId, name: name, image: image, profileimage: profileimage, postBody: body, comments: comments, favorites: favorites, createdAt: createdAt, parentPost: parentPost))
                            self.userPosts.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
                        }
                        
                        if(favorites.contains(i.document.documentID))
                        {
                            let id = i.document.documentID
                            let name = i.document.get("name") as! String
                            let userId = i.document.get("userId") as! String
                            let image = i.document.get("image") as! String
                            let profileimage = i.document.get("profileimage") as! String
                            let comments = i.document.get("comments") as! NSArray
                            let body = i.document.get("body") as! String
                            let favorites = i.document.get("favorites") as! NSNumber
                            let parentPost = i.document.get("parentPost") as! String
                            let createdAt = i.document.get("createdAt") as! NSNumber
                            
                            self.userFavorites.append( Post(id: id, userID: userId, name: name, image: image, profileimage: profileimage, postBody: body, comments: comments, favorites: favorites, createdAt: createdAt, parentPost: parentPost) )
                        }
                    }
                    
                    if(i.type == .removed){
                        
                        let id = i.document.documentID
                        
                        for j in 0..<self.userPosts.count{
                            if (self.userPosts[j].id == id){
                                self.userPosts.remove(at: j)
                                return
                            }
                        }
                        
                        if(favorites.contains(i.document.documentID))
                        {
                            for j in 0..<self.userFavorites.count{
                                if (self.userFavorites[j].id == id){
                                    self.userFavorites.remove(at: j)
                                    return
                                }
                            }
                        }
                        

                    }
                    
                    if(i.type == .modified){
                        let id = i.document.documentID
                        let favorites_ = i.document.get("favorites") as! NSNumber
                        let comments = i.document.get("comments") as! NSArray
                        
                        for j in 0..<self.userPosts.count{
                            if(self.userPosts[j].id == id){
                                self.userPosts[j].favorites = favorites_
                                self.userPosts[j].comments = comments
                                return
                            }
                        }
                        
                        if(favorites.contains(i.document.documentID))
                        {
                            for j in 0..<self.userPosts.count{
                                if(self.userFavorites[j].id == id){
                                    self.userFavorites[j].favorites = favorites_
                                    self.userFavorites[j].comments = comments
                                    return
                                }
                            }
                        }
   
                    }
                }
            }     
        }
    }
}

struct CustomNavBar: View {
    
    @Binding var closeView: Bool
    
    var body: some View{
        
        ZStack{
            
            CustomNavBarBack()
            
            VStack(spacing: 0){
                HStack(alignment: .top, spacing: 8){
                    Button(action: {
                        
                        withAnimation(.easeOut(duration: 0.5)){
                            self.closeView.toggle()
                        }
                    }){
                        Text("Back").foregroundColor(Color.black.opacity(0.5)).padding(9)
                    }
                    .background(Color.white)
                    .shadow(color: .gray, radius: 7, x: 1, y: 1)
                    .clipShape(Capsule())
                    Spacer()
                }
                .padding(.top , (UIApplication.shared.windows.first?.safeAreaInsets.top)! )
                .padding(.horizontal)
                .padding(.bottom, 5)
                    
                .background(Color.black.opacity(0.3))
                
                //Spacer()
            }
        }
    }
    
    struct CustomNavBarBack: View {
        
        
        var body: some View{
            
            VStack(spacing: 0){
                HStack(alignment: .top,spacing: 8){
                    
                    Text("")
                    Spacer()
                }
                .padding(.top , (UIApplication.shared.windows.first?.safeAreaInsets.top)! )
                .padding(.horizontal)
                .padding(.bottom, 5)
                    
                .background(Color.white)
                
                //Spacer()
            }
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
