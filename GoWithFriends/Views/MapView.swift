//
//  MapView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/8/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import MapKit
import GoogleMobileAds

struct MapView: View {
    
    @State private var manager = CLLocationManager()
    @State var showAddToMapView = false
    @State var pins: [MapPin] = []
    @State var selectedPin: MapPin?
    @EnvironmentObject var pokemonObserver: PokemonObserver
    @EnvironmentObject var raidObserver: RaidObserver
    @State var plotPokemon = true
    @State var pokemon: [MapPkm] = []
    
    var body: some View {
        
        ZStack{
            
            ZStack(alignment: .topTrailing){
                
                MapView2(manager: $manager, pins: $pins, selectedPin: $selectedPin, pokemon: $pokemon).edgesIgnoringSafeArea(.all)
                
                VStack{
                    
                    Button(action: {

                        
                        withAnimation(.easeInOut(duration: 0.5)){
                            self.showAddToMapView.toggle()
                        }
                    }){
                        Image(systemName: "plus.circle").resizable().frame(width: 25, height: 25).padding(.top, 55).padding(.trailing, 20)
                    }.disabled(CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse ? false : true)
//                    .sheet(isPresented: self.$showAddToMapView){
//                        AddToMapView(showAddToMapView: self.$showAddToMapView).edgesIgnoringSafeArea(.top)
//                    }
                }
            }
                
            if(self.showAddToMapView == true)
            {
                AddToMapView(showAddToMapView: self.$showAddToMapView).offset(x: 0, y: self.showAddToMapView ? 0 : UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.frame.height ?? 0)
            }
            
        }
        
        
        .onAppear(perform: {
            self.getPokemon()
            if(self.plotPokemon)
            {
                var i = 0
                
                while (i < self.pokemonObserver.pokemon.count) {

                    self.pins.append(MapPin(
                        coordinate: CLLocationCoordinate2D(latitude: self.pokemonObserver.pokemon[i].lat!, longitude: self.pokemonObserver.pokemon[i].lon!),
                        title: self.pokemonObserver.pokemon[i].name,
                        subtitle: "cp: \((self.pokemonObserver.pokemon[i].cp)!.stringValue)",
                        action: {  }))
                    
                    i = i + 1
                }
                i = 0
                
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
                
                while (i < self.raidObserver.raids.count) {

                    self.pins.append(MapPin(
                        coordinate: CLLocationCoordinate2D(latitude: self.raidObserver.raids[i].lat, longitude: self.raidObserver.raids[i].lon),
                        title: (self.raidObserver.raids[i].dexnum == "") ? "Raid\nStarts: \(formatter.string(from: NSDate(timeIntervalSince1970: TimeInterval(truncating: self.raidObserver.raids[i].timeTillStart)) as Date ))" : "Raid: " + self.raidObserver.raids[i].name,
                        subtitle: (self.raidObserver.raids[i].dexnum == "") ? "Difficulty: " + self.raidObserver.raids[i].difficulty.stringValue : "CP: " + self.raidObserver.raids[i].cp.stringValue + "\nEnds: \(formatter.string(from: NSDate(timeIntervalSince1970: TimeInterval(truncating: self.raidObserver.raids[i].timeToRemove)) as Date ))",
                        action: {  }))
                    
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
    @EnvironmentObject var pokemonObserver: PokemonObserver
    @EnvironmentObject var raidObserver: RaidObserver
    @State var plotPokemon = true
    @Binding var pokemon: [MapPkm]
    
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
            mapView.userTrackingMode = .follow
        }
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context)
    {
        updateAnnotations(from: view)
        if let selectedPin = selectedPin {
            view.selectAnnotation(selectedPin, animated: false)
        }
        
        view.showsUserLocation = true
        view.removeAnnotations(pins)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        var i = 0
        self.pins.removeAll()
        while (i < self.raidObserver.raids.count) {

            self.pins.append(MapPin(
                coordinate: CLLocationCoordinate2D(latitude: self.raidObserver.raids[i].lat, longitude: self.raidObserver.raids[i].lon),
                title: (self.raidObserver.raids[i].dexnum == "") ? "Raid\nStarts: \(formatter.string(from: NSDate(timeIntervalSince1970: TimeInterval(truncating: self.raidObserver.raids[i].timeTillStart)) as Date ))" : "Raid: " +  self.raidObserver.raids[i].name,
                subtitle: (self.raidObserver.raids[i].dexnum == "") ? "Difficulty: " + self.raidObserver.raids[i].difficulty.stringValue : "CP: " + self.raidObserver.raids[i].cp.stringValue + "\nEnds: \(formatter.string(from: NSDate(timeIntervalSince1970: TimeInterval(truncating: self.raidObserver.raids[i].timeToRemove)) as Date ))",
                action: { }))
            
            i = i + 1
        }
        i = 0
        
        while (i < self.pokemonObserver.pokemon.count) {

            self.pins.append(MapPin(
                coordinate: CLLocationCoordinate2D(latitude: self.pokemonObserver.pokemon[i].lat!, longitude: self.pokemonObserver.pokemon[i].lon!),
                title: "Raid: " + self.pokemonObserver.pokemon[i].name!,
                subtitle: "cp: \((self.pokemonObserver.pokemon[i].cp)!.stringValue)",
                action: {  }))
            
            i = i + 1
        }
        i = 0
        view.delegate = context.coordinator
        view.addAnnotations(pins)
        
        
        
    }
    
    private func updateAnnotations(from view: MKMapView)
    {

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

        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let pin = view.annotation as? MapPin else{
                return
            }
            
            pin.action?()
            selectedPin = pin
            mapView.removeOverlays(mapView.overlays)
            let manager = CLLocationManager()
            let sourceCoords = manager.location?.coordinate
            //let destinationCoords = selectedPin?.coordinate
            
            let sourcePlacemarck = MKPlacemark(coordinate: sourceCoords!)
            let destPlackmark = MKPlacemark(coordinate: pin.coordinate)
            
            let sourceItem = MKMapItem(placemark: sourcePlacemarck)
            let destItem = MKMapItem(placemark: destPlackmark)
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = sourceItem
            directionRequest.destination = destItem
            directionRequest.transportType = .walking
            
            let directions = MKDirections(request: directionRequest)
            directions.calculate(completionHandler: {
                response, error in
                
                guard let response = response else {
                    if let error = error{
                        print("Error: ", error)
                    }
                    return
                }
                
                let route = response.routes[0]
                mapView.addOverlay(route.polyline, level: .aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            })
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.init(red: 55/255, green: 161/255, blue: 255/255, alpha: 1)
            renderer.lineWidth = 5.0
            
            return renderer
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
//            guard (view.annotation as? MapPin) != nil else {
//                return
//            }
//            selectedPin = nil
            
            mapView.removeOverlays(mapView.overlays)
        }
        
//        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customView")
//
//                   if(annotation is MKUserLocation){
//                       print("test: 1")
//                       return nil
//                   }
//
//                   else if(annotation.title != "Raid" && !(annotation.subtitle?.debugDescription.contains("Starts"))!)
//                   {
//                    print("test: 3")
//                    //annotation.title
//                    //var name = ""
//                    let index = self.parent.pokemon.firstIndex{ $0.name == annotation.title }
//                    annotationView.image = UIImage(named: self.parent.pokemon[index!].dexnum)
//                   }
//
//                   return annotationView
//        }
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























