//
//  SearchView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 5/27/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct SearchView: View {
    
    @ObservedObject var postSearchObserver = PostObserver()
    @ObservedObject var userSearchObserver = SearchUserObserver()
    @State var user: User = User(id: "", email: "", name: "", profileimage: "")
    @State var post: Post = Post(id: "", userID: "", name: "", image: "", profileimage: "", postBody: "", comments: [String]() as NSArray, favorites: 0, createdAt: 0, parentPost: "")
    @State var show = false
    @State var txt = ""
    @Binding var closeView: Bool
    @State var fromSearch = true
    @State var searchIndex = 0
    let transition = AnyTransition.move(edge: .trailing)
    
    var body: some View {
        ZStack(){
            
            Group{
                VStack{
                    
                    if(self.searchIndex == 0)
                    {
                        List(postSearchObserver.posts.filter{$0.postBody.lowercased().contains(self.txt.lowercased())}){ post in
                            
                            Button(action: {
                                self.post = post
                                
                                withAnimation(.easeIn(duration: 0.5)){
                                    print(self.show)
                                    UserDefaults.standard.set(self.post.id, forKey: "parentPost")
                                    self.show.toggle()
                                }
                                
                            }){
                                PostCell(id: post.id, user: post.userID, name: post.name, image: post.image, profileimage: post.profileimage, postBody: post.postBody, comments: post.comments, favorites: post.favorites, createdAt:  post.createdAt, parentPost: post.parentPost)
                            }
                        }
                    }
                    else
                    {
                        List(userSearchObserver.users.filter{$0.name.lowercased().contains(self.txt.lowercased())}){ user in
                            
                            Button(action: {
                                self.user = user
                                
                                withAnimation(.easeIn(duration: 0.5)){
                                    print(self.show)
                                    self.show.toggle()
                                }
                                
                            }){
                                UserCell(id: user.id, name: user.name, image: user.profileimage)
                            }
                        }
                    }
                }.offset(y: 0)
            }
            
            CustomSearchBar(closeView: self.$closeView, txt: self.$txt, searchIndex: self.$searchIndex)
            
            if(self.show == true)
            {
                if(searchIndex == 1)
                {
                    ProfileView(user: self.$user, show: self.$show, fromSearch: self.$fromSearch).padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)!).transition(transition)
                }
                else
                {
                    PostThreadView(closeView: self.$show, mainPost: self.$post).padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)!).transition(transition)
                }
            }
        }.offset(x: self.closeView ? 0 : UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.frame.width ?? 0, y: 0)
    }
}

struct CustomSearchBar: View {
    
    @Binding var closeView: Bool
    @Binding var txt: String
    @Binding var searchIndex: Int
    
    var body: some View{
        
        VStack(spacing: 0){
            

            VStack{
                HStack(spacing: 8){
                    Button(action: {
                        
                        withAnimation(.easeOut(duration: 0.5)){
                            self.txt = ""
                            self.closeView.toggle()
                        }
                    }){
                        Text("Cancel").foregroundColor(Color.black.opacity(0.5)).padding(9)
                    }
                    .background(Color.white)
                    .shadow(color: .gray, radius: 7, x: 1, y: 1)
                    .clipShape(Capsule())
                    
                    Spacer(minLength: 0)
                    
                    HStack(spacing: 0){
                        TextField("Search", text: self.$txt).padding(9)
                            .background(Color.white)
                            .shadow(color: .gray, radius: 7, x: 1, y: 1)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Button(action: {
                            self.txt = ""
                        }){
                            Image(systemName: "xmark").foregroundColor(Color.black.opacity(0.3))
                                .padding()
                        }.background(Color.white)
                            .shadow(color: .gray, radius: 7, x: 1, y: 1)
                            .clipShape(Circle())
                    }
                }
                
                Picker(selection: $searchIndex, label: Text("")) {
                    Text("Posts").tag(0)
                    Text("Accounts").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
            }
                
            .padding(.top , (UIApplication.shared.windows.first?.safeAreaInsets.top)! )
            .padding(.horizontal)
            .padding(.bottom, 5)
                
            .background(Color.black.opacity(0.3))
            
            Spacer()
        }
    }
}



//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
//}























