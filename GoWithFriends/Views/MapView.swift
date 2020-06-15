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
    
    var body: some View {
        
        MapView2(manager: $manager).edgesIgnoringSafeArea(.all)
    }
}

struct MapView2: UIViewRepresentable {
    
    @Binding var manager: CLLocationManager
    
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























