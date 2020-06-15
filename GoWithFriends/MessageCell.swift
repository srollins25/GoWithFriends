//
//  MessageCell.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/14/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI

struct MessageCell: View {
    
    let id: String
    let name: String
    let image: String
    let message: String
    let createdAt: NSNumber
    
    var body: some View {
        
        VStack{
            HStack(alignment: .center, spacing: 15){
                //Image(systemName: "person.circle").resizable().frame(width: 30, height: 30).clipShape(Circle())
                AnimatedImage(url: URL(string: image)).resizable().frame(width: 30, height: 30).clipShape(Circle())
                VStack(alignment: .leading){
                    Text(name)
                    Text(message)
                }
                
                Spacer()
                Text("\(Date(timeIntervalSince1970: TimeInterval(truncating: createdAt)), formatter: RelativeDateTimeFormatter())")
                //                        Text("\(Date(timeIntervalSince1970: TimeInterval(truncating: createdAt)), formatter: RelativeDateTimeFormatter())").font(.footnote).padding()
            }
        }
        
        
        
        
    }
}

//struct MessageCell_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageCell()
//    }
//}
