//
//  PostCell.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/12/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI

struct PostCell: View {
    
    let id: String
    //let user: User
    let name: String
    let image: String
    let postBody: String
    let comments: String
    let favorites: String
    let createdAt: NSNumber
    
    var body: some View {
        VStack{
        HStack(alignment: .top){
            Image(systemName: "person.circle").resizable().frame(width: 32, height: 32).clipShape(Circle())
                VStack(alignment: .leading){
                    Text(name).font(.headline)
                    Text(postBody).fixedSize(horizontal: false, vertical: true).font(.body)
                    
                    if(image != "")
                    {
                        
                    AnimatedImage(name: image)

                    }
                            }
            
            Spacer()
            Button(action: {
                print("edit")
            }){
                Image(systemName: "ellipsis")
            }.buttonStyle(BorderlessButtonStyle())
        }.padding()
            
        HStack(/*alignment: .firstTextBaseline, */ spacing: 40 ){
            
            HStack{
                Button(action: {
                    print("reply")
                    let db = Firestore.firestore()
                    let comments = Int.init(self.comments)
                    db.collection("posts").document(self.id).updateData(["comments": "\(comments! + 1)"]) { (error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                    }
                    
                }){
                    Image(systemName: "bubble.right")
                }.buttonStyle(BorderlessButtonStyle())
                    Text(comments)
                }
            HStack{

            Button(action: {
                print("fav")
                let db = Firestore.firestore()
                let favorites = Int.init(self.favorites)
                db.collection("posts").document(self.id).updateData(["favorites": "\(favorites! + 1)"]) { (error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                }
            }){
                Image(systemName: "star")
            }.buttonStyle(BorderlessButtonStyle())
                Text(favorites)

                }
            Button(action: {
                    print("share")
                }){
                    Image(systemName: "paperplane")
                }.buttonStyle(BorderlessButtonStyle())
            
            Text("\(Date(timeIntervalSince1970: TimeInterval(truncating: createdAt)), formatter: RelativeDateTimeFormatter())").font(.footnote).padding()

            }//.padding()
           
        }
        
    }
}

//struct PostCell_Previews: PreviewProvider {
//    static var previews: some View {
//        PostCell()
//    }
//}

struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
