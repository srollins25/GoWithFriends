//
//  UserCell.swift
//  GoWithFriends
//
//  Created by stephan rollins on 5/4/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI

struct UserCell: View {
    
    let id: String
    let name: String
    let image: String
    
    var body: some View {
        
        VStack{
            HStack(alignment: .center, spacing: 15){

                AnimatedImage(url: URL(string: image)).resizable().frame(width: 48, height: 48).clipShape(Circle())
                VStack(alignment: .leading){
                    Text(name).bold()
                }

            }
        }   
    }
}
