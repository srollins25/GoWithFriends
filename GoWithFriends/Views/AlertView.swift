//
//  AlertView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 6/12/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI

struct AlertView: View {
    
    @State var color = Color.black.opacity(0.7)
    @Binding var title: String
    @Binding var alert: Bool
    @Binding var error: String
    
    var body: some View {
        
        GeometryReader{_ in
            
            VStack{
                
                HStack{
                    
                    Text(self.title).font(.title).fontWeight(.bold).foregroundColor(self.color)
                    Spacer()
                    
                }
                .padding(.horizontal, 25)
                
                Text(self.error).foregroundColor(self.color)
                    .padding(.top)
                
                Button(action: {
                    
                }){
                    Text("Cancel").foregroundColor(.white).padding(.vertical).frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.top, 25)
                .padding(.horizontal, 25)
            }
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
        .cornerRadius(15)
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}

//struct AlertView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlertView()
//    }
//}





























