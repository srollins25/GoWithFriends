//
//  IsLoggedInView.swift
//  
//
//  Created by stephan rollins on 6/1/20.
//

import SwiftUI
import GoogleMobileAds
import SDWebImageSwiftUI

struct IsLoggedInView: View {
    @State var user = PokeUser(id: "", name: "", profileimage: "", email: "", user_posts: [String](), createdAt: 0, trainerId: "")
    @State var post: Post = Post(id: "", userID: "", name: "", trainerId: "", image: "", profileimage: "", postBody: "", comments: [String]() as NSArray, favorites: 0, createdAt: 0, parentPost: "", isReported: false)
    @State var index = 0
    @State var show = true
    @State var fromSearch = false
    @Binding var isLoggedIn: Bool
    @State var showCreatePost = false
    @State var parentPost = ""
    var pokemon = PokemonObserver()
    var raids = RaidObserver()
    var posts = PostObserver()
    @State var showDeleteView = false
    
    var body: some View{
        
        ZStack{
            
            NavigationView{
                
                TabBar(showCreatePost: self.$showCreatePost, showDeleteView: self.$showDeleteView, isLoggedIn: self.$isLoggedIn, index: self.$index, show: self.$show, fromSearch: self.$fromSearch, parentPost: self.$parentPost, user: self.$user ).environmentObject(posts).environmentObject(raids).environmentObject(pokemon)
            }.navigationViewStyle(StackNavigationViewStyle())
            
            if(self.showDeleteView == true)
            {
                DeleteAccountVerifyView(closeView: self.$showDeleteView, isLoggedIn: self.$isLoggedIn).offset(x: 0, y: self.showDeleteView ? 0 : UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.frame.height ?? 0) 
            }
        }

        .onAppear(perform: {
            
            if(UserDefaults.standard.string(forKey: "username") != nil || UserDefaults.standard.string(forKey: "username") != ""){
                self.createUser()
            }
        })
    }
    
    
    func createUser()
    {
        self.user.name = UserDefaults.standard.string(forKey: "username")!
        self.user.id = UserDefaults.standard.string(forKey: "userid")!
        self.user.profileimage = UserDefaults.standard.string(forKey: "image")!
    }
}

struct TabBar: View {
    
    @Binding var showCreatePost: Bool
    @Binding var showDeleteView: Bool
    @Binding var isLoggedIn: Bool
    @Binding var index: Int
    @Binding var show: Bool
    @Binding var fromSearch: Bool
    @Binding var parentPost: String
    @Binding var user: PokeUser
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var posts: PostObserver
    @EnvironmentObject var raids: RaidObserver
    @EnvironmentObject var pokemon: PokemonObserver
    @State var showSideMenu = false
    @State var showSearchBar = false
    @State var showNewMessage = false
    @State var chat = false
    @State var uid = ""
    @State var image = ""
    @State var name = ""
    @State var interstial: GADInterstitial!

    
    var body: some View{
        
        ZStack(alignment: .bottom){
            
            
            if(index == 0){
                HomeView(show: self.$showSideMenu, showSearchBar: self.$showSearchBar, isLoggedIn: self.$isLoggedIn, showDeleteView: self.$showDeleteView).environmentObject(posts)
                    .navigationBarTitle(Text("Home"))
                    .navigationBarItems(leading:   Button(action: {
                        self.showSideMenu.toggle()
                    }){
                        
                        AnimatedImage(url: URL(string: UserDefaults.standard.string(forKey: "image")!)).resizable().renderingMode(.original).aspectRatio(contentMode: .fill).frame(width: 35, height: 35).shadow(color: .gray, radius: 5, x: 1, y: 1).clipShape(Circle())
                        
                    }.accentColor(.white)
                        , trailing:
                        
                        NavigationLink(destination: SearchView(showDeleteView: self.$showDeleteView)){
                            Image(systemName: "magnifyingglass").resizable().frame(width: 30, height: 30).shadow(color: .gray, radius: 5, x: 1, y: 1).environmentObject(self.posts)
                        }.accentColor(.white))
            }
                
            else if(index == 1){
                MapView().environmentObject(pokemon).environmentObject(raids).navigationBarHidden(true)
            }
                
            Spacer()
            VStack{
                Spacer()
                
                
                if(self.index != 1)
                {
                    AdView().frame(width: 150, height: 60)
                }
                
                ZStack(alignment: .top)
                {
                    HStack(spacing: 0){
                        Button(action: {
                            self.index = 0
                        }){
                            
                            VStack{
                                Image(systemName: "globe").resizable().frame(width: 35, height: 35).foregroundColor(self.index == 0 ? Color.primary : Color.primary.opacity(0.25)).padding(.horizontal)
                                Text("Home").fontWeight(.light).font(.system(size: 10)).foregroundColor(self.index == 0 ? Color.primary : Color.primary.opacity(0.25)).padding(.horizontal)
                            }
                        }.padding(.leading, 30)
                        
                        Spacer(minLength: 0)
                        
                        Button(action: {
                            self.index = 1
                            if(self.interstial.isReady)
                            {
                                let root = UIApplication.shared.windows.first?.rootViewController
                                self.interstial.present(fromRootViewController: root!)
                            }
                            else{
                                print("not ready")
                            }
                        }){
                            VStack{
                                Image(systemName: "map").resizable().frame(width: 35, height: 35).foregroundColor(self.index == 1 ? Color.primary : Color.primary.opacity(0.25)).padding(.horizontal)
                                Text("Map").fontWeight(.light).font(.system(size: 10)).foregroundColor(self.index == 1 ? Color.primary : Color.primary.opacity(0.25)).padding(.horizontal)
                            }
                        }.padding(.trailing, 30)
                        
                        
                    }.padding(.horizontal)
                        .padding(.top)
                        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                        .background(self.scheme == .dark ? Color.black : Color.white)
                        .clipShape(ButtonCShape())
                        .shadow(color: Color.primary.opacity(0.08), radius: 5, x: 0, y: -5)

                    Button(action: {
                        self.showCreatePost.toggle()
                    }){
                        Image(systemName: "plus.circle.fill").resizable().frame(width: 40, height: 40).padding(10).background(Color.white).clipShape(Circle())
                    }.disabled(self.index == 1 ? true : false).offset(y: -29)
                        .sheet(isPresented: $showCreatePost) {
                            CreatePostView(closeView: self.$showCreatePost, parentPost: self.$parentPost)
                    }
                    
                }
            }.edgesIgnoringSafeArea(.bottom)
        }
    .onAppear(perform: {
        
        self.interstial = GADInterstitial(adUnitID: "ca-app-pub-9788435879014471/1618293373")
        let req = GADRequest()
        self.interstial.load(req)
        
    })
        
    }
}

struct ButtonCShape: Shape{
    
    func path(in rect: CGRect) -> Path{
        
        return Path{path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            
            path.addArc(center: CGPoint(x: rect.width / 2, y: 0), radius: 35, startAngle: .zero, endAngle: .init(degrees: 180), clockwise: false)
        }
        
    }
    
}

