//
//  ReportPostView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 7/19/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI

struct ReportPostView: View {
    
    @Binding var postId: String
    @Binding var parentPost: String
    @Binding var showReportButton: Bool
    @Environment(\.colorScheme) var scheme 
    
    var body: some View {
        ZStack{
            Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)
            VStack{
                Text("Report an issue").foregroundColor(self.scheme == .dark ? Color.white : Color.black).font(.title).fontWeight(.bold).padding(.top, 10).padding(.bottom, 20)

                Text("Describe the problem with this post.").foregroundColor(self.scheme == .dark ? Color.white : Color.black)
            }
            
            Spacer()
        }
        
        
        .onDisappear(perform: {
            withAnimation(.spring()){
                self.showReportButton.toggle()
            }
        })
    }
}

//struct ReportPostView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportPostView()
//    }
//}
