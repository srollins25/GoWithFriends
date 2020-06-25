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
import FirebaseAuth
import FirebaseFirestore

struct ChatView: View{
    
    @State var pic: String
    @State var name: String
    @State var uid: String
    @Binding var chat: Bool
    @State var messages = [ChatMessage]()
    @State var messageTextFeild = ""
    @EnvironmentObject var showTabBar: ShowTabBar
    let obj = observed()
    @State var value: CGFloat = 0
    
    var body: some View{
        
        ZStack{
            Color("background").edgesIgnoringSafeArea(.all)
            
            
     
                VStack(spacing: 0){

                    chatTopView(pic: pic, name: name, showChatView: self.$chat).padding(.bottom, 5)

                    GeometryReader{_ in

                        ChatList(messages: self.$messages, offset: self.$value)
                    }
                    
                    chatBottomView(messageTextFeild: self.$messageTextFeild, name: self.$name, pic: self.$pic, uid: self.$uid).environmentObject(obj).offset(y: -self.value).animation(.spring())
                }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .onAppear(perform: {
            UITableView.appearance().separatorColor = .clear
            self.getMessages()
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main){ (notification) in
                let value = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                let height = value.height
                
                self.value = height
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main){ (notification) in

                
                self.value = 0
            }
        })
        .onAppear(perform: {
            self.showTabBar.showTabBar = false
        })
            .onDisappear(perform: {
                withAnimation(.easeInOut(duration: 0.5)){

                    self.showTabBar.showTabBar = true
                }
            })
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


struct chatTopView: View {
    
    var pic: String
    var name: String
    @Binding var showChatView: Bool
    
    var body: some View{
        HStack{
            
            Button(action: {
                UIApplication.shared.endEditing()
                withAnimation(.easeIn(duration: 0.5)){
                    self.showChatView.toggle()
                }
                
            }){
                Image(systemName: "control").resizable().renderingMode(.original).aspectRatio(contentMode: .fill).frame(width: 15, height: 15).font(.title).rotationEffect(.init(degrees: -90)).foregroundColor(.gray)
                
            }
            
            Spacer()
            VStack(spacing: 5){
                AnimatedImage(url: URL(string: pic)).resizable().frame(width:45, height: 45).clipShape(Circle())
                Text(name).font(.system(size: 20)).bold().fontWeight(.heavy)
            }
            
            Spacer()
        }.foregroundColor(.white).padding(.horizontal, 10)
    }
}

struct ChatList: View {
    
    @Binding var messages: [ChatMessage]
    @Binding var offset: CGFloat
    
    var body: some View{
        
        List{
            if(messages.isEmpty){
                Text("No messages")
            }
            else{
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
        }.padding(.horizontal, 15).padding(.bottom, self.offset == 0 ? 0 : self.offset + 10)
            .background(Color.white)
            .clipShape(Rounded())
    }
}

struct chatBottomView: View{

    @Binding var messageTextFeild: String
    @Binding var name: String
    @Binding var pic: String
    @Binding var uid: String
    //@Binding var height: CGFloat
    @EnvironmentObject var obj: observed

    var body: some View{

        HStack{
            Button(action: {

            }){
                Image(systemName: "camera.fill").resizable().aspectRatio(contentMode: .fill).frame(width: 25, height: 25).padding(10).foregroundColor(Color.gray)
            }
            
            MultiTextField(messageTextFeild: self.$messageTextFeild).frame(height: self.obj.size < 150 ? self.obj.size + 30 : 150).padding(10)
                .background(Color.gray)
                .cornerRadius(10)
            
            //TextField("Type message...", text: self.$messageTextFeild).lineLimit(5)

            Button(action: {
                let createdAt = Date().timeIntervalSince1970 as NSNumber

                //create message and send to database

                sendMessage(user: self.name, uid: self.uid, pic: self.pic, createdAt: createdAt, message: self.messageTextFeild)

                self.messageTextFeild = ""
            }){
                Image(systemName: "arrow.up.circle").resizable().frame(width: 30, height: 30).padding(10).foregroundColor(self.messageTextFeild == "" ? Color.gray : Color.green)
            }.disabled(self.messageTextFeild == "" ? true : false)
        }.padding().background(Color(UIColor.systemBackground)).edgesIgnoringSafeArea(.top)
    }
}

struct Rounded : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .topLeft, cornerRadii: CGSize(width: 55, height: 55))
        return Path(path.cgPath)
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

struct MultiTextField: UIViewRepresentable {
    
    @Binding var messageTextFeild: String
    
    func makeCoordinator() -> Coordinator {
        return MultiTextField.Coordinator(parent1: self)
    }
    
    @EnvironmentObject var obj: observed
    
    func makeUIView(context: UIViewRepresentableContext<MultiTextField>) ->  UITextView {
        
        let view = UITextView()
        view.font = .systemFont(ofSize: 19)
        view.text = "Type message..."
        view.textColor =  UIColor.black.withAlphaComponent(0.35)
        view.backgroundColor = UIColor.clear
        view.delegate = context.coordinator
        self.obj.size = view.contentSize.height
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = true
        
        return view
    }
    
    func updateUIView(_ uiView: MultiTextField.UIViewType, context: UIViewRepresentableContext<MultiTextField>) {
        
    }
    
    class Coordinator: NSObject,  UITextViewDelegate {
        var parent: MultiTextField
        
        init(parent1: MultiTextField) {
            parent = parent1
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.text = ""
            textView.textColor = .black
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.obj.size = textView.contentSize.height
            self.parent.messageTextFeild = textView.text
        }
    }
    
}

class observed: ObservableObject{
    @Published var size: CGFloat = 0
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





















