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
    
    var body: some View {
        
        NavigationView{
            
            VStack(spacing: 10){
                
                Text("For questions, bug reports, or feature suggestions head to Twitter @0mn1Stack or send an email to omnistack49@gmail.com")
                
                Button(action: {
                    self.closeView.toggle()
                }){
                    Text("Done")
                    
                }
                 Spacer()
            }
           
        }
    }
}

//struct SupportView_Previews: PreviewProvider {
//    static var previews: some View {
//        SupportView()
//    }
//}
