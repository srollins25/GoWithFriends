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
                            ForEach(postsObserver.posts.reversed()){ i in
                                PostCell(id: i.id, name: i.name, image: i.image, postBody: i.postBody, comments: i.comments, favorites: i.favorites, createdAt: i.createdAt)
                            }
                        }
                    }
                }
                
                Button(action: {
                    //new post
                    
                    let uid = Auth.auth().currentUser?.uid
                    let db = Firestore.firestore()
                    let ref = Firestore.firestore().document("users/\(uid!)")
                    ref.getDocument{ (snapshot, error) in
                        guard let snapshot = snapshot, snapshot.exists else { return }
                        let data = snapshot.data()
                        let name = (data!["name"] as? String)!
                        let createdAt = Date().timeIntervalSince1970 as NSNumber
                        print("name: ", name)
                        
                        let values = ["userId": uid! ,"name": name, "image": "", "body": "testing", "comments": "0", "favorites": "0", "createdAt": createdAt] as [String : Any]
                        let collection = db.collection("posts")
                        let doc = collection.document()
                        let id = doc.documentID
                        doc.setData(values)
                        let userRef = db.collection("users/").document("\(uid!)")
                        userRef.updateData([ "user_posts": FieldValue.arrayUnion([id]) ])
                        
                    }
                }){
                    Image(systemName: "plus.bubble").padding(.all)
                }
                .padding()
                .background(Color.gray.opacity(0.75)).foregroundColor(.white).font(.title).frame(width:80, height: 80).clipShape(Circle()).padding(.trailing)
            }
            .navigationBarTitle(Text("Home"))
            .navigationBarItems(leading: Button(action: {
                // clear 
                self.session.signOut()
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



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
