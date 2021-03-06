//
//  IsLoggedInView.swift
//  
//
//  Created by stephan rollins on 6/1/20.
//

import SwiftUI

struct IsLoggedInView: View {
    @State var user = User(id: "", email: "", name: "", profileimage: "")
    @State var post: Post = Post(id: "", userID: "", name: "", image: "", profileimage: "", postBody: "", comments: [String]() as NSArray, favorites: 0, createdAt: 0, parentPost: "")
    @State var index = 0
    @State var show = true
    @State var fromSearch = false
    @Binding var isLoggedIn: Bool
    @State var showCreatePost = false
    @State var parentPost = ""
    
    
    var body: some View{
        
        Group{
            
            if(index == 0)
            {
                HomeView(isLoggedIn: self.$isLoggedIn)
            }
                
            else if(index == 1)
            {
                MapView()
            }
                
            else if(index == 2)
            {
                MessageView()
            }
                
            else
            {
                ProfileView(user: self.$user, show:  self.$show, fromSearch: self.$fromSearch)
                
            }
            Group{
                ZStack(alignment: .center){
                    //Spacer()
                    //
                    BottomBar(index: self.$index)
                        .padding()
                        .padding(.horizontal, 22)
                    //.background(CurvedShape())
                    
                    Button(action: {
                        self.showCreatePost.toggle()
                    }){
                        Image(systemName: "plus.circle.fill").resizable().frame(width: 40, height: 40).padding(10).background(Color.white).clipShape(Circle())
                    }.offset(y: -25)
                        .sheet(isPresented: $showCreatePost) {
                            CreatePostView(closeView: self.$showCreatePost, parentPost: self.$parentPost)
                    }
                    //.shadow(radius: 5)
                }
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

//struct IsLoggedInView_Previews: PreviewProvider {
//    static var previews: some View {
//        IsLoggedInView()
//    }
//}
