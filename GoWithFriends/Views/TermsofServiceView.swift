//
//  TermsofServiceView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 7/19/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import WebKit
import Foundation

struct TermsofServiceView: UIViewRepresentable {
    
    var url = "https://gowithfriends.weebly.com/terms-of-service.html"
    
    func makeUIView(context: Context) ->  WKWebView {
        guard let url = URL(string: self.url) else {
            return WKWebView()
        }
        let request = URLRequest(url: url)
        let wkWebView = WKWebView()
        wkWebView.load(request)
        return wkWebView
    }
    
    func updateUIView(_ uiView:  WKWebView, context: UIViewRepresentableContext<TermsofServiceView>) {
        
    }
    
}
















