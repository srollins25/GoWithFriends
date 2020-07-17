//
//  LoaderView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 7/11/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI

struct LoaderView: View {
    
    @State var animate = false
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        
        VStack{
            Text("Loading").foregroundColor(Color.black).padding()
            
            Circle().trim(from: 0, to: 0.8).stroke(AngularGradient(gradient: .init(colors: [.yellow, .red, .blue]), center: .center), style: StrokeStyle(lineWidth: 8, lineCap: .round)).frame(width: 45, height: 45).rotationEffect(.init(degrees: self.animate ? 360 : 0)).animation(Animation.linear(duration: 0.9).repeatForever(autoreverses: false))
        }.padding(20)
            .background(Color.white)
            .cornerRadius(15)
            .onAppear{
            self.animate.toggle()
        }
        

    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}
