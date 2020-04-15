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
    
    func getUser()
    {
        session.listen()
    }
    
    var body: some View {
        
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
                            ForEach(postsObserver.posts){ i in
                                PostCell(id: i.id, name: i.name, image: i.image, postBody: i.postBody, comments: i.comments, favorites: i.favorites)
                            }
                        }
                    }
                }

                Button(action: {
                    //new post
                }){
                    Image(systemName: "square.and.pencil").padding(.all)
                }
                .padding()
                .background(Color.gray.opacity(0.75)).foregroundColor(.white).font(.title).frame(width:60, height: 60).clipShape(Circle()).padding(.trailing)
            }
            .navigationBarTitle(Text("Home"))
            .navigationBarItems(leading: Button(action: { self.session.signOut()
                print("side menue")
            }){
                Image(systemName: "person.circle").resizable().frame(width: 25, height: 25).shadow(color: .gray, radius: 5, x: 1, y: 1)
            }.accentColor(.white)
            /*.sheet(isPresented: $showingSettings){
                Settings()
                }*/ , trailing: Button(action: {
                    //self.showingAddAccount.toggle()
                    print("search button")
                }){
                    Image(systemName: "magnifyingglass").resizable().frame(width: 25, height: 25).shadow(color: .gray, radius: 5, x: 1, y: 1)
                }.accentColor(.white))
        }
    }
}

class PostObserver: ObservableObject {
    
    @Published var posts = [dataType]()
    
    init() {
        let db = Firestore.firestore()
        db.collection("posts").addSnapshotListener { (snap, error) in
            
            if error != nil{
                print((error?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges {
                
                if(i.type == .added){
                    
                    let id = i.document.documentID
                    let name = i.document.get("name") as! String
                    let image = i.document.get("image") as! String
                    let comments = i.document.get("comments") as! String
                    let body = i.document.get("body") as! String
                    let favorites = i.document.get("favorites") as! String
                    
                    self.posts.append(dataType(id: id, name: name, image: image, postBody: body, comments: comments, favorites: favorites))
                }
                
                if(i.type == .removed){
                    
                    let id = i.document.documentID

                    for j in 0..<self.posts.count{
                        if (self.posts[j].id == id){
                            self.posts.remove(at: j)
                            return
                        }
                    }
                }
                
                if(i.type == .modified)
                {
                    let id = i.document.documentID
                    let favorites = i.document.get("favorites") as! String
                     let comments = i.document.get("comments") as! String
                    
                    for j in 0..<self.posts.count{
                        if (self.posts[j].id == id){
                            self.posts[j].favorites = favorites
                            self.posts[j].comments = comments
                            return
                        }
                    }
                }
                
            }
        
        }
    }
    
}

struct dataType: Identifiable{
    
    //create seperate file for posts
    
    var id: String
    var name: String
    var image: String
    var postBody: String
    var comments: String
    var favorites: String
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
