//
//  MutedWordsView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 7/20/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import Firebase

struct MutedWordsView: View {
    
    @State var mutedArr = (UserDefaults.standard.array(forKey: "mutedWords")! as? [String])!
    @State var newWord = ""
    @State var showAlert = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                HStack{
                    
                    TextField("Add new word", text: self.$newWord).padding(.vertical, 12).padding(.horizontal).background(Color.black.opacity(0.06)).clipShape(Capsule())
                    Button(action: {
                        if(self.newWord.isBlank == true)
                        {
                            self.showAlert.toggle()
                        }
                        else
                        {
                           
                            //save locally

                            self.mutedArr.append(self.newWord)
                            UserDefaults.standard.set(self.mutedArr, forKey: "mutedWords")
                            //add to database
                            let uid = Auth.auth().currentUser?.uid
                            let db = Firestore.firestore()
                            let ref = Firestore.firestore().document("users/\(uid!)")
                            
                            ref.getDocument{ (snapshot, error) in
                                
                                let userRef = db.collection("users/").document("\(uid!)")
                                userRef.updateData(["mutedWords": FieldValue.arrayUnion([self.newWord])])
                                self.newWord = ""
                            }
                            
                        }
                        
                    }){
                        Text("Add")
                    }.alert(isPresented: self.$showAlert){
                        Alert(title: Text("Error"), message: Text("Cant add empty word"), dismissButton: .cancel())
                    }
                }.padding()
                
                List{
                    
                    ForEach(mutedArr, id: \.self){ word in
                        Text(word)
                    }.onDelete(perform: self.delete)
                }
            }
            .navigationBarTitle(Text("Muted Words"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }){
                Text("Cancel")
            })
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    func delete(at offsets: IndexSet) {

        self.mutedArr.remove(atOffsets: offsets)
        UserDefaults.standard.set(self.mutedArr, forKey: "mutedWords")
        
        let db = Firestore.firestore()
        let ref = db.collection("users").document((UserDefaults.standard.string(forKey: "userid"))!)
        ref.getDocument { (snap, error) in
            
            if(error != nil)
            {
                print((error?.localizedDescription)!)
                return
            }
            ref.updateData(["mutedWords": self.mutedArr])
        }
    }
}

struct MutedWordsView_Previews: PreviewProvider {
    static var previews: some View {
        MutedWordsView()
    }
}





