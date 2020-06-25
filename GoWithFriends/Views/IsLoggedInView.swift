//
//  IsLoggedInView.swift
//  
//
//  Created by stephan rollins on 6/1/20.
//

import SwiftUI

struct IsLoggedInView: View {
    @State var user = PokeUser(id: "", name: "", profileimage: "", email: "", user_posts: [String](), createdAt: 0)
    @State var post: Post = Post(id: "", userID: "", name: "", image: "", profileimage: "", postBody: "", comments: [String]() as NSArray, favorites: 0, createdAt: 0, parentPost: "")
    @State var index = 0
    @State var show = true
    @State var fromSearch = false
    @Binding var isLoggedIn: Bool
    @State var showCreatePost = false
    @State var parentPost = ""
    var pokemon = PokemonObserver()
    var raids = RaidObserver()
    var posts = PostObserver()
    @EnvironmentObject var showTabBar: ShowTabBar
    
    var body: some View{
        
        Group{
            
            
                
                if(index == 0)
                {
                    HomeView(isLoggedIn: self.$isLoggedIn).environmentObject(posts)
                }
                    
                else if(index == 1)
                {
                    MapView().environmentObject(pokemon).environmentObject(raids)
                }
                    
                else if(index == 2)
                {
                    MessageView().environmentObject(showTabBar)
                }
                    
                else
                {
                    
                    ProfileView(user: self.$user,
                                show:  self.$show,
                                fromSearch: self.$fromSearch, isLoggedIn: self.$isLoggedIn).environmentObject(posts)
                }
                
                
            if(self.showTabBar.showTabBar == true)
            {
                TabBar(showCreatePost: self.$showCreatePost, index: self.$index, parentPost: self.$parentPost)//.edgesIgnoringSafeArea(.bottom)
            }
            
        }
        .onAppear(perform: {
            //self.getUser()
            
            if(UserDefaults.standard.string(forKey: "username") != nil || UserDefaults.standard.string(forKey: "username") != ""){
                self.createUser()
            }
        })
        
    }
    
    func createUser()
    {
        self.user.name = UserDefaults.standard.string(forKey: "username")!
        self.user.id = UserDefaults.standard.string(forKey: "userid")!
        self.user.profileimage = UserDefaults.standard.string(forKey: "image")!
        
    }
}

struct TabBar: View {
    
    @Binding var showCreatePost: Bool
    @Binding var index: Int
    @Binding var parentPost: String
    
    var body: some View{
        
        ZStack(alignment: .center){
            
            BottomBar(index: self.$index)
                .padding()
                .padding(.horizontal, 22)
            
            Button(action: {
                self.showCreatePost.toggle()
            }){
                Image(systemName: "plus.circle.fill").resizable().frame(width: 40, height: 40).padding(10).background(Color.white).clipShape(Circle())
            }.offset(y: -25)
                .sheet(isPresented: $showCreatePost) {
                    CreatePostView(closeView: self.$showCreatePost, parentPost: self.$parentPost)
            }
        }
    }
}

struct BottomBar: View {
    
    @Binding var index: Int
    
    var body: some View{
    
        ZStack{
            HStack{
                Button(action: {
                    self.index = 0
                }){
                    
                    VStack{
                        Image(systemName: "globe").resizable().frame(width: 25, height: 25)
                        Text("Home").fontWeight(.light).font(.system(size: 10))
                    }
                }
                .foregroundColor(Color.black.opacity(self.index == 0 ? 1 : 0.2))
                
                
                Spacer(minLength: 12)
                
                Button(action: {
                    self.index = 1
                }){
                    VStack{
                        Image(systemName: "map").resizable().frame(width: 25, height: 25)
                        Text("Map").fontWeight(.light).font(.system(size: 10))
                    }
                }
                .foregroundColor(Color.black.opacity(self.index == 1 ? 1 : 0.2))
                
                Spacer().frame(width: 120)
                
                
                Button(action: {
                    self.index = 2
                }){
                    
                    VStack{
                        Image(systemName: "bubble.left.and.bubble.right").resizable().frame(width: 30, height: 25)
                        Text("Inbox").fontWeight(.light).font(.system(size: 10))
                    }
                }
                .foregroundColor(Color.black.opacity(self.index == 2 ? 1 : 0.2))
                .offset(x: -10)
                
                Spacer(minLength: 12)
                
                Button(action: {
                    self.index = 3
                }){
                    
                    VStack{
                        Image(systemName: "person").resizable().frame(width: 25, height: 25)
                        Text("Profile").fontWeight(.light).font(.system(size: 10))
                    }
                }
                .foregroundColor(Color.black.opacity(self.index == 3 ? 1 : 0.2))
            }
            .background(Color.white)
        }
        .background(Color.white)
    }
}

//struct IsLoggedInView_Previews: PreviewProvider {
//    static var previews: some View {
//        IsLoggedInView()
//    }
//}
