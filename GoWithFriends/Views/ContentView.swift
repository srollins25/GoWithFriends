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
    
    var body: some View {
        
        LoginView(isloggedin: self.$isLoggedIn).overlay(self.isLoggedIn ? IsLoggedInView(isLoggedIn: self.$isLoggedIn).background(Color.white) : nil)
            
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







