//
//  AddToMapView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 6/2/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI

struct AddToMapView: View {
    
    @State var selectedView: Int = 1
    
    var body: some View {
        
        
        VStack{
            
            Picker(selection: $selectedView, label: Text("")) {
                Text("Pokemon").tag(1)
                Text("Raid").tag(2)
            }.pickerStyle(SegmentedPickerStyle())
            
            
            
        }
        
        
    }
}

struct AddToMapView_Previews: PreviewProvider {
    static var previews: some View {
        AddToMapView()
    }
}
