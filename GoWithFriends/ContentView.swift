//
//  ContentView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/8/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var session: SessionStore
    
    func getUser()
    {
        session.listen()
    }
    
    var body: some View {
        
        Group{
            if(session.session != nil)
            {
                TabView{
                    HomeView().tabItem({
                        Image(systemName: "globe")
                        Text("Home")
                    })
                    
                    MapView().tabItem({
                        Image(systemName: "map")
                        Text("Map")
                    })
                    
                    MessageView().tabItem({
                        Image(systemName: "bubble.left.and.bubble.right")
                        Text("Inbox")
                    })
                    
                    ProfileView().tabItem({
                        Image(systemName: "person")
                        Text("Profile")
                    })
                }
                
            }
            else
            {
                LoginView()
            }
        }.onAppear(perform: getUser)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SessionStore())
    }
}
