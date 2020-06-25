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
    

    @EnvironmentObject var postsObserver: PostObserver
    @State var show = false
    @State var showPostThread = false
    @State var shouldFetch = false
    @State var showSearchBar = false
    @State var searchtxt = ""
    @State var post: Post = Post(id: "", userID: "", name: "", image: "", profileimage: "", postBody: "", comments: [String]() as NSArray, favorites: 0, createdAt: 0, parentPost: "")
    @State var subParentPost = Post(id: "", userID: "", name: "", image: "", profileimage: "", postBody: "", comments: [String]() as NSArray, favorites: 0, createdAt: 0, parentPost: "")
    @Binding var isLoggedIn: Bool
    let transition = AnyTransition.move(edge: .trailing)
    
    
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
                                     
                                    Button(action: {
                                        
                                        self.post = post
                                        print("Post: ",  self.post.id, "Postbody: ",  self.post.postBody, "Comments: ",  self.post.comments.description)
                                        UserDefaults.standard.set(self.post.id, forKey: "parentPost")
                                        withAnimation(.easeIn(duration: 0.5)){
                                            self.showPostThread.toggle()
                                        }
                                    }){
                                        PostCell(id: post.id, user: post.userID, name: post.name, image: post.image, profileimage: post.profileimage, postBody: post.postBody, comments: post.comments, favorites: post.favorites, createdAt: post.createdAt, parentPost: post.parentPost)
                                    }
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
                    
                }){
                    AnimatedImage(url: URL(string: UserDefaults.standard.string(forKey: "image")!)).resizable().renderingMode(.original).aspectRatio(contentMode: .fill).frame(width: 35, height: 35).shadow(color: .gray, radius: 5, x: 1, y: 1).clipShape(Circle())
                }.accentColor(.white)
                    
                    , trailing:

                        Button(action: {
                            
                            withAnimation(.easeInOut(duration: 0.5)){
                                self.showSearchBar.toggle()
                            }
                            
                        }){
                            Image(systemName: "magnifyingglass").resizable().frame(width: 30, height: 30).shadow(color: .gray, radius: 5, x: 1, y: 1)
                            
                        }.accentColor(.white)
                )
            }
            
            if(self.showPostThread == true)
            {
                PostThreadView(closeView: self.$showPostThread, mainPost: self.$post, subParentPost: self.$subParentPost).padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)!).transition(transition).edgesIgnoringSafeArea(.all)
                
            }
            
            ZStack{
                SearchView(closeView: self.$showSearchBar)

            }
            .edgesIgnoringSafeArea(.all)
            .offset(x: self.showSearchBar ? 0 : UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.frame.width ?? 0, y: 0)

        }
            
        .onAppear(perform: {
            
            
            
            if(self.shouldFetch == false){
                
                self.shouldFetch = true
            }
        })
    }
}


struct SideMenu: View {
    

    @Binding var isLoggedIn: Bool
    @State var showSupport = false
    
    var body: some View {
        
        VStack(spacing: 25){
            
            Button(action: {
                self.showSupport.toggle()
            }){
                VStack(spacing: 8){
                    Image(systemName: "questionmark.circle").renderingMode(.original).resizable().frame(width: 25, height: 25)
                    Text("Support")
                }
            }.sheet(isPresented: self.$showSupport){
                SupportView(closeView: self.$showSupport)
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
                UserDefaults.standard.set(emptyArr, forKey: "friends")
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
















