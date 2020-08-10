//
//  ContentView.swift
//  Sparks
//
//  Created by stephan rollins on 8/9/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var index = 0
    
    var body: some View {
       
        
        VStack{
            
            if(self.index == 0)
            {
                Color.purple.edgesIgnoringSafeArea(.top)
            }
            else if(self.index == 1)
            {
                Color.blue.edgesIgnoringSafeArea(.top)
            }
            
            else if(self.index == 2)
            {
                Color.orange.edgesIgnoringSafeArea(.top)
            }
            
            TabBar(index: self.$index)
            
        }
        
    }
}


struct TabBar: View {
    
    @Binding var index: Int
    
    var body: some View{
        
        HStack{
            
            HStack{
                
                Image(systemName: "house.fill").resizable().frame(width: 30, height: 30)
                Text(self.index == 0 ? "Home" : "")
            }
        .padding(15)
            .background(self.index == 0 ? Color.purple.opacity(0.5) : Color.clear)
        .clipShape(Capsule())
            .onTapGesture {
                self.index = 0
            }
            
            HStack{
                    
                    Image(systemName: "globe").resizable().frame(width: 30, height: 30)
                    Text(self.index == 1 ? "Map" : "")
                }
            .padding(15)
                .background(self.index == 1 ? Color.blue.opacity(0.5) : Color.clear)
            .clipShape(Capsule())
                .onTapGesture {
                    self.index = 1
                }
            
            HStack{
                    
                    Image(systemName: "bubble.middle.bottom.fill").resizable().frame(width: 30, height: 30)
                    Text(self.index == 2 ? "Messages" : "")
                }
            .padding(15)
                .background(self.index == 2 ? Color.orange.opacity(0.5) : Color.clear)
            .clipShape(Capsule())
                .onTapGesture {
                    self.index = 2
                }
            
        }.frame(width: UIScreen.main.bounds.width)
            .background(Color.white)
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




































