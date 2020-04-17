//
//  MessageCell.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/14/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI

struct MessageCell: View {
    
    let id: String
    let name: String
    let image: String
    let message: String
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 15){
            Image(systemName: "person.circle")
            VStack(alignment: .leading){
                Text(name)
                Text(message)
            }
           
            Spacer()
            Text("time")
        }
        
        
    }
}

//struct MessageCell_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageCell()
//    }
//}
