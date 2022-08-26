//
//  SupportView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 6/25/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI

struct SupportView: View {
    
    @Binding var closeView: Bool
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        
        NavigationView{
            
            VStack(spacing: 10){
                Text("Support").font(.largeTitle).foregroundColor(self.scheme == .dark ? Color.white : Color.black)
                Text("For questions, bug reports, or feature suggestions head to Twitter @0mn1Stack or send an email to omnistack49@gmail.com").foregroundColor(self.scheme == .dark ? Color.white : Color.black).multilineTextAlignment(.center)
                
                 Spacer()
            }.padding()
                .navigationBarItems(leading: Button(action: {
                    self.closeView.toggle()
                }){
                    Text("Done")
                })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

//struct SupportView_Previews: PreviewProvider {
//    static var previews: some View {
//        SupportView()
//    }
//}
