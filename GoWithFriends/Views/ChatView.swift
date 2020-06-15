//
//  ChatView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 5/4/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct ChatView: View{
    
    var pic: String
    var name: String
    var uid: String //sendto user id?
    @Binding var chat: Bool
    @State var messages = [ChatMessage]()//MessagesObserver()
    @State var messageTextFeild = ""
    
    var body: some View{
        
        
        //UITableView.appearance().separatorColor = .clear
        VStack{
            
            List{
                if(messages.isEmpty)
                {
                    Text("No messages")
                }
                else
                {
                    ForEach(messages) { i in
                        
                        HStack{
                            
                            if(i.user == Auth.auth().currentUser?.uid){
                                Spacer()
                                Text(i.text).padding().background(Color.blue).clipShape(ChatBubble(myMessage: true)).foregroundColor(.white)
                            }
                            else{
                                Text(i.text).padding().background(Color.gray).clipShape(ChatBubble(myMessage: false)).foregroundColor(.white)
                                Spacer()
                            }
                        }
                    }
                }
            }
            
            HStack{
                TextField("Type Message", text: self.$messageTextFeild).textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    let createdAt = Date().timeIntervalSince1970 as NSNumber
                    
                    //create message and send to database
                    
                    sendMessage(user: self.name, uid: self.uid, pic: self.pic, createdAt: createdAt, message: self.messageTextFeild)
                    
                    self.messageTextFeild = ""
                    print("")
                }){
                    Image(systemName: "arrow.up.circle").frame(width: 32, height: 32)
                }
            }
            
        }
        .onAppear(perform: {
            UITableView.appearance().separatorColor = .clear
            self.getMessages()
        })
            .navigationBarTitle(Text(self.name), displayMode: .inline)
    }
    
    
    func getMessages() {
        let db = Firestore.firestore()
        
        let uid = (Auth.auth().currentUser?.uid)!
        
        db.collection("messages").document(uid).collection(self.uid).order(by: "createdAt", descending: true).addSnapshotListener{ (snap, error) in
            
            if(error != nil){
                print((error?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges{
                
                if i.type == .added{
                    let id = i.document.documentID
                    let message = i.document.get("message") as! String
                    let user = i.document.get("user") as! String
                    let createdAt = i.document.get("createdAt") as! NSNumber
                    
                    self.messages.append(ChatMessage(id: id, text: message, user: user, createdAt: createdAt))
                    self.messages.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
                }
                
            }
        }
    }
}

struct ChatMessage: Identifiable {
    var id: String
    var text: String
    var user: String
    var createdAt: NSNumber
}



struct ChatBubble: Shape {
    
    var myMessage: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, myMessage ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 16, height: 16))
        
        return Path(path.cgPath)
    }
    
}

func sendMessage(user: String, uid: String, pic: String, createdAt: NSNumber, message: String) {
    let db = Firestore.firestore()
    
    let currentUser = Auth.auth().currentUser?.uid
    
    db.collection("users").document(uid).collection("messages").document(currentUser!).getDocument{ (snap, error) in
        
        if(error != nil){
            print((error?.localizedDescription)!)
            return
        }
        
        if(!(snap!.exists))
        {
            setRecents(user: user, uid: uid, pic: pic, createdAt: createdAt, message: message)
        }
            
        else
        {
            updateRecents(uid: uid, lastmessage: message, createdAt: createdAt)
        }
        
    }
    
    updateDB(uid: uid, message: message, createdAt: createdAt)
}

func updateDB(uid: String, message: String, createdAt: NSNumber)
{
    let db = Firestore.firestore()
    
    let myuid = Auth.auth().currentUser?.uid
    
    db.collection("messages").document(uid).collection(myuid!).document().setData(["user": myuid!, "message": message,  "createdAt": createdAt]) { (error) in
        
        if error != nil{
            print((error?.localizedDescription)!)
            return
        }
        
    }
    
    db.collection("messages").document(myuid!).collection(uid).document().setData(["user": myuid!, "message": message,  "createdAt": createdAt]) { (error) in
        
        if error != nil{
            print((error?.localizedDescription)!)
            return
        }
    }
}

func setRecents(user: String, uid: String, pic: String, createdAt: NSNumber, message: String)
{
    let db = Firestore.firestore()
    let myuid = Auth.auth().currentUser?.uid
    let myname = UserDefaults.standard.string(forKey: "username")
    let mypic = UserDefaults.standard.string(forKey: "image")
    
    db.collection("users").document(uid).collection("messages").document(myuid!).setData(["name": /* user */ myname!, "image": /* pic */ mypic!, "message": message, "createdAt": createdAt]) { (error) in
        
        if error != nil{
            print((error?.localizedDescription)!)
            return
        }
        
        db.collection("users").document(myuid!).collection("messages").document(uid).setData(["name": user, "image": pic, "message": message, "createdAt": createdAt]) { (error) in
            
            if error != nil{
                print((error?.localizedDescription)!)
                return
            }
        }
        
    }
}

func updateRecents(uid: String, lastmessage: String, createdAt: NSNumber)
{
    let db = Firestore.firestore()
    
    let myuid = Auth.auth().currentUser?.uid
    
    db.collection("users").document(uid).collection("messages").document(myuid!).updateData(["message": lastmessage,  "createdAt": createdAt])
    
    db.collection("users").document(myuid!).collection("messages").document(uid).updateData(["message": lastmessage,  "createdAt": createdAt])
}

























