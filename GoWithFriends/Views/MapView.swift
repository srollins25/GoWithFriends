//
//  MapView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/8/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @State private var manager = CLLocationManager()
    @State var showAddToMapView = false
    
    var body: some View {
         
        
        ZStack(alignment: .topTrailing){
            
            MapView2(manager: $manager).edgesIgnoringSafeArea(.all)
            
            
            Button(action: {
                self.showAddToMapView.toggle()
            }){
                Image(systemName: "plus.circle").resizable().frame(width: 25, height: 25).padding(.all, 20)
            }.sheet(isPresented: self.$showAddToMapView){
                AddToMapView(showAddToMapView: self.$showAddToMapView)
            }
        }
        
        
    }
}

struct MapView2: UIViewRepresentable, View {
    
    @Binding var manager: CLLocationManager
    @ObservedObject var pokomenObserver = PokemonObserver()
    
    func makeUIView(context: Context) -> MKMapView {
        let locationManager = CLLocationManager()
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        manager.requestWhenInUseAuthorization()
        mapView.delegate = context.coordinator
        
        if(CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse){
            let location: CLLocationCoordinate2D = locationManager.location!.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context)
    {
        
        view.showsUserLocation = true
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: MapView2
        
        init(_ parent: MapView2){
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            print(mapView.centerCoordinate)
        }
    }
}


//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView2()
//    }
//}























