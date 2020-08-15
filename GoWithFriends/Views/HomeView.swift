//
//  HomeView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 4/8/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//  .padding(.top, (UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.safeAreaInsets.top)!)

import SwiftUI
import Firebase
import FirebaseFirestore
import SDWebImageSwiftUI
import GoogleMobileAds


struct HomeView: View {
    
    @EnvironmentObject var postsObserver: PostObserver
    @Binding var show: Bool
    @State var showPostThread = false
    @State var shouldFetch = false
    @Binding var showSearchBar: Bool
    @State var searchtxt = ""
    @State var post: Post = Post(id: "", userID: "", name: "", trainerId: "", image: "", profileimage: "", postBody: "", comments: [String]() as NSArray, favorites: 0, createdAt: 0, parentPost: "", isReported: false)
    @State var subParentPost = Post(id: "", userID: "", name: "", trainerId: "", image: "", profileimage: "", postBody: "", comments: [String]() as NSArray, favorites: 0, createdAt: 0, parentPost: "", isReported: false)
    @Binding var isLoggedIn: Bool
    @State var favpic = Image(systemName: "star")
    @State var isFavorite = false
    @State var isSubFavorite = false
    @State var needRefresh: Bool = false
    @State var showLoading = false
    @Binding var showDeleteView: Bool
    @State var comments = CommentsObserver(parentPost_: "")
    
    var body: some View {
        
        ZStack{
            ZStack(alignment: .bottomTrailing){
                
                VStack{
                    List{
                        if(postsObserver.posts.isEmpty)
                        {
                            Text("No posts").fontWeight(.heavy)
                        }
                            
                        else
                        {
                            ForEach(postsObserver.posts.reversed()){ post in
                                
                                ZStack{
                                    
                                    if(post.isReported == false)
                                    {
                                        PostCell(id: post.id, user: post.userID, name: post.name, trainerId: post.trainerId, image: post.image, profileimage: post.profileimage, postBody: post.postBody, comments: post.comments, favorites: post.favorites, createdAt:  post.createdAt, parentPost: post.parentPost, isFavorite: self.$isFavorite, showDeleteView: self.$showDeleteView).environmentObject(self.postsObserver)
                                    }
                                    else
                                    {
                                        ReportedPostCell(id: post.id, user: post.userID, name: post.name, trainerId: post.trainerId, image: post.image, profileimage: post.profileimage, comments: post.comments, favorites: post.favorites, createdAt: post.createdAt, parentPost: post.parentPost, isFavorite: self.$isFavorite, showDeleteView: self.$showDeleteView).environmentObject(self.postsObserver)
                                    }
                                    
                                    
                                    
                                    NavigationLink(destination: PostThreadView(mainPost: self.$post, subParentPost: self.$subParentPost, showDeleteView: self.$showDeleteView).environmentObject(self.comments)){
                                        
                                        EmptyView()
                                    }
                                    
                                    Button(action: {
                                        self.post = post
                                        
                                        UserDefaults.standard.set(post.id, forKey: "parentPost")
                                        self.comments = CommentsObserver(parentPost_: UserDefaults.standard.string(forKey: "parentPost")!)
                                    }){
                                        Text("")
                                    }
                                }
                            }
                        }
                    }.padding(.bottom, 120)
                }
                
                GeometryReader{_ in
                    
                    HStack{
                        SideMenu(isLoggedIn: self.$isLoggedIn, showLoading: self.$showLoading, showDeleteView: self.$showDeleteView).environmentObject(self.postsObserver).offset(x: self.show ? 0 : -UIScreen.main.bounds.width)
                            .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6))
                        Spacer()
                    }
                }.background(Color.black.opacity(self.show ? 0.5 : 0)).edgesIgnoringSafeArea(.bottom)
                    .onTapGesture {
                        self.show.toggle()
                }
            }
            
            if(self.showLoading == true)
            {
                GeometryReader{_ in
                    
                    LoaderView()
                    
                }.background(Color.clear)
            }
        }
            
        .onAppear(perform: {
            
            if(self.shouldFetch == false){
                
                self.shouldFetch = true
            }
        })
    }
}


