//
//  AddToMapView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 6/2/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import Firebase

struct AddToMapView: View {
    
    @Binding var showAddToMapView: Bool
    @State var selectedView: Int = 0
    
    var body: some View {
        
        
        ZStack{
            HStack{
                Spacer()
                VStack{
                    
                    HStack{
                        Button(action: {
                            self.showAddToMapView.toggle()
                        }){
                            Text("Cancel")
                        }
                        Spacer()
                    }
                    .padding(.top, (UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.safeAreaInsets.top)!)
                    VStack(spacing: 25){
                        Picker(selection: $selectedView, label: Text("")) {
                            Text("Pokemon").tag(0)
                            Text("Raid").tag(1)
                        }.pickerStyle(SegmentedPickerStyle())
                        
                        
                        if(self.selectedView == 0)
                        {
                            AddPokemonView(show: self.$showAddToMapView)
                        }
                        else
                        {
                            AddRaidView(show: self.$showAddToMapView)
                        }
                    }
                    .padding()
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct AddPokemonView: View {
    
    @State var pokename = ""
    @State var cp = "" //convert to nsnumber
    @State var timeSightedAt = "" //convert to nsnumber
    @Binding var show: Bool
    @State var showPokePicker = false
    @State var selectedPokemon = 0
    @State var showAlert = false
    
    @State var pokemon: [MapPkm] = []
//        [
//
//        "",
//        "charmander",
//        "pikachu",
//        "squirtle",
//        "bulbasoare"
//    ]
    
    var body: some View{
        
        VStack(spacing: 10){
            Image(systemName: "questionmark.circle").resizable().frame(width: 120, height: 120).foregroundColor(.gray).onTapGesture {
                self.showPokePicker.toggle()
            }.sheet(isPresented: self.$showPokePicker){
                
                NavigationView{
                    
                    Form{
                        Section{
                            Picker(selection: self.$selectedPokemon, label: Text("Select a pokemon")){
                                ForEach(0 ..< self.pokemon.count){
                                    
                                    Text(self.pokemon[$0].name).tag($0)
                                    
                                }
                            }.onReceive([self.selectedPokemon].publisher.first()){ (i) in
                                self.pokename = self.pokemon[i].name
                                
                            }
                        }
                    }
                    .navigationBarItems(leading:
                        
                        
                        Button(action: {
                            self.showPokePicker.toggle()
                        }){
                            Text("Done")
                    })
                }
            }
            
            VStack(spacing: 15){
                
                VStack{
                    
                    TextField("Name...", text: self.$pokename).disabled(true)
                    Divider()
                    TextField("CP...", text: self.$cp).keyboardType(.numberPad)
                    Divider()
                    //                    TextField("Time of sighting...", text: self.$timeSightedAt)
                    //                    Divider()
                }
                
                Button(action: {
                    
                    
                    if(self.pokename == "" || self.cp == "")
                    {
                        self.showAlert.toggle()
                        
                    }
                    else
                    {
                        self.AddPokemon()
                    }
                }){
                    Text("Create")
                }.alert(isPresented: self.$showAlert){
                    Alert(title: Text("Invalid form"), message: Text("All fields must be filled."), dismissButton: .cancel())
                }
            }
        }
        .onAppear(perform: {
            
            self.pokemon = self.getPokemon()
            
        })
    }
    
    func getPokemon() -> [MapPkm]
    {
        let pokemon: [MapPkm] = []
        
        self.pokemon.append(MapPkm(name: "Bulbasaur", dexnum: "001"))
        self.pokemon.append(MapPkm(name: "Ivysaur", dexnum: "002"))
        self.pokemon.append(MapPkm(name: "Venusaur", dexnum: "003"))
        self.pokemon.append(MapPkm(name: "Charmander", dexnum: "004"))
        self.pokemon.append(MapPkm(name: "Charmeleon", dexnum: "005"))
        self.pokemon.append(MapPkm(name: "Charizard", dexnum: "006"))
        self.pokemon.append(MapPkm(name: "Squirtle", dexnum: "007"))
        self.pokemon.append(MapPkm(name: "Wartortle", dexnum: "008"))
        self.pokemon.append(MapPkm(name: "Blastoise", dexnum: "009"))
        self.pokemon.append(MapPkm(name: "Caterpie", dexnum: "010"))
        self.pokemon.append(MapPkm(name: "Metapod", dexnum: "011"))
        self.pokemon.append(MapPkm(name: "Butterfree", dexnum: "012"))
        self.pokemon.append(MapPkm(name: "Weedle", dexnum: "013"))
        self.pokemon.append(MapPkm(name: "Kakuna", dexnum: "014"))
        self.pokemon.append(MapPkm(name: "Beedrill", dexnum: "015"))
        self.pokemon.append(MapPkm(name: "Pidgey", dexnum: "016"))
        self.pokemon.append(MapPkm(name: "Pidgeotto", dexnum: "017"))
        self.pokemon.append(MapPkm(name: "Pidgeot", dexnum: "018"))
        self.pokemon.append(MapPkm(name: "Rattata", dexnum: "019"))
        self.pokemon.append(MapPkm(name: "Raticate", dexnum: "020"))
        self.pokemon.append(MapPkm(name: "Spearow", dexnum: "021"))
        self.pokemon.append(MapPkm(name: "Fearow", dexnum: "022"))
        self.pokemon.append(MapPkm(name: "Ekans", dexnum: "023"))
        self.pokemon.append(MapPkm(name: "Arbok", dexnum: "024"))
        self.pokemon.append(MapPkm(name: "Pikachu", dexnum: "025"))
        self.pokemon.append(MapPkm(name: "Raichu", dexnum: "026"))
        self.pokemon.append(MapPkm(name: "Sandshrew", dexnum: "027"))
        self.pokemon.append(MapPkm(name: "Sandslash", dexnum: "028"))
        self.pokemon.append(MapPkm(name: "Nidoran (F)", dexnum: "029"))
        self.pokemon.append(MapPkm(name: "Nidorina", dexnum: "030"))
        self.pokemon.append(MapPkm(name: "Nidoqueen", dexnum: "031"))
        self.pokemon.append(MapPkm(name: "Nidoran (M)", dexnum: "032"))
        self.pokemon.append(MapPkm(name: "Nidorino", dexnum: "033"))
        self.pokemon.append(MapPkm(name: "Nidoking", dexnum: "034"))
        self.pokemon.append(MapPkm(name: "Clefairy", dexnum: "035"))
        self.pokemon.append(MapPkm(name: "Clefable", dexnum: "036"))
        self.pokemon.append(MapPkm(name: "Vulpix", dexnum: "037"))
        self.pokemon.append(MapPkm(name: "Ninetales", dexnum: "038"))
        self.pokemon.append(MapPkm(name: "Jigglypuff", dexnum: "039"))
        self.pokemon.append(MapPkm(name: "Wigglytuff", dexnum: "040"))
        self.pokemon.append(MapPkm(name: "Zubat", dexnum: "041"))
        self.pokemon.append(MapPkm(name: "Golbat", dexnum: "042"))
        self.pokemon.append(MapPkm(name: "Oddish", dexnum: "043"))
        self.pokemon.append(MapPkm(name: "Gloom", dexnum: "044"))
        self.pokemon.append(MapPkm(name: "Vileplume", dexnum: "045"))
        self.pokemon.append(MapPkm(name: "Paras", dexnum: "046"))
        self.pokemon.append(MapPkm(name: "Parasect", dexnum: "047"))
        self.pokemon.append(MapPkm(name: "Venonat", dexnum: "048"))
        self.pokemon.append(MapPkm(name: "Venomoth", dexnum: "049"))
        self.pokemon.append(MapPkm(name: "Diglett", dexnum: "050"))
        self.pokemon.append(MapPkm(name: "Dugtrio", dexnum: "051"))
        self.pokemon.append(MapPkm(name: "Meowth", dexnum: "052"))
        self.pokemon.append(MapPkm(name: "Persian", dexnum: "053"))
        self.pokemon.append(MapPkm(name: "Psyduck", dexnum: "054"))
        self.pokemon.append(MapPkm(name: "Golduck", dexnum: "055"))
        self.pokemon.append(MapPkm(name: "Mankey", dexnum: "056"))
        self.pokemon.append(MapPkm(name: "Primeape", dexnum: "057"))
        self.pokemon.append(MapPkm(name: "Growlithe", dexnum: "058"))
        self.pokemon.append(MapPkm(name: "Arcanine", dexnum: "059"))
        self.pokemon.append(MapPkm(name: "Poliwag", dexnum: "060"))
        self.pokemon.append(MapPkm(name: "Poliwhirl", dexnum: "061"))
        self.pokemon.append(MapPkm(name: "Poliwrath", dexnum: "062"))
        self.pokemon.append(MapPkm(name: "Abra", dexnum: "063"))
        self.pokemon.append(MapPkm(name: "Kadabra", dexnum: "064"))
        self.pokemon.append(MapPkm(name: "Alakazam", dexnum: "065"))
        self.pokemon.append(MapPkm(name: "Machop", dexnum: "066"))
        self.pokemon.append(MapPkm(name: "Machoke", dexnum: "067"))
        self.pokemon.append(MapPkm(name: "Machamp", dexnum: "068"))
        self.pokemon.append(MapPkm(name: "Bellsprout", dexnum: "069"))
        self.pokemon.append(MapPkm(name: "Weepinbell", dexnum: "070"))
        self.pokemon.append(MapPkm(name: "Victreebel", dexnum: "071"))
        self.pokemon.append(MapPkm(name: "Tentacool", dexnum: "072"))
        self.pokemon.append(MapPkm(name: "Tentacruel", dexnum: "073"))
        self.pokemon.append(MapPkm(name: "Geodude", dexnum: "074"))
        self.pokemon.append(MapPkm(name: "Graveler", dexnum: "075"))
        self.pokemon.append(MapPkm(name: "Golem", dexnum: "076"))
        self.pokemon.append(MapPkm(name: "Ponyta", dexnum: "077"))
        self.pokemon.append(MapPkm(name: "Rapidash", dexnum: "078"))
        self.pokemon.append(MapPkm(name: "Slowpoke", dexnum: "079"))
        self.pokemon.append(MapPkm(name: "Slowbro", dexnum: "080"))
        self.pokemon.append(MapPkm(name: "Magnemite", dexnum: "081"))
        self.pokemon.append(MapPkm(name: "Magneton", dexnum: "082"))
        self.pokemon.append(MapPkm(name: "Farfetch'd", dexnum: "083"))
        self.pokemon.append(MapPkm(name: "Doduo", dexnum: "084"))
        self.pokemon.append(MapPkm(name: "Dodrio", dexnum: "085"))
        self.pokemon.append(MapPkm(name: "Seel", dexnum: "086"))
        self.pokemon.append(MapPkm(name: "Dewgong", dexnum: "087"))
        self.pokemon.append(MapPkm(name: "Grimer", dexnum: "088"))
        self.pokemon.append(MapPkm(name: "Muk", dexnum: "089"))
        self.pokemon.append(MapPkm(name: "Shellder", dexnum: "090"))
        self.pokemon.append(MapPkm(name: "Cloyster", dexnum: "091"))
        self.pokemon.append(MapPkm(name: "Gastly", dexnum: "092"))
        self.pokemon.append(MapPkm(name: "Haunter", dexnum: "093"))
        self.pokemon.append(MapPkm(name: "Gengar", dexnum: "094"))
        self.pokemon.append(MapPkm(name: "Onix", dexnum: "095"))
        self.pokemon.append(MapPkm(name: "Drowzee", dexnum: "096"))
        self.pokemon.append(MapPkm(name: "Hypno", dexnum: "097"))
        self.pokemon.append(MapPkm(name: "Krabby", dexnum: "098"))
        self.pokemon.append(MapPkm(name: "Kingler", dexnum: "099"))
        self.pokemon.append(MapPkm(name: "Voltorb", dexnum: "100"))
        self.pokemon.append(MapPkm(name: "", dexnum: "101"))
        self.pokemon.append(MapPkm(name: "", dexnum: "102"))
        self.pokemon.append(MapPkm(name: "", dexnum: "103"))
        self.pokemon.append(MapPkm(name: "", dexnum: "104"))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
        
        return pokemon
    }
    
    func AddPokemon()
    {
        print("adding pokemon")
        
        
        let db = Firestore.firestore()
        let collection = db.collection("pokemon")
        let doc = collection.document()
        let id = doc.documentID
        
        
        
    }
    
    struct MapPkm {
        var name: String
        var dexnum: String
    }
}

struct AddRaidView: View {
    
    @State var pokename = ""
    @State var isActive = 0
    @State var difficulty = "" //convert to nsnumber
    @State var cp = "" //convert to nsnumber
    @State var timeLeft = "" //convert to nsnumber
    @Binding var show: Bool
    
    var body: some View{
        VStack(spacing: 10){
            Image(systemName: "questionmark.circle").resizable().frame(width: 120, height: 120).foregroundColor(.gray).onTapGesture {
                print("present scroll picker")
            }
            
            VStack(spacing: 15){
                
                VStack{
                    Picker(selection: $isActive, label: Text("")) {
                        Text("Active").tag(0)
                        Text("Inctive").tag(1)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    TextField("Name...", text: self.$pokename)
                    Divider()
                    
                    (isActive == 0 ? TextField("CP...", text: self.$cp) : TextField("Difficulty...", text: self.$difficulty))
                    Divider()
                    
                    TextField("Remaining time...", text: self.$timeLeft)
                    Divider()
                }
                
                Button(action: {
                    self.AddRaid()
                }){
                    Text("Create")
                }
            }
        }
    }
    
    func AddRaid()
    {
        
    }
}

//struct AddToMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddToMapView()
//    }
//}
