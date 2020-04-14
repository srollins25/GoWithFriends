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
    @State var alert = false
    
    var body: some View {
        
            MapView2(manager: $manager, alert: $alert).alert(isPresented: $alert){
                Alert(title: Text("Enable Location Services in settings."))
        }
    }
}

struct MapView2: UIViewRepresentable {
    
    @Binding var manager: CLLocationManager
    @Binding var alert: Bool
    let map = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        let center = CLLocationCoordinate2D(latitude: 32.7516, longitude: -117.0785)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.region = region
        mapView.showsUserLocation = true
        manager.requestWhenInUseAuthorization()
        manager.delegate = context.coordinator
        manager.startUpdatingLocation()
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView2>) {
        print("user location: ", uiView.userLocation.coordinate.latitude, uiView.userLocation.coordinate.latitude)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent1: self)
    }
    
    class Coordinator: NSObject, CLLocationManagerDelegate {
        
        var parent: MapView2
        
        init(parent1: MapView2){
            parent = parent1
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            
            if(status == .denied)
            {
                parent.alert.toggle()
            }
            
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location = locations.last
            let point = MKPointAnnotation()
            
            let georeader = CLGeocoder()
            georeader.reverseGeocodeLocation(location!){ (places, error) in
                
                if(error != nil){
                    print((error?.localizedDescription)!)
                    return
                }
                
                let place = places?.first?.locality
                point.title = place
                point.subtitle = "current"
                point.coordinate = location!.coordinate
                self.parent.map.removeAnnotations(self.parent.map.annotations)
                self.parent.map.addAnnotation(point)
                
                let region = MKCoordinateRegion(center: location!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                self.parent.map.region = region
                
            }
        }
    }
}


//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView2()
//    }
//}























