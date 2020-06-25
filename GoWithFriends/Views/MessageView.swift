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
    
    @ObservedObject var friendObserver = FriendsObserver() //datas
    @State var show = false //newchatview
    @State var chat = false //chatview
    @State var uid = ""
    @State var image = ""
    @State var shouldFetch = false
    @EnvironmentObject var showTabBar: ShowTabBar
    let transition = AnyTransition.move(edge: .trailing)
    
    
    var body: some View {
        
        
        
        NavigationView{
            
            ZStack{
                VStack{
                    List{
                        
                        if(friendObserver.friends.isEmpty)
                        {
                            Text("No messages").fontWeight(.heavy)
                        }
                            
                        else
                        {
                            
                            ForEach(friendObserver.friends){ i in
                                
                                Button(action: {
                                    
                                    self.uid = i.id
                                    self.name = i.name
                                    self.image = i.image
                                    self.chat.toggle()
                                    
                                    
                                    withAnimation(.easeInOut(duration: 0.5)){
                                   
                                        self.showTabBar.showTabBar = false
                                    }
                                    
                                }){
                                    MessageCell(id: i.id, name: i.name, image: i.image, message: i.text, createdAt: i.createdAt)
                                }
                            }
                        }
                    }
                    
                }
                
                if(self.chat == true)
                {
                    ChatView(pic: self.image, name: self.name, uid: self.uid, chat: self.$chat).environmentObject(showTabBar).transition(transition)
                }
                
            }
            .navigationBarTitle(Text("Messages"))
            .navigationBarItems(trailing: Button(action: {
                self.show = true
                print("new message")
            }){
                Image(systemName: "square.and.pencil").resizable().frame(width: 25, height: 25).shadow(color: .gray, radius: 5, x: 1, y: 1)
            }.accentColor(.white)
                .sheet(isPresented: self.$show){
                    NewMessageView(name: self.$name, uid: self.$uid, pic: self.$image, show: self.$show, chat: self.$chat)
            })
        }
            
        .onAppear(perform: {
            
            
            
        })
        
    }
}























