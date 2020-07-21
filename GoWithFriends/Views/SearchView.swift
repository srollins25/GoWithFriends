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
    
    @ObservedObject var postSearchObserver = SearchPostsObserver()
    @ObservedObject var userSearchObserver = SearchUserObserver()
    @State var user: PokeUser = PokeUser(id: "", name: "", profileimage: "", email: "", user_posts: [String](), createdAt: 0, trainerId: "")
    @State var post: Post = Post(id: "", userID: "", name: "", trainerId: "", image: "", profileimage: "", postBody: "", comments: [String]() as NSArray, favorites: 0, createdAt: 0, parentPost: "", isReported: false)
    @State var show = false
    @State var txt = ""
    @State var fromSearch = true
    @State var searchIndex = 0
    let transition = AnyTransition.move(edge: .trailing)
    @State var subParentPost = Post(id: "", userID: "", name: "", trainerId: "", image: "", profileimage: "", postBody: "", comments: [String]() as NSArray, favorites: 0, createdAt: 0, parentPost: "", isReported: false)
    @State var isLoggedIn = true
    //var qm = QueryModel()
    @Environment(\.colorScheme) var scheme 
    @State var favpic = Image(systemName: "star")
    @State var favSubPic = Image(systemName: "star")
    @State var isFavorite = false
    @State var isSubFavorite = false
    @State var comments = CommentsObserver(parentPost_: "")
    @Binding var showDeleteView: Bool//
    
    
    var body: some View {
        
        ZStack(){
            
            Group{
                VStack{
                    VStack{
                        
                        Picker(selection: $searchIndex, label: Text("")) {
                            Text("Posts").tag(0)
                            Text("Accounts").tag(1)
                        }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal, 4).padding(.bottom, 2)
                        
                        
                        TextField("Search", text: self.$txt).padding(.vertical, 12).padding(.horizontal).background(Color.black.opacity(0.06)).clipShape(Capsule())
                        
                    }.padding([.top, .leading, .trailing], 8)
                    .background(Color(UIColor.systemBackground))
                    
                    
                    if(self.searchIndex == 0)
                    {
                        List(postSearchObserver.posts.filter{$0.postBody.lowercased().contains(self.txt.lowercased())}){ post in
                            
                           ZStack{
                            
                            if(post.isReported == false)
                            {
                                PostCell(id: post.id, user: post.userID, name: post.name, trainerId: post.trainerId, image: post.image, profileimage: post.profileimage, postBody: post.postBody, comments: post.comments, favorites: post.favorites, createdAt:  post.createdAt, parentPost: post.parentPost, isFavorite: self.$isFavorite, showDeleteView: self.$showDeleteView)
                            }
                            else
                            {
                                ReportedPostCell(id: post.id, user: post.userID, name: post.name, trainerId: post.trainerId, image: post.image, profileimage: post.profileimage, comments: post.comments, favorites: post.favorites, createdAt: post.createdAt, parentPost: post.parentPost, isFavorite: self.$isFavorite, showDeleteView: self.$showDeleteView)
                            }
                            
                            NavigationLink(destination: PostThreadView(mainPost: self.$post, subParentPost: self.$subParentPost, showDeleteView: self.$showDeleteView).environmentObject(self.comments)){
                                    
                                    EmptyView()
                            }

                            Button(action: {
                                self.post = post
                                self.show.toggle()
                                self.isFavorite = (UserDefaults.standard.object(forKey: "favorites")! as? [String])!.contains(post.id)
                                if((UserDefaults.standard.object(forKey: "favorites")! as? [String])!.contains(post.id))
                                {
                                    self.favpic = Image(systemName: "star.fill")
                                }
                                UserDefaults.standard.set(self.post.id, forKey: "parentPost")
                                self.comments = CommentsObserver(parentPost_: UserDefaults.standard.string(forKey: "parentPost")!)
                                UIApplication.shared.endEditing()
                            }){
                                Text("")
                            }

                            }
                        }
                    }
                    else
                    {
                        List(userSearchObserver.users.filter{$0.name.lowercased().contains(self.txt.lowercased())}){ user in
                        
                            ZStack{
                             
                                UserCell(id: user.id, name: user.name, image: user.profileimage).edgesIgnoringSafeArea(.all)
                                
                                NavigationLink(destination: ProfileView(user: self.$user, show: self.$show, isLoggedIn: self.$isLoggedIn, showDeleteView: self.$showDeleteView).navigationBarTitle(user.name)){
                                     
                                     EmptyView()
                                 }.frame(width: 0)

                             
                             Button(action: {
                                 self.user = user
                                 self.show.toggle()
                                 UIApplication.shared.endEditing()
                                 UserDefaults.standard.set(self.user.id, forKey: "friendId")
                             }){
                                 Text("")
                             }

                             }
                        }
                    }
                }.offset(y: 0).background(Color(UIColor.systemBackground))
            }
            
        }.navigationBarTitle(Text("Search"), displayMode: .inline)
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
                        UIApplication.shared.endEditing()
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

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
//}























