//
//  MessageView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/9/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct MessageView: View {
    
    @State var name = ""
    @ObservedObject var messagesObserver = MessagesObserver()
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                List{
                    
                    NavigationLink(destination: ChatView(name: $name)){
                    
                    if(messagesObserver.messages.isEmpty)
                    {
                        Text("No messages").fontWeight(.heavy)
                    }

                    else
                    {
                        ForEach(messagesObserver.messages){ i in
                            MessageCell(id: i.id, name: i.name, image: i.image, message: i.message)
                        }
                    }
               
                    
                }
            }
        }
        .navigationBarTitle(Text("Messages"))
        .navigationBarItems(trailing: Button(action: {
                //self.showingSettings.toggle()
                print("new message")
            }){
                Image(systemName: "square.and.pencil").resizable().frame(width: 25, height: 25).shadow(color: .gray, radius: 5, x: 1, y: 1)
            }.accentColor(.white)
            /*.sheet(isPresented: $showingSettings){
                Settings()
                }*/)
        }
        
    }
}

struct ChatView: View{
    @Binding var name: String
    
    var body: some View{
        Text("hello world")
    }
}

class MessagesObserver: ObservableObject{
    @Published var messages = [Message]()
    
    init()
    {
        let db = Firestore.firestore()
        
        db.collection("messages").addSnapshotListener{ (snap, error) in
            
            if error != nil{
                print(error?.localizedDescription as Any)
                return
            }
            
            for i in snap!.documentChanges{
                if i.type == .added{
                    let name = i.document.get("name") as! String
                    let message = i.document.get("message") as! String
                    let image = i.document.get("image") as! String
                    let id = i.document.documentID
                    
                    self.messages.append(Message(id: id, image: image, name: name, message: message))
                }
            }
            
        }
    }
}

struct Message: Identifiable{
    var id: String
    var image: String
    var name: String
    var message: String
}

//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageView()
//    }
//}
