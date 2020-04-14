//
//  MessageView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/9/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI

struct MessageView: View {
    var body: some View {
        
        NavigationView{
            List{
                Text("hello")
                Text("hello")
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

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
