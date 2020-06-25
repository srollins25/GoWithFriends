//
//  BlankView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 6/24/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI

struct BlankView: View {
    
    @Binding var text: String
    
    var body: some View {
        
        Text(self.text).font(.system(size: 20)).font(.largeTitle)
    }
}
//
//struct BlankView_Previews: PreviewProvider {
//    static var previews: some View {
//        BlankView()
//    }
//}
