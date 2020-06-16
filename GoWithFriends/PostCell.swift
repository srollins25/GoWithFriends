//
//  PostCell.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/12/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import SDWebImageSwiftUI

struct PostCell: View {
    
    @State var id: String
    let user: String
    let name: String
    let image: String
    let profileimage: String
    let postBody: String
    let comments: NSArray
    let favorites: NSNumber
    let createdAt: NSNumber
    @State var parentPost: String
    @State var showDeleteButton = false
    @State var showAlert = false
    @State var show = false
    @State var showCreatePost = false
    
    var body: some View {
        
        HStack(alignment: .top){
            //image
            AnimatedImage(url: URL(string: self.profileimage)).resizable().renderingMode(.original).aspectRatio(contentMode: .fill).frame(width: 60, height: 60).clipShape(Circle())
            //(vastack: name, text, image)
            VStack(alignment: .leading){
                //name, text
                HStack(alignment: .top){
                    VStack(alignment: .leading){
                        
                        HStack{
                            
                            Text(self.name).font(.headline)
                            Spacer()
                            VStack(spacing: 10){
                                if(self.user == Auth.auth().currentUser?.uid)
                                {
                                    
                                    Image(systemName: "ellipsis").onTapGesture {
                                        
                                        withAnimation(.spring()){
                                            self.showDeleteButton.toggle()
                                            self.show.toggle()
                                            print("ellipsis tapp")
                                            print("   ")
                                        }
                                    }
                                    
                                    
                                    if(self.show == true)
                                    {
                                        
                                        PopOver( showAlert: self.$showAlert, show: self.$show, postId: self.$id, parentPost: self.$parentPost).cornerRadius(5).shadow(radius: 6)
                                    }
                                }
                            }
                        }
                        
                        
                        
                        Text(self.postBody).fixedSize(horizontal: false, vertical: true).font(.body)
                        if(self.image != "")
                        {
                            AnimatedImage(url: URL(string: self.image)).resizable().renderingMode(.original).frame(height: 140).cornerRadius(8).onTapGesture {
                                print("image tap")
                            }
                        }
                    }
                    
                }
                //thread, fav, send, date
                HStack(spacing: 20){
                    HStack{
                        Button(action: {
                            print("reply")
                            self.showCreatePost.toggle()
                            
                        }){
                            Image(systemName: "bubble.right")
                        }.buttonStyle(BorderlessButtonStyle())
                            .sheet(isPresented: self.$showCreatePost){
                                CreatePostView(closeView: self.$showCreatePost, parentPost: self.$id)
                        }
                        Text(self.comments.count == 0 ? "" : "\(self.comments.count)")
                    }
                    HStack{
                        
                        Button(action: {
                            print("fav")
                            
                            
                            let db = Firestore.firestore()
                            let favorites = self.favorites
                            var newArr = UserDefaults.standard.array(forKey: "favorites") as! [String]
                            if(!newArr.contains(self.id))
                            {
                                db.collection("posts").document(self.id).updateData(["favorites": favorites.doubleValue + 1]) { (error) in
                                    if error != nil {
                                        print(error!)
                                        return
                                    }
                                    
                                    let uid = Auth.auth().currentUser?.uid
                                    let ref = db.collection("users/").document("\(uid!)")
                                    ref.updateData(["favorites": FieldValue.arrayUnion([self.id])])
                                    
                                    newArr.append(self.id)
                                    UserDefaults.standard.set(newArr, forKey: "favorites")
                                }
                            }
                                
                            else
                            {
                                
                                db.collection("posts").document(self.id).updateData(["favorites": favorites.doubleValue - 1]) { (error) in
                                    if error != nil {
                                        print(error!)
                                        return
                                    }
                                    
                                    let uid = Auth.auth().currentUser?.uid
                                    let ref = db.collection("users/").document("\(uid!)")
                                    ref.updateData(["favorites": FieldValue.arrayRemove([self.id])])
                                    
                                    if let index = newArr.firstIndex(of: self.id){
                                        newArr.remove(at: index)
                                    }
                                    UserDefaults.standard.set(newArr, forKey: "favorites")
                                }
                            }
                        }){
                            Image(systemName: "star")
                        }.buttonStyle(BorderlessButtonStyle())
                        Text(self.favorites == 0 ? "" : "\(self.favorites)")
                        
                    }
                    Button(action: {
                        print("share")
                    }){
                        Image(systemName: "paperplane")
                    }.buttonStyle(BorderlessButtonStyle())
                    
                    Spacer()
                    
                    Text("\(Date(timeIntervalSince1970: TimeInterval(truncating: self.createdAt)), formatter: RelativeDateTimeFormatter())").font(.footnote)//.padding()
                    
                }.padding(.bottom, 2)
            }
            
        }.padding(.top)
    }
}



