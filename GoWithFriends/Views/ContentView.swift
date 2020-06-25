//
//  ContentView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/8/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @State var isLoggedIn: Bool = false
    var showTabBar = ShowTabBar()
    
    var body: some View {
        
        LoginView(isloggedin: self.$isLoggedIn).overlay(self.isLoggedIn ? IsLoggedInView(isLoggedIn: self.$isLoggedIn).background(Color.white).environmentObject(showTabBar).edgesIgnoringSafeArea(.bottom) : nil)
            
            .onAppear(perform: {
                
                if(UserDefaults.standard.object(forKey: "isloggedin") != nil)
                {
                    self.isLoggedIn = UserDefaults.standard.bool(forKey: "isloggedin")
                }
            })
    }
}

class ShowTabBar: ObservableObject {
    @Published var showTabBar = true
}

struct CurvedShape: View {
    
    var body: some View{
        
        Path{ path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 0))
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 65))
            //path.addLine(to: CGPoint(x: rect.width, y: 35))
            
            path.addArc(center: CGPoint(x: UIScreen.main.bounds.width / 2, y: 65), radius: 30, startAngle: .zero, endAngle: .init(degrees: 180), clockwise: true)
            
            path.addLine(to: CGPoint(x: 0, y: 65))
            
        }.fill(Color.white)
            .rotationEffect(.init(degrees: 180))
    }
}



struct BottomBar: View {
    
    @Binding var index: Int
    
    var body: some View{
        
        
        ZStack{
            
            HStack{
                
                Button(action: {
                    self.index = 0
                }){
                    
                    VStack{
                        Image(systemName: "globe").resizable().frame(width: 25, height: 25)
                        Text("Home").fontWeight(.light).font(.system(size: 10))
                    }
                }
                .foregroundColor(Color.black.opacity(self.index == 0 ? 1 : 0.2))
                
                
                Spacer(minLength: 12)
                
                Button(action: {
                    self.index = 1
                }){
                    VStack{
                        Image(systemName: "map").resizable().frame(width: 25, height: 25)
                        Text("Map").fontWeight(.light).font(.system(size: 10))
                    }
                }
                .foregroundColor(Color.black.opacity(self.index == 1 ? 1 : 0.2))
                
                Spacer().frame(width: 120)
                
                
                Button(action: {
                    self.index = 2
                }){
                    
                    VStack{
                        Image(systemName: "bubble.left.and.bubble.right").resizable().frame(width: 30, height: 25)
                        Text("Inbox").fontWeight(.light).font(.system(size: 10))
                    }
                }
                .foregroundColor(Color.black.opacity(self.index == 2 ? 1 : 0.2))
                .offset(x: -10)
                
                Spacer(minLength: 12)
                
                Button(action: {
                    self.index = 3
                }){
                    
                    VStack{
                        Image(systemName: "person").resizable().frame(width: 25, height: 25)
                        Text("Profile").fontWeight(.light).font(.system(size: 10))
                    }
                }
                .foregroundColor(Color.black.opacity(self.index == 3 ? 1 : 0.2))
            }
            .background(Color.white)
        }
        .background(Color.white)
    }
}



