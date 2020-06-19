//
//  AddToMapView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 6/2/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import Firebase
import CoreLocation

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
    @State var dexnum = ""
    @State var timeSightedAt = "" //convert to nsnumber
    @Binding var show: Bool
    @State var showPokePicker = false
    @State var selectedPokemon = 0
    @State var showAlert = false
    let locationManager = CLLocationManager()
    
    
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
                                self.dexnum = self.pokemon[i].dexnum
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
            
            self.getPokemon()
            print(self.pokemon.description)
        })
    }
    
    func getPokemon()
    {
        
        self.pokemon.append(MapPkm(name: "", dexnum: ""))
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
        self.pokemon.append(MapPkm(name: "Electrode", dexnum: "101"))
        self.pokemon.append(MapPkm(name: "Exeggcute", dexnum: "102"))
        self.pokemon.append(MapPkm(name: "Exeggutor", dexnum: "103"))
        self.pokemon.append(MapPkm(name: "Cubone", dexnum: "104"))
        self.pokemon.append(MapPkm(name: "Marowak", dexnum: "105"))
        self.pokemon.append(MapPkm(name: "Hitmonlee", dexnum: "106"))
        self.pokemon.append(MapPkm(name: "Hitmonchan", dexnum: "107"))
        self.pokemon.append(MapPkm(name: "Lickitung", dexnum: "108"))
        self.pokemon.append(MapPkm(name: "Koffing", dexnum: "109"))
        self.pokemon.append(MapPkm(name: "Weezing", dexnum: "110"))
        self.pokemon.append(MapPkm(name: "Rhyhorn", dexnum: "111"))
        self.pokemon.append(MapPkm(name: "Rhydon", dexnum: "112"))
        self.pokemon.append(MapPkm(name: "Chansey", dexnum: "113"))
        self.pokemon.append(MapPkm(name: "Tangela", dexnum: "114"))
        self.pokemon.append(MapPkm(name: "Kangaskhan", dexnum: "115"))
        self.pokemon.append(MapPkm(name: "Horsea", dexnum: "116"))
        self.pokemon.append(MapPkm(name: "Seadra", dexnum: "117"))
        self.pokemon.append(MapPkm(name: "Goldeen", dexnum: "118"))
        self.pokemon.append(MapPkm(name: "Seaking", dexnum: "119"))
        self.pokemon.append(MapPkm(name: "Staryu", dexnum: "120"))
        self.pokemon.append(MapPkm(name: "Starmie", dexnum: "121"))
        self.pokemon.append(MapPkm(name: "Mr. Mime", dexnum: "122"))
        self.pokemon.append(MapPkm(name: "Scyther", dexnum: "123"))
        self.pokemon.append(MapPkm(name: "Jynx", dexnum: "124"))
        self.pokemon.append(MapPkm(name: "Electabuzz", dexnum: "125"))
        self.pokemon.append(MapPkm(name: "Magmar", dexnum: "126"))
        self.pokemon.append(MapPkm(name: "Pinsir", dexnum: "127"))
        self.pokemon.append(MapPkm(name: "Tauros", dexnum: "128"))
        self.pokemon.append(MapPkm(name: "Magikarp", dexnum: "129"))
        self.pokemon.append(MapPkm(name: "Gyarados", dexnum: "130"))
        self.pokemon.append(MapPkm(name: "Lapras", dexnum: "131"))
        self.pokemon.append(MapPkm(name: "Ditto", dexnum: "132"))
        self.pokemon.append(MapPkm(name: "Eevee", dexnum: "133"))
        self.pokemon.append(MapPkm(name: "Vaporeon", dexnum: "134"))
        self.pokemon.append(MapPkm(name: "Jolteon", dexnum: "135"))
        self.pokemon.append(MapPkm(name: "Flareon", dexnum: "136"))
        self.pokemon.append(MapPkm(name: "Porygon", dexnum: "137"))
        self.pokemon.append(MapPkm(name: "Omanyte", dexnum: "138"))
        self.pokemon.append(MapPkm(name: "Omastar", dexnum: "139"))
        self.pokemon.append(MapPkm(name: "Kabuto", dexnum: "140"))
        self.pokemon.append(MapPkm(name: "Kabutops", dexnum: "141"))
        self.pokemon.append(MapPkm(name: "Aerodactyl", dexnum: "142"))
        self.pokemon.append(MapPkm(name: "Snorlax", dexnum: "143"))
        self.pokemon.append(MapPkm(name: "Dratini", dexnum: "147"))
        self.pokemon.append(MapPkm(name: "Dragonair", dexnum: "148"))
        self.pokemon.append(MapPkm(name: "Dragonite", dexnum: "149"))
        self.pokemon.append(MapPkm(name: "Chikorita", dexnum: "152"))
        self.pokemon.append(MapPkm(name: "Bayleef", dexnum: "153"))
        self.pokemon.append(MapPkm(name: "Meganium", dexnum: "154"))
        self.pokemon.append(MapPkm(name: "Cyndaquil", dexnum: "155"))
        self.pokemon.append(MapPkm(name: "Quilava", dexnum: "156"))
        self.pokemon.append(MapPkm(name: "Typhlosion", dexnum: "157"))
        self.pokemon.append(MapPkm(name: "Totodile", dexnum: "158"))
        self.pokemon.append(MapPkm(name: "Croconaw", dexnum: "159"))
        self.pokemon.append(MapPkm(name: "Feraligatr", dexnum: "160"))
        self.pokemon.append(MapPkm(name: "Sentret", dexnum: "161"))
        self.pokemon.append(MapPkm(name: "Furret", dexnum: "162"))
        self.pokemon.append(MapPkm(name: "Hoothoot", dexnum: "163"))
        self.pokemon.append(MapPkm(name: "Noctowl", dexnum: "164"))
        self.pokemon.append(MapPkm(name: "Ledyba", dexnum: "165"))
        self.pokemon.append(MapPkm(name: "Ledian", dexnum: "166"))
        self.pokemon.append(MapPkm(name: "Spinarak", dexnum: "167"))
        self.pokemon.append(MapPkm(name: "Ariados", dexnum: "168"))
        self.pokemon.append(MapPkm(name: "Crobat", dexnum: "169"))
        self.pokemon.append(MapPkm(name: "Chinchou", dexnum: "170"))
        self.pokemon.append(MapPkm(name: "Lanturn", dexnum: "171"))
        self.pokemon.append(MapPkm(name: "Togepi", dexnum: "175"))
        self.pokemon.append(MapPkm(name: "Togetic", dexnum: "176"))
        self.pokemon.append(MapPkm(name: "Natu", dexnum: "177"))
        self.pokemon.append(MapPkm(name: "Xatu", dexnum: "178"))
        self.pokemon.append(MapPkm(name: "Mareep", dexnum: "179"))
        self.pokemon.append(MapPkm(name: "Flaaffy", dexnum: "180"))
        self.pokemon.append(MapPkm(name: "Ampharos", dexnum: "181"))
        self.pokemon.append(MapPkm(name: "Bellossom", dexnum: "182"))
        self.pokemon.append(MapPkm(name: "Marill", dexnum: "183"))
        self.pokemon.append(MapPkm(name: "Azumarill", dexnum: "184"))
        self.pokemon.append(MapPkm(name: "Sudowoodo", dexnum: "185"))
        self.pokemon.append(MapPkm(name: "Politoed", dexnum: "186"))
        self.pokemon.append(MapPkm(name: "Hoppip", dexnum: "187"))
        self.pokemon.append(MapPkm(name: "Skiploom", dexnum: "188"))
        self.pokemon.append(MapPkm(name: "Jumpluff", dexnum: "189"))
        self.pokemon.append(MapPkm(name: "Aipom", dexnum: "190"))
        self.pokemon.append(MapPkm(name: "Sunkern", dexnum: "191"))
        self.pokemon.append(MapPkm(name: "Sunflora", dexnum: "192"))
        self.pokemon.append(MapPkm(name: "Yanma", dexnum: "193"))
        self.pokemon.append(MapPkm(name: "Wooper", dexnum: "194"))
        self.pokemon.append(MapPkm(name: "Quagsire", dexnum: "195"))
        self.pokemon.append(MapPkm(name: "Espeon", dexnum: "196"))
        self.pokemon.append(MapPkm(name: "Umbreon", dexnum: "197"))
        self.pokemon.append(MapPkm(name: "Murkrow", dexnum: "198"))
        self.pokemon.append(MapPkm(name: "Slowking", dexnum: "199"))
        self.pokemon.append(MapPkm(name: "Misdreavus", dexnum: "200"))
        self.pokemon.append(MapPkm(name: "Unown", dexnum: "201"))
        self.pokemon.append(MapPkm(name: "Wobboffet", dexnum: "202"))
        self.pokemon.append(MapPkm(name: "Girafarig", dexnum: "203"))
        self.pokemon.append(MapPkm(name: "Pineco", dexnum: "204"))
        self.pokemon.append(MapPkm(name: "Forretress", dexnum: "205"))
        self.pokemon.append(MapPkm(name: "Dunsparce", dexnum: "206"))
        self.pokemon.append(MapPkm(name: "Gligar", dexnum: "207"))
        self.pokemon.append(MapPkm(name: "Steelix", dexnum: "208"))
        self.pokemon.append(MapPkm(name: "Snubbull", dexnum: "209"))
        self.pokemon.append(MapPkm(name: "Grandbull", dexnum: "210"))
        self.pokemon.append(MapPkm(name: "Qwilfish", dexnum: "211"))
        self.pokemon.append(MapPkm(name: "Scizor", dexnum: "212"))
        self.pokemon.append(MapPkm(name: "Shuckle", dexnum: "213"))
        self.pokemon.append(MapPkm(name: "Heracross", dexnum: "214"))
        self.pokemon.append(MapPkm(name: "Sneasel", dexnum: "215"))
        self.pokemon.append(MapPkm(name: "Teddiursa", dexnum: "216"))
        self.pokemon.append(MapPkm(name: "Ursaring", dexnum: "217"))
        self.pokemon.append(MapPkm(name: "Slugma", dexnum: "218"))
        self.pokemon.append(MapPkm(name: "Magcargo", dexnum: "219"))
        self.pokemon.append(MapPkm(name: "Swinub", dexnum: "220"))
        self.pokemon.append(MapPkm(name: "Piloswine", dexnum: "221"))
        self.pokemon.append(MapPkm(name: "Corsola", dexnum: "222"))
        self.pokemon.append(MapPkm(name: "Remoraid", dexnum: "223"))
        self.pokemon.append(MapPkm(name: "Octillery", dexnum: "224"))
        self.pokemon.append(MapPkm(name: "Delibird", dexnum: "225"))
        self.pokemon.append(MapPkm(name: "Mantine", dexnum: "226"))
        self.pokemon.append(MapPkm(name: "Skarmory", dexnum: "227"))
        self.pokemon.append(MapPkm(name: "Houndour", dexnum: "228"))
        self.pokemon.append(MapPkm(name: "Houndoom", dexnum: "229"))
        self.pokemon.append(MapPkm(name: "Kingdra", dexnum: "230"))
        self.pokemon.append(MapPkm(name: "Phanpy", dexnum: "231"))
        self.pokemon.append(MapPkm(name: "Donphan", dexnum: "232"))
        self.pokemon.append(MapPkm(name: "Porygon2", dexnum: "233"))
        self.pokemon.append(MapPkm(name: "Stantler", dexnum: "234"))
        self.pokemon.append(MapPkm(name: "Smeargle", dexnum: "235"))
        self.pokemon.append(MapPkm(name: "Tyrogue", dexnum: "236"))
        self.pokemon.append(MapPkm(name: "Hitmontop", dexnum: "237"))
        self.pokemon.append(MapPkm(name: "Smoochum", dexnum: "238"))
        self.pokemon.append(MapPkm(name: "Elekid", dexnum: "239"))
        self.pokemon.append(MapPkm(name: "Magby", dexnum: "240"))
        self.pokemon.append(MapPkm(name: "Miltank", dexnum: "241"))
        self.pokemon.append(MapPkm(name: "Blissey", dexnum: "242"))
        self.pokemon.append(MapPkm(name: "Larvitar", dexnum: "246"))
        self.pokemon.append(MapPkm(name: "Pupitar", dexnum: "247"))
        self.pokemon.append(MapPkm(name: "Tyranitar", dexnum: "248"))
        self.pokemon.append(MapPkm(name: "Treecko", dexnum: "252"))
        self.pokemon.append(MapPkm(name: "Grovyle", dexnum: "253"))
        self.pokemon.append(MapPkm(name: "Sceptile", dexnum: "254"))
        self.pokemon.append(MapPkm(name: "Torchic", dexnum: "255"))
        self.pokemon.append(MapPkm(name: "Combusken", dexnum: "256"))
        self.pokemon.append(MapPkm(name: "Blaziken", dexnum: "257"))
        self.pokemon.append(MapPkm(name: "Mudkip", dexnum: "258"))
        self.pokemon.append(MapPkm(name: "Marshtomp", dexnum: "259"))
        self.pokemon.append(MapPkm(name: "Swampert", dexnum: "260"))
        self.pokemon.append(MapPkm(name: "Poochyena", dexnum: "261"))
        self.pokemon.append(MapPkm(name: "Mightyena", dexnum: "262"))
        self.pokemon.append(MapPkm(name: "Zigzagoon", dexnum: "263"))
        self.pokemon.append(MapPkm(name: "Linoone", dexnum: "264"))
        self.pokemon.append(MapPkm(name: "Wurmple", dexnum: "265"))
        self.pokemon.append(MapPkm(name: "Silcoon", dexnum: "266"))
        self.pokemon.append(MapPkm(name: "Beautifly", dexnum: "267"))
        self.pokemon.append(MapPkm(name: "Cascoon", dexnum: "268"))
        self.pokemon.append(MapPkm(name: "Dustox", dexnum: "269"))
        self.pokemon.append(MapPkm(name: "Lotad", dexnum: "270"))
        self.pokemon.append(MapPkm(name: "Lombre", dexnum: "271"))
        self.pokemon.append(MapPkm(name: "Ludicolo", dexnum: "272"))
        self.pokemon.append(MapPkm(name: "Seedot", dexnum: "273"))
        self.pokemon.append(MapPkm(name: "Nuzleaf", dexnum: "274"))
        self.pokemon.append(MapPkm(name: "Shiftry", dexnum: "275"))
        self.pokemon.append(MapPkm(name: "Taillow", dexnum: "276"))
        self.pokemon.append(MapPkm(name: "Swellow", dexnum: "277"))
        self.pokemon.append(MapPkm(name: "Wingull", dexnum: "278"))
        self.pokemon.append(MapPkm(name: "Pelipper", dexnum: "279"))
        self.pokemon.append(MapPkm(name: "Ralts", dexnum: "280"))
        self.pokemon.append(MapPkm(name: "Kirlia", dexnum: "281"))
        self.pokemon.append(MapPkm(name: "Gardevoir", dexnum: "282"))
        self.pokemon.append(MapPkm(name: "Surskit", dexnum: "283"))
        self.pokemon.append(MapPkm(name: "Masquerain", dexnum: "284"))
        self.pokemon.append(MapPkm(name: "Shroomish", dexnum: "285"))
        self.pokemon.append(MapPkm(name: "Breloom", dexnum: "286"))
        self.pokemon.append(MapPkm(name: "Slakoth", dexnum: "287"))
        self.pokemon.append(MapPkm(name: "Vigoroth", dexnum: "288"))
        self.pokemon.append(MapPkm(name: "Slaking", dexnum: "289"))
        self.pokemon.append(MapPkm(name: "Nincada", dexnum: "290"))
        self.pokemon.append(MapPkm(name: "Ninjask", dexnum: "291"))
        self.pokemon.append(MapPkm(name: "Shedinja", dexnum: "292"))
        self.pokemon.append(MapPkm(name: "Whismur", dexnum: "293"))
        self.pokemon.append(MapPkm(name: "Loudred", dexnum: "294"))
        self.pokemon.append(MapPkm(name: "Exploud", dexnum: "295"))
        self.pokemon.append(MapPkm(name: "Makuhita", dexnum: "296"))
        self.pokemon.append(MapPkm(name: "Hariyama", dexnum: "297"))
        self.pokemon.append(MapPkm(name: "Azurill", dexnum: "298"))
        self.pokemon.append(MapPkm(name: "Nosepass", dexnum: "299"))
        self.pokemon.append(MapPkm(name: "Skitty", dexnum: "300"))
        self.pokemon.append(MapPkm(name: "Delcatty", dexnum: "301"))
        self.pokemon.append(MapPkm(name: "Sableye", dexnum: "302"))
        self.pokemon.append(MapPkm(name: "Mawile", dexnum: "303"))
        self.pokemon.append(MapPkm(name: "Aron", dexnum: "304"))
        self.pokemon.append(MapPkm(name: "Lairon", dexnum: "305"))
        self.pokemon.append(MapPkm(name: "Aggron", dexnum: "306"))
        self.pokemon.append(MapPkm(name: "Meditite", dexnum: "307"))
        self.pokemon.append(MapPkm(name: "Medicham", dexnum: "308"))
        self.pokemon.append(MapPkm(name: "Electrike", dexnum: "309"))
        self.pokemon.append(MapPkm(name: "Manetric", dexnum: "310"))
        self.pokemon.append(MapPkm(name: "Plusle", dexnum: "311"))
        self.pokemon.append(MapPkm(name: "Minun", dexnum: "312"))
        self.pokemon.append(MapPkm(name: "Volbeat", dexnum: "313"))
        self.pokemon.append(MapPkm(name: "Illumise", dexnum: "314"))
        self.pokemon.append(MapPkm(name: "Roselia", dexnum: "315"))
        self.pokemon.append(MapPkm(name: "Gulpin", dexnum: "316"))
        self.pokemon.append(MapPkm(name: "Swalot", dexnum: "317"))
        self.pokemon.append(MapPkm(name: "Carvanha", dexnum: "318"))
        self.pokemon.append(MapPkm(name: "Sharpedo", dexnum: "319"))
        self.pokemon.append(MapPkm(name: "Wailmer", dexnum: "320"))
        self.pokemon.append(MapPkm(name: "Wailord", dexnum: "321"))
        self.pokemon.append(MapPkm(name: "Numel", dexnum: "322"))
        self.pokemon.append(MapPkm(name: "Camerupt", dexnum: "323"))
        self.pokemon.append(MapPkm(name: "Torkoal", dexnum: "324"))
        self.pokemon.append(MapPkm(name: "Spoink", dexnum: "325"))
        self.pokemon.append(MapPkm(name: "Grumpig", dexnum: "326"))
        self.pokemon.append(MapPkm(name: "Spinda", dexnum: "327"))
        self.pokemon.append(MapPkm(name: "Trapinch", dexnum: "328"))
        self.pokemon.append(MapPkm(name: "Vibrava", dexnum: "329"))
        self.pokemon.append(MapPkm(name: "Flygon", dexnum: "330"))
        self.pokemon.append(MapPkm(name: "Cacnea", dexnum: "331"))
        self.pokemon.append(MapPkm(name: "Cacturne", dexnum: "332"))
        self.pokemon.append(MapPkm(name: "Swablu", dexnum: "333"))
        self.pokemon.append(MapPkm(name: "Altaria", dexnum: "334"))
        self.pokemon.append(MapPkm(name: "Zangoose", dexnum: "335"))
        self.pokemon.append(MapPkm(name: "Seviper", dexnum: "336"))
        self.pokemon.append(MapPkm(name: "Lunatone", dexnum: "337"))
        self.pokemon.append(MapPkm(name: "Solrock", dexnum: "338"))
        self.pokemon.append(MapPkm(name: "Barboach", dexnum: "339"))
        self.pokemon.append(MapPkm(name: "Whiscash", dexnum: "340"))
        self.pokemon.append(MapPkm(name: "Corphish", dexnum: "341"))
        self.pokemon.append(MapPkm(name: "Crawdaunt", dexnum: "342"))
        self.pokemon.append(MapPkm(name: "Baltoy", dexnum: "343"))
        self.pokemon.append(MapPkm(name: "Claydol", dexnum: "344"))
        self.pokemon.append(MapPkm(name: "Lileep", dexnum: "345"))
        self.pokemon.append(MapPkm(name: "Cradily", dexnum: "346"))
        self.pokemon.append(MapPkm(name: "Anorith", dexnum: "347"))
        self.pokemon.append(MapPkm(name: "Armaldo", dexnum: "348"))
        self.pokemon.append(MapPkm(name: "Feebas", dexnum: "349"))
        self.pokemon.append(MapPkm(name: "Milotuc", dexnum: "350"))
        self.pokemon.append(MapPkm(name: "Castfrom", dexnum: "351"))
        self.pokemon.append(MapPkm(name: "Kecleon", dexnum: "352"))
        self.pokemon.append(MapPkm(name: "Shuppet", dexnum: "353"))
        self.pokemon.append(MapPkm(name: "Banette", dexnum: "354"))
        self.pokemon.append(MapPkm(name: "Duskull", dexnum: "355"))
        self.pokemon.append(MapPkm(name: "Dusclops", dexnum: "356"))
        self.pokemon.append(MapPkm(name: "Tropius", dexnum: "357"))
        self.pokemon.append(MapPkm(name: "Chimecho", dexnum: "358"))
        self.pokemon.append(MapPkm(name: "Absol", dexnum: "359"))
        self.pokemon.append(MapPkm(name: "Wynaut", dexnum: "360"))
        self.pokemon.append(MapPkm(name: "Snorunt", dexnum: "361"))
        self.pokemon.append(MapPkm(name: "Glalie", dexnum: "362"))
        self.pokemon.append(MapPkm(name: "Spheal", dexnum: "363"))
        self.pokemon.append(MapPkm(name: "Sealeo", dexnum: "364"))
        self.pokemon.append(MapPkm(name: "Walrein", dexnum: "365"))
        self.pokemon.append(MapPkm(name: "Clamperl", dexnum: "366"))
        self.pokemon.append(MapPkm(name: "Huntail", dexnum: "367"))
        self.pokemon.append(MapPkm(name: "Gorebyss", dexnum: "368"))
        self.pokemon.append(MapPkm(name: "Relicanth", dexnum: "369"))
        self.pokemon.append(MapPkm(name: "Luvdisc", dexnum: "370"))
        self.pokemon.append(MapPkm(name: "Bagon", dexnum: "371"))
        self.pokemon.append(MapPkm(name: "Shelgon", dexnum: "372"))
        self.pokemon.append(MapPkm(name: "Salamence", dexnum: "373"))
        self.pokemon.append(MapPkm(name: "Beldum", dexnum: "374"))
        self.pokemon.append(MapPkm(name: "Metang", dexnum: "375"))
        self.pokemon.append(MapPkm(name: "Metagross", dexnum: "376"))
        self.pokemon.append(MapPkm(name: "Turtwig", dexnum: "387"))
        self.pokemon.append(MapPkm(name: "Grotle", dexnum: "388"))
        self.pokemon.append(MapPkm(name: "Torterra", dexnum: "389"))
        self.pokemon.append(MapPkm(name: "Chimchar", dexnum: "390"))
        self.pokemon.append(MapPkm(name: "Monferno", dexnum: "391"))
        self.pokemon.append(MapPkm(name: "Infernape", dexnum: "392"))
        self.pokemon.append(MapPkm(name: "Piplup", dexnum: "393"))
        self.pokemon.append(MapPkm(name: "Prinplup", dexnum: "394"))
        self.pokemon.append(MapPkm(name: "Empoleon", dexnum: "395"))
        self.pokemon.append(MapPkm(name: "Starly", dexnum: "396"))
        self.pokemon.append(MapPkm(name: "Staravia", dexnum: "397"))
        self.pokemon.append(MapPkm(name: "Staraptor", dexnum: "398"))
        self.pokemon.append(MapPkm(name: "Bidoof", dexnum: "399"))
        self.pokemon.append(MapPkm(name: "Bibarel", dexnum: "400"))
        self.pokemon.append(MapPkm(name: "Kricketot", dexnum: "401"))
        self.pokemon.append(MapPkm(name: "Kricketune", dexnum: "402"))
        self.pokemon.append(MapPkm(name: "Shinx", dexnum: "403"))
        self.pokemon.append(MapPkm(name: "Luxio", dexnum: "404"))
        self.pokemon.append(MapPkm(name: "Luxray", dexnum: "405"))
        self.pokemon.append(MapPkm(name: "Budew", dexnum: "406"))
        self.pokemon.append(MapPkm(name: "Roserade", dexnum: "407"))
        self.pokemon.append(MapPkm(name: "Cranidos", dexnum: "8"))
        self.pokemon.append(MapPkm(name: "Rampardos", dexnum: "409"))
        self.pokemon.append(MapPkm(name: "Shildon", dexnum: "410"))
        self.pokemon.append(MapPkm(name: "Bastiodon", dexnum: "411"))
        self.pokemon.append(MapPkm(name: "Burmy", dexnum: "412"))
        self.pokemon.append(MapPkm(name: "Wormadam", dexnum: "413"))
        self.pokemon.append(MapPkm(name: "Mothim", dexnum: "414"))
        self.pokemon.append(MapPkm(name: "Combee", dexnum: "415"))
        self.pokemon.append(MapPkm(name: "Vespiquen", dexnum: "416"))
        self.pokemon.append(MapPkm(name: "Pachirisu", dexnum: "417"))
        self.pokemon.append(MapPkm(name: "Buizel", dexnum: "418"))
        self.pokemon.append(MapPkm(name: "Floatzel", dexnum: "419"))
        self.pokemon.append(MapPkm(name: "Cherubi", dexnum: "420"))
        self.pokemon.append(MapPkm(name: "Cherrim", dexnum: "421"))
        self.pokemon.append(MapPkm(name: "Shellos", dexnum: "422"))
        self.pokemon.append(MapPkm(name: "Gastrodon", dexnum: "423"))
        self.pokemon.append(MapPkm(name: "Ambipom", dexnum: "424"))
        self.pokemon.append(MapPkm(name: "Drifloon", dexnum: "425"))
        self.pokemon.append(MapPkm(name: "Drifblim", dexnum: "426"))
        self.pokemon.append(MapPkm(name: "Buneary", dexnum: "427"))
        self.pokemon.append(MapPkm(name: "Lopunny", dexnum: "428"))
        self.pokemon.append(MapPkm(name: "Mismagius", dexnum: "429"))
        self.pokemon.append(MapPkm(name: "Honchkrow", dexnum: "430"))
        self.pokemon.append(MapPkm(name: "Glameow", dexnum: "431"))
        self.pokemon.append(MapPkm(name: "Purugly", dexnum: "432"))
        self.pokemon.append(MapPkm(name: "Chingling", dexnum: "433"))
        self.pokemon.append(MapPkm(name: "Stunky", dexnum: "434"))
        self.pokemon.append(MapPkm(name: "Skuntank", dexnum: "435"))
        self.pokemon.append(MapPkm(name: "Bronzor", dexnum: "436"))
        self.pokemon.append(MapPkm(name: "Bronzong", dexnum: "437"))
        self.pokemon.append(MapPkm(name: "Bonsly", dexnum: "438"))
        self.pokemon.append(MapPkm(name: "Mime Jr.", dexnum: "439"))
        self.pokemon.append(MapPkm(name: "Happiny", dexnum: "440"))
        self.pokemon.append(MapPkm(name: "Chatot", dexnum: "441"))
        //self.pokemon.append(MapPkm(name: "Spiritomb", dexnum: "2"))
        self.pokemon.append(MapPkm(name: "Gible", dexnum: "443"))
        self.pokemon.append(MapPkm(name: "Gabite", dexnum: "444"))
        self.pokemon.append(MapPkm(name: "Garchomp", dexnum: "445"))
        self.pokemon.append(MapPkm(name: "Munchlax", dexnum: "446"))
        self.pokemon.append(MapPkm(name: "Riolu", dexnum: "447"))
        self.pokemon.append(MapPkm(name: "Lucario", dexnum: "448"))
        self.pokemon.append(MapPkm(name: "Hippopotas", dexnum: "449"))
        self.pokemon.append(MapPkm(name: "Hippowdon", dexnum: "450"))
        self.pokemon.append(MapPkm(name: "Skorupi", dexnum: "451"))
        self.pokemon.append(MapPkm(name: "Drapion", dexnum: "452"))
        self.pokemon.append(MapPkm(name: "Croagunk", dexnum: "453"))
        self.pokemon.append(MapPkm(name: "Toxicroak", dexnum: "454"))
        self.pokemon.append(MapPkm(name: "Carnivine", dexnum: "455"))
        self.pokemon.append(MapPkm(name: "Finneon", dexnum: "456"))
        self.pokemon.append(MapPkm(name: "Lumineon", dexnum: "457"))
        self.pokemon.append(MapPkm(name: "Mantyke", dexnum: "458"))
        self.pokemon.append(MapPkm(name: "Snover", dexnum: "459"))
        self.pokemon.append(MapPkm(name: "Abomasnow", dexnum: "460"))
        self.pokemon.append(MapPkm(name: "Weavile", dexnum: "461"))
        self.pokemon.append(MapPkm(name: "Magnezone", dexnum: "462"))
        self.pokemon.append(MapPkm(name: "Lickilicky", dexnum: "463"))
        self.pokemon.append(MapPkm(name: "Rhyperior", dexnum: "464"))
        self.pokemon.append(MapPkm(name: "Tangrowth", dexnum: "465"))
        self.pokemon.append(MapPkm(name: "Electivire", dexnum: "466"))
        self.pokemon.append(MapPkm(name: "Magmortar", dexnum: "467"))
        self.pokemon.append(MapPkm(name: "Togekiss", dexnum: "468"))
        self.pokemon.append(MapPkm(name: "Yanmega", dexnum: "469"))
        self.pokemon.append(MapPkm(name: "Leafeon", dexnum: "470"))
        self.pokemon.append(MapPkm(name: "Glaceon", dexnum: "471"))
        self.pokemon.append(MapPkm(name: "Gliscor", dexnum: "472"))
        self.pokemon.append(MapPkm(name: "Mamoswine", dexnum: "473"))
        self.pokemon.append(MapPkm(name: "Porygon-Z", dexnum: "474"))
        self.pokemon.append(MapPkm(name: "Gallade", dexnum: "475"))
        self.pokemon.append(MapPkm(name: "Probopass", dexnum: "476"))
        self.pokemon.append(MapPkm(name: "Dusknoir", dexnum: "477"))
        self.pokemon.append(MapPkm(name: "Froslass", dexnum: "478"))
        self.pokemon.append(MapPkm(name: "Rotom", dexnum: "479"))
        self.pokemon.append(MapPkm(name: "Snivy", dexnum: "495"))
        self.pokemon.append(MapPkm(name: "Servine", dexnum: "496"))
        self.pokemon.append(MapPkm(name: "Serperior", dexnum: "497"))
        self.pokemon.append(MapPkm(name: "Tepig", dexnum: "498"))
        self.pokemon.append(MapPkm(name: "Pignite", dexnum: "499"))
        self.pokemon.append(MapPkm(name: "Emboar", dexnum: "500"))
        self.pokemon.append(MapPkm(name: "Oshawott", dexnum: "501"))
        self.pokemon.append(MapPkm(name: "Dewott", dexnum: "502"))
        self.pokemon.append(MapPkm(name: "Samurott", dexnum: "503"))
        self.pokemon.append(MapPkm(name: "Patrat", dexnum: "504"))
        self.pokemon.append(MapPkm(name: "Watchog", dexnum: "505"))
        self.pokemon.append(MapPkm(name: "Lillipup", dexnum: "506"))
        self.pokemon.append(MapPkm(name: "Herdier", dexnum: "507"))
        self.pokemon.append(MapPkm(name: "Stoutland", dexnum: "508"))
        self.pokemon.append(MapPkm(name: "Purrloin", dexnum: "509"))
        self.pokemon.append(MapPkm(name: "Liepard", dexnum: "510"))
        self.pokemon.append(MapPkm(name: "Pansage", dexnum: "511"))
        self.pokemon.append(MapPkm(name: "Simisage", dexnum: "512"))
        self.pokemon.append(MapPkm(name: "Pansear", dexnum: "513"))
        self.pokemon.append(MapPkm(name: "Simisear", dexnum: "514"))
        self.pokemon.append(MapPkm(name: "Panpour", dexnum: "515"))
        self.pokemon.append(MapPkm(name: "Simipour", dexnum: "516"))
        self.pokemon.append(MapPkm(name: "Munna", dexnum: "517"))
        self.pokemon.append(MapPkm(name: "Musharana", dexnum: "518"))
        self.pokemon.append(MapPkm(name: "Pidove", dexnum: "519"))
        self.pokemon.append(MapPkm(name: "Tranquill", dexnum: "520"))
        self.pokemon.append(MapPkm(name: "Unfezant", dexnum: "521"))
        self.pokemon.append(MapPkm(name: "Blitzle", dexnum: "522"))
        self.pokemon.append(MapPkm(name: "Zebstrika", dexnum: "523"))
        self.pokemon.append(MapPkm(name: "Roggenrola", dexnum: "524"))
        self.pokemon.append(MapPkm(name: "Boldore", dexnum: "525"))
        self.pokemon.append(MapPkm(name: "Gigalith", dexnum: "526"))
        self.pokemon.append(MapPkm(name: "Woobat", dexnum: "527"))
        self.pokemon.append(MapPkm(name: "Swoobat", dexnum: "528"))
        self.pokemon.append(MapPkm(name: "Drilbur", dexnum: "529"))
        self.pokemon.append(MapPkm(name: "Excadrill", dexnum: "530"))
        self.pokemon.append(MapPkm(name: "Audino", dexnum: "531"))
        self.pokemon.append(MapPkm(name: "Timburr", dexnum: "532"))
        self.pokemon.append(MapPkm(name: "Gurdurr", dexnum: "533"))
        self.pokemon.append(MapPkm(name: "Conkeldurr", dexnum: "534"))
        self.pokemon.append(MapPkm(name: "Tympole", dexnum: "535"))
        self.pokemon.append(MapPkm(name: "Palpitoad", dexnum: "536"))
        self.pokemon.append(MapPkm(name: "Seismitoad", dexnum: "537"))
        self.pokemon.append(MapPkm(name: "Throh", dexnum: "538"))
        self.pokemon.append(MapPkm(name: "Sawk", dexnum: "539"))
        self.pokemon.append(MapPkm(name: "Sewaddle", dexnum: "540"))
        self.pokemon.append(MapPkm(name: "Swadloon", dexnum: "541"))
        self.pokemon.append(MapPkm(name: "Leavanny", dexnum: "542"))
        self.pokemon.append(MapPkm(name: "Venipede", dexnum: "543"))
        self.pokemon.append(MapPkm(name: "Whirlipede", dexnum: "544"))
        self.pokemon.append(MapPkm(name: "Scolipede", dexnum: "545"))
        self.pokemon.append(MapPkm(name: "Cottonee", dexnum: "546"))
        self.pokemon.append(MapPkm(name: "Whimsicott", dexnum: "547"))
        self.pokemon.append(MapPkm(name: "Petilil", dexnum: "548"))
        self.pokemon.append(MapPkm(name: "Lilligant", dexnum: "549"))
        self.pokemon.append(MapPkm(name: "Basculin", dexnum: "550"))
        self.pokemon.append(MapPkm(name: "Sandile", dexnum: "551"))
        self.pokemon.append(MapPkm(name: "Krokorok", dexnum: "552"))
        self.pokemon.append(MapPkm(name: "Krookodile", dexnum: "553"))
        self.pokemon.append(MapPkm(name: "Darumaka", dexnum: "554"))
        self.pokemon.append(MapPkm(name: "Darmanitan", dexnum: "555"))
        self.pokemon.append(MapPkm(name: "Maractus", dexnum: "556"))
        self.pokemon.append(MapPkm(name: "Dwebble", dexnum: "557"))
        self.pokemon.append(MapPkm(name: "Crustle", dexnum: "558"))
        self.pokemon.append(MapPkm(name: "Scraggy", dexnum: "559"))
        self.pokemon.append(MapPkm(name: "Scrafty", dexnum: "560"))
        self.pokemon.append(MapPkm(name: "Sigilyph", dexnum: "561"))
        self.pokemon.append(MapPkm(name: "Yamask", dexnum: "562"))
        self.pokemon.append(MapPkm(name: "Cofagrigus", dexnum: "563"))
        self.pokemon.append(MapPkm(name: "Tirtouga", dexnum: "564"))
        self.pokemon.append(MapPkm(name: "Carracosta", dexnum: "565"))
        self.pokemon.append(MapPkm(name: "Archen", dexnum: "566"))
        self.pokemon.append(MapPkm(name: "Archeops", dexnum: "567"))
        self.pokemon.append(MapPkm(name: "Trubbish", dexnum: "568"))
        self.pokemon.append(MapPkm(name: "Garbodor", dexnum: "569"))
        self.pokemon.append(MapPkm(name: "Zorua", dexnum: "570"))
        self.pokemon.append(MapPkm(name: "Zoroark", dexnum: "571"))
        self.pokemon.append(MapPkm(name: "Minccino", dexnum: "572"))
        self.pokemon.append(MapPkm(name: "Cinccino", dexnum: "573"))
        self.pokemon.append(MapPkm(name: "Gothita", dexnum: "574"))
        self.pokemon.append(MapPkm(name: "Gothorita", dexnum: "575"))
        self.pokemon.append(MapPkm(name: "Gothitelle", dexnum: "576"))
        self.pokemon.append(MapPkm(name: "Solosis", dexnum: "577"))
        self.pokemon.append(MapPkm(name: "Duosion", dexnum: "578"))
        self.pokemon.append(MapPkm(name: "Reuniclus", dexnum: "579"))
        self.pokemon.append(MapPkm(name: "Ducklett", dexnum: "580"))
        self.pokemon.append(MapPkm(name: "Swanna", dexnum: "581"))
        self.pokemon.append(MapPkm(name: "Vanillite", dexnum: "582"))
        self.pokemon.append(MapPkm(name: "Vanillish", dexnum: "583"))
        self.pokemon.append(MapPkm(name: "Vanilluxe", dexnum: "584"))
        self.pokemon.append(MapPkm(name: "Deerling", dexnum: "585"))
        self.pokemon.append(MapPkm(name: "Sawsbuck", dexnum: "586"))
        self.pokemon.append(MapPkm(name: "Emolga", dexnum: "587"))
        self.pokemon.append(MapPkm(name: "Karrablast", dexnum: "588"))
        self.pokemon.append(MapPkm(name: "Escavalier", dexnum: "589"))
        self.pokemon.append(MapPkm(name: "Foongus", dexnum: "0"))
        self.pokemon.append(MapPkm(name: "Amoonguss", dexnum: "1"))
        self.pokemon.append(MapPkm(name: "Frillish", dexnum: "2"))
        self.pokemon.append(MapPkm(name: "Jellicent", dexnum: "3"))
        self.pokemon.append(MapPkm(name: "Alomomola", dexnum: "4"))
        self.pokemon.append(MapPkm(name: "Joltik", dexnum: "5"))
        self.pokemon.append(MapPkm(name: "Galvantula", dexnum: "6"))
        self.pokemon.append(MapPkm(name: "Ferroseed", dexnum: "7"))
        self.pokemon.append(MapPkm(name: "Ferrothorn", dexnum: "8"))
        self.pokemon.append(MapPkm(name: "Klink", dexnum: "9"))
        self.pokemon.append(MapPkm(name: "Klang", dexnum: "0"))
        self.pokemon.append(MapPkm(name: "Klinklang", dexnum: "1"))
        self.pokemon.append(MapPkm(name: "Tynamo", dexnum: "2"))
        self.pokemon.append(MapPkm(name: "Eelektrik", dexnum: "3"))
        self.pokemon.append(MapPkm(name: "Eelektross", dexnum: "4"))
        self.pokemon.append(MapPkm(name: "Elgyem", dexnum: "5"))
        self.pokemon.append(MapPkm(name: "Beheeyem", dexnum: "6"))
        self.pokemon.append(MapPkm(name: "Litwick", dexnum: "7"))
        self.pokemon.append(MapPkm(name: "Lampent", dexnum: "8"))
        self.pokemon.append(MapPkm(name: "Chandelure", dexnum: "9"))
        self.pokemon.append(MapPkm(name: "Axew", dexnum: "0"))
        self.pokemon.append(MapPkm(name: "Fraxure", dexnum: "1"))
        self.pokemon.append(MapPkm(name: "Haxorus", dexnum: "2"))
        self.pokemon.append(MapPkm(name: "Cubchoo", dexnum: "3"))
        self.pokemon.append(MapPkm(name: "Beartic", dexnum: "4"))
        self.pokemon.append(MapPkm(name: "Cryogonal", dexnum: "5"))
        self.pokemon.append(MapPkm(name: "Shelmet", dexnum: "6"))
        self.pokemon.append(MapPkm(name: "Accelgor", dexnum: "7"))
        self.pokemon.append(MapPkm(name: "Stunfusk", dexnum: "8"))
        self.pokemon.append(MapPkm(name: "Mienfoo", dexnum: "9"))
        self.pokemon.append(MapPkm(name: "Mienshao", dexnum: "0"))
        self.pokemon.append(MapPkm(name: "Druddigon", dexnum: "1"))
        self.pokemon.append(MapPkm(name: "Golett", dexnum: "2"))
        self.pokemon.append(MapPkm(name: "Golurk", dexnum: "3"))
        self.pokemon.append(MapPkm(name: "Pawniard", dexnum: "4"))
        self.pokemon.append(MapPkm(name: "Bisharp", dexnum: "5"))
        self.pokemon.append(MapPkm(name: "Bouffalant", dexnum: "6"))
        self.pokemon.append(MapPkm(name: "Rufflet", dexnum: "7"))
        self.pokemon.append(MapPkm(name: "Braviary", dexnum: "8"))
        self.pokemon.append(MapPkm(name: "Vullaby", dexnum: "9"))
        self.pokemon.append(MapPkm(name: "Mandibuzz", dexnum: "0"))
        self.pokemon.append(MapPkm(name: "Heatmor", dexnum: "1"))
        self.pokemon.append(MapPkm(name: "Durant", dexnum: "2"))
        self.pokemon.append(MapPkm(name: "Deino", dexnum: "3"))
        self.pokemon.append(MapPkm(name: "Zweilous", dexnum: "4"))
        self.pokemon.append(MapPkm(name: "Hydreigon", dexnum: "5"))
        self.pokemon.append(MapPkm(name: "Larvesta", dexnum: "6"))
        self.pokemon.append(MapPkm(name: "Volcarona", dexnum: "7"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "8"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "9"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "0"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "1"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "2"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "3"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "4"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "5"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "6"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "7"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "8"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "9"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "0"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "1"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "2"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "3"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "4"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "5"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "6"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "7"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "8"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "9"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "0"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "1"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "2"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "3"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "4"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "5"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "6"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "7"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "8"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "9"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "0"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "1"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "2"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "3"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "4"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "5"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "6"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "7"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "8"))
//        self.pokemon.append(MapPkm(name: "", dexnum: "9"))
        
        
        self.pokemon.sort(by: {$0.name.compare($1.name) == .orderedAscending})
    }
    
    func AddPokemon()
    {
        print("adding pokemon")
        let location: CLLocationCoordinate2D = locationManager.location!.coordinate
        
        let db = Firestore.firestore()
        let collection = db.collection("pokemon")
        let doc = collection.document()
        let id = doc.documentID
        let createdAt = Date().timeIntervalSince1970 as NSNumber
        let lat = location.latitude
        let lon = location.longitude
        let timeToRemove = createdAt.doubleValue + Double(600)
        
        let values = ["id": id, "user": (Auth.auth().currentUser?.uid)!, "lat": lat as Any, "lon": lon as Any, "name": self.pokename, "cp": (self.cp as NSString).integerValue, "dexnum": self.dexnum, "sighted": createdAt, "timeToRemove": timeToRemove] as [String : Any]
        doc.setData(values)
        //show alert
        self.show.toggle()
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
