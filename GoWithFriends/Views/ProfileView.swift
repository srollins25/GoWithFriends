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
    
    @EnvironmentObject var passedPosts: PostObserver
    @ObservedObject var currentUserPostsObserver = UserPostObserver()
    @ObservedObject var favoritePostsObserver = FavoritePostsObserver()
    @State var userPosts: [Post] = []
    @State var userFavorites: [Post] = []
    @State var currentUserFriends = (UserDefaults.standard.object(forKey: "friends")! as? [String])!
    @State var fetchPosts: Bool = true
    @State private var name: String = ""
    @State private var image: String = ""
    @State var profileArrIndex = 0
    @Binding var user: User
    @Binding var show: Bool
    @Binding var fromSearch: Bool
    @State var showMoreMenu = false
    @State var buttonImage: Image = Image(systemName: "person.circle")
    @State var buttonText = ""
    @State var isFriend: Bool = (UserDefaults.standard.object(forKey: "friends")! as? [String])!.contains(UserDefaults.standard.string(forKey: "friendId")!)
    
    var body: some View {
        
        ZStack(alignment: .top){
            VStack{
                HStack{
                    Spacer()
                    VStack{
                        
                        HStack{
                            AnimatedImage(url: URL(string: user.profileimage))
                                .resizable()
                                .renderingMode(.original)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .clipped()
                                .padding(.top, 40)
                        }
                        
                        Text("\(user.name)")
                        //check if from search or not
                        
                        if(self.fromSearch)
                        {
                            HStack{
                                
                                VStack{
                                    Button(action: {
                                        
                                        self.currentUserFriends = (UserDefaults.standard.array(forKey: "friends")! as? [String])!
                                        /*!(self.currentUserFriends.contains(self.user.id))*/ self.isFriend == false ? self.addFriend() :  self.deleteFriend()
                                        print("friend button pressed")
                                        print("contains friend: ", self.currentUserFriends.contains(self.user.id))
                                    }){
                                        
                                        self.buttonImage.resizable().renderingMode(.original).aspectRatio(contentMode: .fill).frame(width: 30, height: 30)
                                        
                                        //check to see if in friends list
                                    }
                                    
                                      Text(buttonText).font(.footnote)
                                }
                                
                                VStack{
                                    Button(action: {
                                        
                                    }){
                                        
                                        Image(systemName: "envelope").resizable().renderingMode(.original).aspectRatio(contentMode: .fill).frame(width: 30, height: 30)
                                        
                                    }
                                    Text("Message").font(.footnote)
                                }
                                
                                ZStack{
                                    
                                    VStack{
                                        Button(action: {
                                            self.showMoreMenu.toggle()
                                        }){
                                            
                                            Image(systemName: "line.horizontal.3.decrease.circle").resizable().renderingMode(.original).aspectRatio(contentMode: .fill).frame(width: 30, height: 30)
                                            
                                        }
                                        Text("More").font(.footnote)
                                    }
                                    
                                    if(self.showMoreMenu)
                                    {
                                        MoreMenu(show: self.$showMoreMenu, user: self.$user)
                                    }
                                }
                            }.padding()
                        }
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

                self.getUserPosts()
            }

            if(self.isFriend == false)
            {
                self.buttonImage =  Image(systemName: "person.crop.circle.badge.plus")
                self.buttonText = "Follow"
                self.isFriend = false
            }
            else
            {
                self.buttonImage = Image(systemName: "person.crop.circle.badge.minus")
                self.buttonText = "Unfollow"
                self.isFriend = true
            }
        })
    }
    
    func addFriend()
    {
        
        let uid = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        let ref = db.collection("users").document(uid!)
        ref.getDocument { (snap, error) in
            
            if(error != nil)
            {
                print((error?.localizedDescription)!)
                return
            }
            ref.updateData(["friends": FieldValue.arrayUnion([self.user.id])])
            self.passedPosts.posts.append(contentsOf: self.userPosts)
            self.passedPosts.posts.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
            print("friend added")
            let data = snap?.data()
            let friends = data!["friends"] as? [String]
            UserDefaults.standard.set(friends, forKey: "friends")
            //print("friends after butten press: ", UserDefaults.standard.string(forKey: "friends")?.description)
            //UserDefaults.standard.synchronize()
            self.currentUserFriends = friends!
            self.buttonImage =  Image(systemName: "person.crop.circle.badge.minus")
            self.buttonText = "Unfollow"
            self.isFriend = true
        }
    }
    
    func deleteFriend()
    {
        print("entering delete friend method")
        let uid = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        let ref = db.collection("users").document(uid!)
        ref.getDocument { (snap, error) in
            
            if(error != nil)
            {
                print((error?.localizedDescription)!)
                return
            }
            ref.updateData(["friends": FieldValue.arrayRemove([self.user.id])])
            self.passedPosts.posts.removeAll(where: { $0.userID == self.user.id })
            print("friend deleted")
            let data = snap?.data()
            let friends = data!["friends"] as? [String]
            UserDefaults.standard.set(friends, forKey: "friends")
            //print("friends after butten press: ", UserDefaults.standard.string(forKey: "friends")?.description)
            //UserDefaults.standard.synchronize()
            self.currentUserFriends = friends!
            self.buttonImage =  Image(systemName: "person.crop.circle.badge.plus")
            self.buttonText = "Follow"
            self.isFriend = false
        }
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



struct MoreMenu: View {
    
    @Binding var show: Bool
    @State var showAlert = false
    @Binding var user: User
    
    
    var body: some View {
        
        HStack{
            
            
            Button(action: {
                self.showAlert.toggle()
            }){
                Text("Block user").foregroundColor(.red)
            }
            .alert(isPresented: $showAlert){
                
                Alert(title: Text("Block user"), message: Text("Continue blocking user?"), primaryButton: .cancel(Text("Cancel"), action: {
                    withAnimation(.spring()){
                        self.showAlert.toggle()
                    }}),
                      secondaryButton: .destructive(Text("Block"), action: {
                        
                        let uid = Auth.auth().currentUser?.uid
                        let db = Firestore.firestore()
                        
                        let ref = db.collection("users").document(uid!)
                        ref.getDocument{ (snap, error) in
                            
                            if(error != nil)
                            {
                                print((error?.localizedDescription)!)
                                return
                            }
                            
                            
                            //check if from search and if user is equal to current user
                            ref.updateData(["blocked": FieldValue.arrayUnion([self.user.id])])
                            
                            
                            let ref2 = db.collection("users").document(self.user.id)
                            ref2.getDocument{ (snap, error) in
                                
                                ref2.updateData(["friends": FieldValue.arrayRemove([uid!])])
                                
                            }
                            //remove posts from blocked user posts array
                            //remove user from blocked user messages
                            //remove favorite posts from blocked user favorites
                            //
                            
                        }
                        
                        withAnimation(.spring()){
                            self.showAlert.toggle()
                        }
                      }))
                
            }
            
            
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