struct PopOver: View {
    
    @Binding var showAlert: Bool
    @Binding var show: Bool
    @Binding var postId: String
    @Binding var parentPost: String
    
    var body: some View{
        
        Text("Delete").foregroundColor(.red)
            .frame(width: 70, height: 30)
            .background(Color.white)
            .onTapGesture {
                
                self.showAlert.toggle()
        }.alert(isPresented: $showAlert){
            Alert(title: Text("Delete Post"), message: Text("Continue deleting this post?"), primaryButton: .cancel(Text("Cancel"), action: {
                withAnimation(.spring()){
                    self.show.toggle()
                }
                
                print("cancel")
            }), secondaryButton: .destructive(Text("Delete"), action: {
                withAnimation(.spring()){
                    self.show.toggle()
                }
                
                // when deleting a post remove from all users who have it as a favorite, remove it from the current users posts array, and change all posts that havee it as a parent post to empty string
                
                let db = Firestore.firestore()
                
                // delete from favorites
                db.collection("users").whereField("favorites", arrayContains: self.postId).getDocuments { (snap, error) in
                    
                    if(error != nil)
                    {
                        print((error?.localizedDescription)!)
                        return
                    }
                    
                    for document in snap!.documents {

                        let ref = db.collection("users").document("\(document.documentID)")
                        ref.updateData(["favorites": FieldValue.arrayRemove([self.postId])])
                    }
                }
                
                // delete from user_posts
                let uid = Auth.auth().currentUser?.uid
                var ref = db.collection("users").document(uid!)
                ref.getDocument { (snap, error) in
                    
                    if(error != nil)
                    {
                        print((error?.localizedDescription)!)
                        return
                    }
                    ref.updateData(["user_posts": FieldValue.arrayRemove([self.postId])])
                }
                
                // delete from comments
                db.collection("posts").whereField("comments", arrayContains: self.postId).getDocuments { (snap, error) in
                        
                        if(error != nil)
                        {
                            print((error?.localizedDescription)!)
                            return
                        }
                        
                        for document in snap!.documents {
                            
                            let ref = db.collection("posts").document("\(document.documentID)")
                            ref.updateData(["comments": FieldValue.arrayRemove([self.postId])])
                        }
                    }
                
                // change all posts that have as parent to empty string
                db.collection("posts").whereField("parentPost", isEqualTo: self.postId).getDocuments { (snap, error) in
                    if(error != nil)
                    {
                        print((error?.localizedDescription)!)
                        return
                    }
                    
                    for document in snap!.documents {
                        
                        let ref = db.collection("posts").document("\(document.documentID)")
                        ref.updateData(["parentPost": ""])
                    }
                }
                
                ref = db.collection("users").document(uid!)
                ref.getDocument { (snap, error) in
                    
                    if(error != nil)
                    {
                        print((error?.localizedDescription)!)
                        return
                    }
                    ref.updateData(["user_posts": FieldValue.arrayRemove([self.postId])])
                }

                // delete from posts
                db.collection("posts").document(self.postId).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
                print("deleting post")
            }))
        }
    }
}







