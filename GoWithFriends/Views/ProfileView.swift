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
import FirebaseAuth

struct ProfileView: View {
    
    @EnvironmentObject var passedPosts: PostObserver
    @ObservedObject var currentUserPostsObserver = UserPostObserver()
    @ObservedObject var favoritePostsObserver = FavoritePostsObserver()
    @State var userPosts: [Post] = []
    @State var userFavorites: [Post] = []
    var currentUserFriends = FriendsObserver()
    @State var fetchPosts: Bool = true
    @State private var name: String = ""
    @State private var image: String = ""
    @State var profileArrIndex = 0
    @Binding var user: PokeUser
    @Binding var show: Bool
    @State var chat = false
    @Binding var isLoggedIn: Bool
    @State var showMoreMenu = false
    @State var showInbox = false
    @State var showProfileSettings = false
    @State var buttonImage: Image = Image(systemName: "person.circle")
    @State var buttonText = ""
    @State var isFriend = false
    @State var showDeleteVerify = false
    @State var showFriends: Bool = false
    @Environment(\.colorScheme) var scheme 
    @State var subParentPost = Post(id: "", userID: "", name: "", trainerId: "", image: "", profileimage: "", postBody: "", comments: [String]() as NSArray, favorites: 0, createdAt: 0, parentPost: "", isReported: false)
    @State var post: Post = Post(id: "", userID: "", name: "", trainerId: "", image: "", profileimage: "", postBody: "", comments: [String]() as NSArray, favorites: 0, createdAt: 0, parentPost: "", isReported: false)
    @State var favpic = Image(systemName: "star")
    @State var favSubPic = Image(systemName: "star")
    @State var isFavorite = false
    @State var isSubFavorite = false
    @State var showNewMessage = false
    @State var uid = (Auth.auth().currentUser?.uid)!
    @State var comments = CommentsObserver(parentPost_: "")
    @Binding var showDeleteView: Bool//final delete screen
    let friends = (UserDefaults.standard.array(forKey: "friends")! as? [String])!
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {

        ZStack{
            //Color.white.edgesIgnoringSafeArea(.all)
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
                        
                        if(self.user.id == UserDefaults.standard.string(forKey: "username")!)
                        {
                            Text("Trainer Code: " + UserDefaults.standard.string(forKey: "trainerId")!)
                        }
                        else
                        {
                            Text("Trainer Code: " + "\(user.trainerId)")
                        }
                        
                        if(user.id != Auth.auth().currentUser?.uid)
                        {
                            HStack{
                                
                                VStack{
                                    
                                        Button(action: {
                                            
                                            if(self.isFriend == true)
                                            {
                                                self.deleteFriend()

                                            }
                                            else
                                            {
                                                self.addFriend()

                                            }
                                        }){
                                            
                                            self.buttonImage.resizable().aspectRatio(contentMode: .fill).frame(width: 30, height: 30).foregroundColor(self.scheme == .dark ? Color.white : Color.gray)
                                            
                                            //check to see if in friends list
                                        }
                                        
                                    Text(self.buttonText).font(.footnote)
                                    
                                }
                                
                                VStack{
                                    
                                    NavigationLink(destination: ChatView(pic: self.user.profileimage, name: self.user.name, uid: self.user.id, chat: self.$chat)){
                                        Image(systemName: "envelope").resizable().aspectRatio(contentMode: .fill).frame(width: 30, height: 30).foregroundColor(self.scheme == .dark ? Color.white : Color.gray)
                                    }
                                    
                                    Text("Message").font(.footnote)
                                }
                                
                                VStack(spacing: 10){
                                    Button(action: {
                                        
                                        withAnimation(.easeIn(duration: 0.3)){
                                            self.showMoreMenu.toggle()
                                        }
                                    }){
                                        
                                        Image(systemName: "line.horizontal.3.decrease.circle").resizable().aspectRatio(contentMode: .fill).frame(width: 30, height: 30).foregroundColor(self.scheme == .dark ? Color.white : Color.gray)
                                        
                                    }
                                    Text("More").font(.footnote)
                                    
                                    if(self.showMoreMenu)
                                    {
                                        MoreMenu(show: self.$showMoreMenu, user: self.$user)
                                    }
                                }
                                
                            }.padding()
                        }
                        else
                        {
                            HStack{
                                
                                VStack{
                                    Button(action: {
                                        //present list of friends
                                        self.showFriends.toggle()
                                    }){
                                        
                                        Image(systemName: "person.2.fill").resizable().aspectRatio(contentMode: .fill).frame(width: 30, height: 30).foregroundColor(self.scheme == .dark ? Color.white : Color.gray)
                                    }.sheet(isPresented: self.$showFriends){
                                        FriendsView(closeView: self.$showFriends)
                                    }
                                    
                                    Text("Friends").font(.footnote)
                                }
                                
                                VStack{

                                    NavigationLink(destination: MessageView()
                                        .navigationBarTitle("Messages")
                                        .navigationBarItems(trailing: Button(action: {
                                            self.showNewMessage.toggle()
                                        }){
                                            Image(systemName: "square.and.pencil").resizable().frame(width: 25, height: 25).shadow(color: .gray, radius: 5, x: 1, y: 1)
                                        }.accentColor(.white)
                                            .sheet(isPresented: self.$showNewMessage){
                                                NewMessageView(name: self.$name, uid: self.$uid, pic: self.$image, show: self.$show, chat: self.$showNewMessage).environmentObject(self.currentUserFriends)
                                    }))
                                        {
                                            
                                    Image(systemName: "envelope").resizable().aspectRatio(contentMode: .fill).frame(width: 30, height: 30).foregroundColor(self.scheme == .dark ? Color.white : Color.gray)
//
                                    }
                                    Text("Inbox").font(.footnote)
                                }
                                
                                ZStack{
                                    
                                    VStack{
                                        Button(action: {
                                            //present profile change view
                                            self.showProfileSettings.toggle()
                                        }){
                                            
                                            Image(systemName: "line.horizontal.3.decrease.circle").resizable().aspectRatio(contentMode: .fill).frame(width: 30, height: 30).foregroundColor(self.scheme == .dark ? Color.white : Color.gray)
                                            
                                        }.sheet(isPresented: self.$showProfileSettings){
                                            ProfileSettingsView(closeView: self.$showProfileSettings, closeProfileView: self.$show, showDeleteVerify: self.$showDeleteVerify, showDeleteView: self.$showDeleteView)
                                        }
                                        Text("Settings").font(.footnote)
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
                    Picker(selection: $profileArrIndex, label: Text("")) {
                        Text("Posts").tag(0)
                        Text("Favorites").tag(1)
                    }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal, 5)
                    if(currentUserPostsObserver.currentuserposts.isEmpty)
                    {
                        Text("No posts").fontWeight(.heavy)
                        Spacer()
                    }
                        
                    else
                    {
                        
                        List{
                            if(profileArrIndex == 0)
                            {
                                if(self.user.id == UserDefaults.standard.string(forKey: "userid"))
                                {
                                    ForEach(self.currentUserPostsObserver.currentuserposts.reversed()) { post in
                                        
                                        ZStack{
                                            
                                            if(post.isReported == false)
                                            {
                                                PostCell(id: post.id, user: post.userID, name: post.name, trainerId: post.trainerId, image: post.image, profileimage: post.profileimage, postBody: post.postBody, comments: post.comments, favorites: post.favorites, createdAt:  post.createdAt, parentPost: post.parentPost, isFavorite: self.$isFavorite, showDeleteView: self.$showDeleteView)
                                            }
                                            else
                                            {
                                                ReportedPostCell(id: post.id, user: post.userID, name: post.name, trainerId: post.trainerId, image: post.image, profileimage: post.profileimage, comments: post.comments, favorites: post.favorites, createdAt: post.createdAt, parentPost: post.parentPost, isFavorite: self.$isFavorite, showDeleteView: self.$showDeleteView)
                                            }
                                            
                                            NavigationLink(destination: PostThreadView(mainPost: self.$post, subParentPost: self.$subParentPost, showDeleteView: self.$showDeleteView).navigationBarTitle("Thread").environmentObject(self.comments)){
                                                
                                                EmptyView()
                                            }
                                            
                                            Button(action: {
                                                self.post = post

                                                UIApplication.shared.endEditing()
                                                UserDefaults.standard.set(self.post.id, forKey: "parentPost")
                                                self.comments = CommentsObserver(parentPost_: UserDefaults.standard.string(forKey: "parentPost")!)
                                            }){
                                                Text("")
                                            }
                                            
                                        }
                                    }
                                }
                                else
                                {
                                    ForEach(self.userPosts.reversed()) { post in
                                        
                                        ZStack{
                                            
                                            if(post.isReported == false)
                                            {
                                                PostCell(id: post.id, user: post.userID, name: post.name, trainerId: post.trainerId, image: post.image, profileimage: post.profileimage, postBody: post.postBody, comments: post.comments, favorites: post.favorites, createdAt:  post.createdAt, parentPost: post.parentPost, isFavorite: self.$isFavorite, showDeleteView: self.$showDeleteView)
                                            }
                                            else
                                            {
                                                ReportedPostCell(id: post.id, user: post.userID, name: post.name, trainerId: post.trainerId, image: post.image, profileimage: post.profileimage, comments: post.comments, favorites: post.favorites, createdAt: post.createdAt, parentPost: post.parentPost, isFavorite: self.$isFavorite, showDeleteView: self.$showDeleteView)
                                            }
                                            
                                            NavigationLink(destination: PostThreadView(mainPost: self.$post, subParentPost: self.$subParentPost, showDeleteView: self.$showDeleteView).navigationBarTitle("Thread").environmentObject(self.comments)){
                                                
                                                EmptyView()
                                            }
                                            
                                            Button(action: {
                                                self.post = post

                                                UIApplication.shared.endEditing()
                                                UserDefaults.standard.set(self.post.id, forKey: "parentPost")
                                                self.comments = CommentsObserver(parentPost_: UserDefaults.standard.string(forKey: "parentPost")!)
                                            }){
                                                Text("")
                                            }
                                            
                                        }
                                        
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
                                            
                                            ZStack{
                                                
                                                if(post.isReported == false)
                                                {
                                                    PostCell(id: post.id, user: post.userID, name: post.name, trainerId: post.trainerId, image: post.image, profileimage: post.profileimage, postBody: post.postBody, comments: post.comments, favorites: post.favorites, createdAt:  post.createdAt, parentPost: post.parentPost, isFavorite: self.$isFavorite, showDeleteView: self.$showDeleteView)
                                                }
                                                else
                                                {
                                                    ReportedPostCell(id: post.id, user: post.userID, name: post.name, trainerId: post.trainerId, image: post.image, profileimage: post.profileimage, comments: post.comments, favorites: post.favorites, createdAt: post.createdAt, parentPost: post.parentPost, isFavorite: self.$isFavorite, showDeleteView: self.$showDeleteView)
                                                }
                                                
                                                NavigationLink(destination: PostThreadView(mainPost: self.$post, subParentPost: self.$subParentPost, showDeleteView: self.$showDeleteView).navigationBarTitle("Thread").environmentObject(self.comments)){
                                                    
                                                    EmptyView()
                                                }
                                                
                                                Button(action: {
                                                    self.post = post

                                                    UIApplication.shared.endEditing()
                                                    UserDefaults.standard.set(self.post.id, forKey: "parentPost")
                                                    self.comments = CommentsObserver(parentPost_: UserDefaults.standard.string(forKey: "parentPost")!)
                                                }){
                                                    Text("")
                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        ForEach(self.userFavorites){ post in
                                            
                                            ZStack{
                                                
                                                if(post.isReported == false)
                                                {
                                                    PostCell(id: post.id, user: post.userID, name: post.name, trainerId: post.trainerId, image: post.image, profileimage: post.profileimage, postBody: post.postBody, comments: post.comments, favorites: post.favorites, createdAt:  post.createdAt, parentPost: post.parentPost, isFavorite: self.$isFavorite, showDeleteView: self.$showDeleteView)
                                                }
                                                else
                                                {
                                                    ReportedPostCell(id: post.id, user: post.userID, name: post.name, trainerId: post.trainerId, image: post.image, profileimage: post.profileimage, comments: post.comments, favorites: post.favorites, createdAt: post.createdAt, parentPost: post.parentPost, isFavorite: self.$isFavorite, showDeleteView: self.$showDeleteView)
                                                }
                                                
                                                NavigationLink(destination: PostThreadView(mainPost: self.$post, subParentPost: self.$subParentPost, showDeleteView: self.$showDeleteView).navigationBarTitle("Thread").environmentObject(self.comments)){
                                                    
                                                    EmptyView()
                                                }
                                                
                                                Button(action: {
                                                    self.post = post
                                                    
                                                    UIApplication.shared.endEditing()
                                                    UserDefaults.standard.set(self.post.id, forKey: "parentPost")
                                                    self.comments = CommentsObserver(parentPost_: UserDefaults.standard.string(forKey: "parentPost")!)
                                                }){
                                                    Text("")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }.padding(.bottom, 120)
                    }
                }
            }
        }
            .background(Color(UIColor.systemBackground))
            .onAppear(perform: {
                if(self.user.id != UserDefaults.standard.string(forKey: "userid") && self.fetchPosts == true)
                {
                    
                    self.isFriend = self.friends.contains(self.user.id) ? true : false
                    
                    if(self.isFriend == true)
                    {
                        self.buttonText = "Unfollow"
                        self.buttonImage = Image(systemName: "person.crop.circle.badge.minus")
                    }
                    else
                    {
                        self.buttonText = "Follow"
                        self.buttonImage = Image(systemName: "person.crop.circle.badge.plus")
                    }
                    
                    
                    self.getUserPosts()
                    self.fetchPosts.toggle()
                }
            })

    }
    
    func checkIfFriend(){
        
        var i = 0
        
        while(i < self.currentUserFriends.friends.count){
           
            if(self.user.id == self.currentUserFriends.friends[i].id)
            {
                self.isFriend = true
                break
            }
            else
            {
                i = i + 1
            }
        }
    }
    
    func addFriend()
    {

        self.buttonText = "Unfollow"
        self.buttonImage = Image(systemName: "person.crop.circle.badge.minus")
        let db = Firestore.firestore()
        db.collection("users").document(self.uid).collection("friends").document(self.user.id).setData(["name": self.user.name, "image": self.user.profileimage, "id": self.user.id, "trainerId": self.user.trainerId])
        let ref = db.collection("users").document(UserDefaults.standard.string(forKey: "userid")!)
        ref.updateData(["friends": FieldValue.arrayUnion([self.user.id])])
        self.passedPosts.posts.append(contentsOf: self.userPosts)
        self.passedPosts.posts.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
        ref.getDocument{
            (snapshot, error) in
            
            if(error != nil){
                print((error?.localizedDescription)!)
                return
            }
            let data = snapshot?.data()
            let friends_ = data!["friends"] as? [String]
            UserDefaults.standard.set(friends_, forKey: "friends")
            
        }
        self.isFriend = true
    }
    
    func deleteFriend()
    {

        self.buttonText = "Follow"
        self.buttonImage = Image(systemName: "person.crop.circle.badge.plus")
        let db = Firestore.firestore()
        db.collection("users").document(self.uid).collection("friends").document(self.user.id).delete()
        let ref = db.collection("users").document(UserDefaults.standard.string(forKey: "userid")!)
        ref.updateData(["friends": FieldValue.arrayRemove([self.user.id])])
        ref.getDocument{
            (snapshot, error) in
            
            if(error != nil){
                print((error?.localizedDescription)!)
                return
            }
            let data = snapshot?.data()
            let friends_ = data!["friends"] as? [String]
            UserDefaults.standard.set(friends_, forKey: "friends")
            
        }
        self.passedPosts.posts.removeAll(where: { $0.userID == self.user.id })
        self.isFriend = false
        
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
                            let trainerId = i.document.get("trainerId") as! String
                            let userId = i.document.get("userId") as! String
                            let image = i.document.get("image") as! String
                            let profileimage = i.document.get("profileimage") as! String
                            let comments = i.document.get("comments") as! NSArray
                            let body = i.document.get("body") as! String
                            let favorites = i.document.get("favorites") as! NSNumber
                            let parentPost = i.document.get("parentPost") as! String
                            let createdAt = i.document.get("createdAt") as! NSNumber
                            let reported = i.document.get("isReported") as! Bool
                            
                            self.userPosts.append(Post(id: id, userID: userId, name: name, trainerId: trainerId, image: image, profileimage: profileimage, postBody: body, comments: comments, favorites: favorites, createdAt: createdAt, parentPost: parentPost, isReported: reported))
                            self.userPosts.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
                        }
                        
                        if(favorites.contains(i.document.documentID))
                        {
                            let id = i.document.documentID
                            let name = i.document.get("name") as! String
                            let userId = i.document.get("userId") as! String
                            let trainerId = i.document.get("trainerId") as! String
                            let image = i.document.get("image") as! String
                            let profileimage = i.document.get("profileimage") as! String
                            let comments = i.document.get("comments") as! NSArray
                            let body = i.document.get("body") as! String
                            let favorites = i.document.get("favorites") as! NSNumber
                            let parentPost = i.document.get("parentPost") as! String
                            let createdAt = i.document.get("createdAt") as! NSNumber
                            let reported = i.document.get("isReported") as! Bool
                            
                            self.userFavorites.append( Post(id: id, userID: userId, name: name, trainerId: trainerId, image: image, profileimage: profileimage, postBody: body, comments: comments, favorites: favorites, createdAt: createdAt, parentPost: parentPost, isReported: reported) )
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
                        let reported = i.document.get("isReported") as! Bool
                        
                        for j in 0..<self.userPosts.count{
                            if(self.userPosts[j].id == id){
                                self.userPosts[j].favorites = favorites_
                                self.userPosts[j].comments = comments
                                self.userPosts[j].isReported = reported
                                return
                            }
                        }
                        
                        if(favorites.contains(i.document.documentID))
                        {
                            for j in 0..<self.userPosts.count{
                                if(self.userFavorites[j].id == id){
                                    self.userFavorites[j].favorites = favorites_
                                    self.userFavorites[j].comments = comments
                                    self.userPosts[j].isReported = reported
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
    @State var showReport = false
    @Binding var user: PokeUser
    
    
    var body: some View {
        
        VStack{
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
            }.background(Color(UIColor.systemBackground))
            
            
            HStack{
                Button(action: {
                    self.showReport.toggle()
                }){
                    Text("Report user").foregroundColor(.red)
                }.sheet(isPresented: self.$showReport){
                    ReportUserView(userId: self.$user.id, showReportButton: self.$show)
                }
            }.background(Color(UIColor.systemBackground))
        }
        
        
        
    }
}
