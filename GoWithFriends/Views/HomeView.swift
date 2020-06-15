//
//  HomeView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/8/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import SDWebImageSwiftUI


struct HomeView: View {
    
    @EnvironmentObject var session: SessionStore
    @ObservedObject var postsObserver = PostObserver()
    @State var show = false
    @State var shouldFetch = false
    @State var showSearchBar = false
    @State var searchtxt = ""//TextBindingManager(limit: 30)
    @Binding var isLoggedIn: Bool
    
    
    var body: some View {
        
        
        ZStack{
            NavigationView{
                
                ZStack(alignment: .bottomTrailing){
                    
                    VStack{
                        List{
                            if(postsObserver.posts.isEmpty)
                            {
                                Text("No posts").fontWeight(.heavy)
                            }
                                
                            else
                            {
                                ForEach(postsObserver.posts.reversed()){ post in
                                    PostCell(id: post.id, user: post.userID, name: post.name, image: post.image, profileimage: post.profileimage, postBody: post.postBody, comments: post.comments, favorites: post.favorites, createdAt: post.createdAt, parentPost: post.parentPost) //.onTapGesture {
                                        //print("post tap")
                                    //}
                                }
                            }
                        }
                    }
                    
                    
                    GeometryReader{_ in
                        
                        HStack{
                            SideMenu(isLoggedIn: self.$isLoggedIn).offset(x: self.show ? 0 : -UIScreen.main.bounds.width)
                                .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6))
                            Spacer()
                        }
                    }.background(Color.black.opacity(self.show ? 0.5 : 0)).edgesIgnoringSafeArea(.bottom)
                }
                .navigationBarTitle(Text("Home"))
                .navigationBarItems(leading: Button(action: {
                    self.show.toggle()
                    print("side menue")
                }){
                    Image(systemName: "person.circle").resizable().frame(width: 30, height: 30).shadow(color: .gray, radius: 5, x: 1, y: 1)
                }.accentColor(.white)
                    
                    , trailing:

                        Button(action: {
                            
                            withAnimation(.easeIn(duration: 0.5)){
                                self.showSearchBar.toggle()
                            }
                            
                        }){
                            Image(systemName: "magnifyingglass").resizable().frame(width: 30, height: 30).shadow(color: .gray, radius: 5, x: 1, y: 1)
                            
                        }.accentColor(.white)
                )
            }
            
            //Text("hello world")
            
            ZStack{
                SearchView(closeView: self.$showSearchBar)

            }
            .edgesIgnoringSafeArea(.all)
            .offset(x: self.showSearchBar ? 0 : UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.frame.width ?? 0, y: 0)
        }
            
        .onAppear(perform: {
            print("testing home")
            
            
            if(self.shouldFetch == false){
                print("testing home1: false - inside if")
                self.shouldFetch = true
            }
        })
    }
}


struct SideMenu: View {
    
    @EnvironmentObject var session: SessionStore
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        
        VStack(spacing: 25){
            
            Button(action: {
                
            }){
                VStack(spacing: 8){
                    Image(systemName: "questionmark.circle").renderingMode(.original).resizable().frame(width: 25, height: 25)
                    Text("Support")
                }
            }
            
            Button(action: {
                
            }){
                VStack(spacing: 8){
                    Image(systemName: "gear").renderingMode(.original).resizable().frame(width: 25, height: 25)
                    Text("Settings")
                }
            }
            
            Button(action: {
                
                do{

                    try Auth.auth().signOut()
                }
                catch{
                    print("Problem signing out.")
                }
                
                UserDefaults.standard.set("", forKey: "username")
                UserDefaults.standard.set("", forKey: "image")
                UserDefaults.standard.set("", forKey: "userid")
                let emptyArr = [String]()
                UserDefaults.standard.set(emptyArr, forKey: "favorites")
                self.isLoggedIn.toggle()
                UserDefaults.standard.set(self.isLoggedIn, forKey: "isloggedin")
                
            }){
                VStack(spacing: 8){
                    Image(systemName: "escape").renderingMode(.original).resizable().frame(width: 25, height: 25)
                    Text("Log out").foregroundColor(.red)
                }
            }
            
            Spacer(minLength: 15)
            Spacer()
            
        }.padding(12)
            .foregroundColor(.black)
            .background(Color("sidemenucolor"))
            .cornerRadius(16)
        
    }
}



//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}


//new post
//
//                    let uid = Auth.auth().currentUser?.uid
//                    let db = Firestore.firestore()
//                    let ref = Firestore.firestore().document("users/\(uid!)")
//                    ref.getDocument{ (snapshot, error) in
//                        guard let snapshot = snapshot, snapshot.exists else { return }
//                        let data = snapshot.data()
//                        let name = (data!["name"] as? String)!
//                        let profileimage = UserDefaults.standard.string(forKey: "image")!
//                        let createdAt = Date().timeIntervalSince1970 as NSNumber
//                        print("name: ", name)
//
//                        let values = ["userId": uid! ,"name": name, "image": "", "profileimage": profileimage , "body": "testing", "": "0", "favorites": "0", "createdAt": createdAt] as [String : Any]
//                        let collection = db.collection("posts")
//                        let doc = collection.document()
//                        let id = doc.documentID
//                        doc.setData(values)
//                        let userRef = db.collection("users/").document("\(uid!)")
//                        userRef.updateData([ "user_posts": FieldValue.arrayUnion([id]) ])


















