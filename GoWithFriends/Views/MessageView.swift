//
//  MessageView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/9/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import SDWebImageSwiftUI

struct MessageView: View {
    
    @State var name = ""
    
    @ObservedObject var friendObserver = MessagesObserver() //datas
    @State var show = false //newchatview
    @State var chat = false //chatview
    @State var uid = ""
    @State var image = ""
    @State var shouldFetch = false
    
    var body: some View {
        
        VStack{
            List{
                
                if(friendObserver.friends.isEmpty)
                {
                    Text("No messages").fontWeight(.heavy)
                }
                    
                else
                {
                    ForEach(friendObserver.friends){ i in
                        
                        ZStack{
                            
                            MessageCell(id: i.id, name: i.name, image: i.image, message: i.text, createdAt: i.createdAt)
                            
                            
                            NavigationLink(destination: ChatView(pic: self.image, name: self.name, uid: self.uid, chat: self.$chat)){
                                EmptyView()
                            }.frame(width: 0)
                            
                            
                            Button(action: {
                                self.uid = i.id
                                self.name = i.name
                                self.image = i.image
                                self.chat.toggle()
                            }){
                                Text("")
                            }
                            
                        }
                        
                    }.onDelete(perform: delete)

                }
                
                
            }.padding(.bottom, 140)
            
        }
            
        .onAppear(perform: {
            
            
        })
    }
    
    func delete(at offsets: IndexSet){
        
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        var userId = ""
        
        for index in offsets {
            userId = friendObserver.friends[index].id
            
            db.collection("users").document(uid!).collection("messages").document(userId).delete() { error in
                
                if let error = error{

                    print(error.localizedDescription)
                    return
                }
            }
            
            db.collection("messages").document(uid!).collection(userId).getDocuments { snap,error  in
                
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                
                for document in snap!.documents {
                    
                    db.collection("messages").document(uid!).collection(userId).document(document.documentID).delete(){ err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        }
                    }
                    
                }
                
            }
        }
    }
}



class ShowChatView: ObservableObject {
    @Published var showChatView = false
}



