struct SideMenu: View {
    
    @Binding var isLoggedIn: Bool
    @State var showSupport = false
    @State var showProfile = false
    @Binding var showLoading: Bool
    @Binding var showDeleteView: Bool//final delete screen
    @State var user: PokeUser = PokeUser(id: UserDefaults.standard.string(forKey: "userid")!, name: UserDefaults.standard.string(forKey: "username")!, profileimage: UserDefaults.standard.string(forKey: "image")!, email: "", user_posts: [String](), createdAt: 0, trainerId:  UserDefaults.standard.string(forKey: "trainerId")!)
    @EnvironmentObject var passedPosts: PostObserver
    
    
    var body: some View {
        
        VStack(spacing: 25){

                Button(action: {
                    self.showProfile.toggle()
                }){
                    VStack(spacing: 8){
//                        Image(systemName: "person").renderingMode(.original).resizable().frame(width: 25, height: 25)
                        
                        AnimatedImage(url: URL(string: UserDefaults.standard.string(forKey: "image")!)).resizable().renderingMode(.original).aspectRatio(contentMode: .fill).frame(width: 35, height: 35).shadow(color: .gray, radius: 5, x: 1, y: 1).clipShape(Circle())
                        Text("Profile")
                         
                    }
                }.sheet(isPresented: self.$showProfile)
                {
                    NavigationView{
                        ProfileView(user: self.$user, show: self.$showProfile, isLoggedIn: self.$isLoggedIn, showDeleteView: self.$showDeleteView).environmentObject(self.passedPosts)
                            .navigationBarTitle(Text(self.user.name), displayMode: .inline)
                            /*.navigationBarItems(leading: Button(action: {
                                
                                self.showProfile.toggle()
                            }){
                                Text("Done")
                            })*/
                    }.navigationViewStyle(StackNavigationViewStyle())
            }

            Button(action: {
                self.showSupport.toggle()
            }){
                VStack(spacing: 8){
                    Image(systemName: "questionmark.circle").renderingMode(.original).resizable().frame(width: 25, height: 25)
                    Text("Support")
                }
            }.sheet(isPresented: self.$showSupport){
                SupportView(closeView: self.$showSupport)
            }
            

            Button(action: {
                self.showLoading.toggle()
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
                    
                    do{
                        
                        try Auth.auth().signOut()
                    }
                    catch{
                        print("Problem signing out.")
                    }
                    
                    let ref = Firestore.firestore().collection("users").document(UserDefaults.standard.string(forKey: "userid")!)
                    UserDefaults.standard.set("", forKey: "username")
                    UserDefaults.standard.set("", forKey: "image")
                    UserDefaults.standard.set("", forKey: "userid")
                    UserDefaults.standard.set("", forKey: "email")
                    UserDefaults.standard.set("", forKey: "trainerId")
                    let emptyArr = [String]()
                    UserDefaults.standard.set(emptyArr, forKey: "favorites")
                    UserDefaults.standard.set([String](), forKey: "friends")
                    self.showLoading.toggle()
                    self.isLoggedIn.toggle()
                    UserDefaults.standard.set(self.isLoggedIn, forKey: "isloggedin")
                    
                    ref.setData(["isOnline": false])
                }
                
            }){
                VStack(spacing: 8){
                    Image(systemName: "escape").renderingMode(.original).resizable().frame(width: 25, height: 25)
                    Text("Log out").foregroundColor(.red)
                }
            }
            
            Spacer(minLength: 15)
            Spacer()
            
        }.padding(12)
            .foregroundColor(.black)
            .background(Color("sidemenucolor"))
            .cornerRadius(16)
        
    }
}

struct AdView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<AdView>) ->  GADBannerView {
        let banner = GADBannerView(adSize: kGADAdSizeBanner)
        banner.adUnitID = "ca-app-pub-9788435879014471/4288086107"
        // ca-app-pub-3659675992750002~2083157801 ca-app-pub-3659675992750002/5447687740
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        return banner
    }
    
    func updateUIView(_ uiView: GADBannerView, context: UIViewRepresentableContext<AdView>) {
        
    }
}

//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
















