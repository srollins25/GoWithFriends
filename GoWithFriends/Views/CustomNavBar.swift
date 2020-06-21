//
//  CustomNavBar.swift
//  GoWithFriends
//
//  Created by stephan rollins on 6/15/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import Foundation
import SwiftUI

struct CustomNavBar: View {
    
    @Binding var closeView: Bool
    
    var body: some View{
        
        ZStack{
            
            CustomNavBarBack()
            
            VStack(spacing: 0){
                HStack(alignment: .top, spacing: 8){
                    Button(action: {
                        UserDefaults.standard.set("", forKey: "friendId")
                        withAnimation(.easeInOut(duration: 0.7)){
                            self.closeView.toggle()
                        }
                    }){
                        Text("Back").foregroundColor(Color.black.opacity(0.5)).padding(9)
                    }
                    .background(Color.white)
                    .shadow(color: .gray, radius: 7, x: 1, y: 1)
                    .clipShape(Capsule())
                    Spacer()
                }
                .padding(.top , (UIApplication.shared.windows.first?.safeAreaInsets.top)! )
                .padding(.horizontal)
                .padding(.bottom, 5)
                    
                .background(Color.black.opacity(0.3))
                
                //Spacer()
            }
        }
    }
    
    struct CustomNavBarBack: View {
        
        
        var body: some View{
            
            VStack(spacing: 0){
                HStack(alignment: .top,spacing: 8){
                    
                    Text("")
                    Spacer()
                }
                .padding(.top , (UIApplication.shared.windows.first?.safeAreaInsets.top)! )
                .padding(.horizontal)
                .padding(.bottom, 5)
                    
                .background(Color.white)
                
                //Spacer()
            }
        }
    }
}
