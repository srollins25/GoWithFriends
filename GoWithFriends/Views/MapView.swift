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
    @State var pins: [MapPin] = [
         MapPin(coordinate: CLLocationCoordinate2D(latitude: 37.13,
         longitude: -117.07),
         title: "Pin",
         subtitle: "Big Smoke",
         action: { print("Hey mate!") } )
    ]
    @State var selectedPin: MapPin?
    @EnvironmentObject var pokomenObserver: PokemonObserver
    @State var plotPokemon = true
    
    var body: some View {
        
        ZStack(alignment: .topTrailing){
            
            MapView2(manager: $manager, pins: $pins, selectedPin: $selectedPin).edgesIgnoringSafeArea(.all)
            
            Button(action: {
                self.showAddToMapView.toggle()
            }){
                Image(systemName: "plus.circle").resizable().frame(width: 25, height: 25).padding(.all, 20)
            }.sheet(isPresented: self.$showAddToMapView){
                AddToMapView(showAddToMapView: self.$showAddToMapView)
            }
        }
            
        .onAppear(perform: {
            
            if(self.plotPokemon)
            {
                var i = 0
                
                while (i < self.pokomenObserver.pokemon.count) {
                    print("index: ", i)
                    self.pins.append(MapPin(
                        coordinate: CLLocationCoordinate2D(latitude: self.pokomenObserver.pokemon[i].lat!, longitude: self.pokomenObserver.pokemon[i].lon!),
                        title: self.pokomenObserver.pokemon[i].name,
                        subtitle: "cp: \((self.pokomenObserver.pokemon[i].cp)!.stringValue)",
                        action: { print(self.pokomenObserver.pokemon[i].name!) }))
                    
                    i = i + 1
                }
                i = 0
                self.plotPokemon = false
            }
            
        })
    }
}

struct MapView2: UIViewRepresentable, View {
    
    @Binding var manager: CLLocationManager
    @Binding var pins: [MapPin]
    @Binding var selectedPin: MapPin?
    @EnvironmentObject var pokomenObserver: PokemonObserver
    @State var plotPokemon = true
    
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
        updateAnnotations(from: view)
        view.showsUserLocation = true
        
        if let selectedPin = selectedPin {
            view.selectAnnotation(selectedPin, animated: false)
        }
    }
    
    private func updateAnnotations(from view: MKMapView)
    {
        view.removeAnnotations(pins)
        let newAnnotations = self.pins.map{ $0 }
        view.addAnnotations(newAnnotations)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, selectedPin: $selectedPin)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        @Binding var selectedPin: MapPin?
        var parent: MapView2
        
        init(_ parent: MapView2, selectedPin: Binding<MapPin?>){
            self.parent = parent
            _selectedPin = selectedPin
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            print(mapView.centerCoordinate)
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let pin = view.annotation as? MapPin else{
                return
            }
            
            pin.action?()
            selectedPin = pin
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            guard (view.annotation as? MapPin) != nil else {
                return
            }
            selectedPin = nil
        }
    }
}

class MapPin: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let action: (() -> Void)?
    
    init(coordinate: CLLocationCoordinate2D,
         title: String? = nil,
         subtitle: String? = nil,
         action: (() -> Void)? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
    
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView2()
//    }
//}























