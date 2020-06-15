//
//  CreatePostView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 6/2/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import Firebase
import UIKit
import FirebaseFirestore
import SDWebImageSwiftUI

struct CreatePostView: View {
    
    @Binding var closeView: Bool
    @State var postText = ""
    @State var picker = false
    @State var picData: Data = .init(count: 0)
    @State var loading = false
    @Binding var parentPost: String
    
    var body: some View {
        
        
        VStack{
            PostNavBar(closeView: $closeView, postText: $postText, parentPost: $parentPost)
            multilineTextField(text: $postText).padding()
            Divider()
            Spacer().frame(height: UIScreen.main.bounds.height * 0.5)
            
        }
    }
}


struct multilineTextField: UIViewRepresentable{
    
    @Binding var text: String
    
    func makeCoordinator() -> multilineTextField.Coordinator {
        return multilineTextField.Coordinator(parent1: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<multilineTextField>) -> UITextView {
        let text = UITextView()
        text.isEditable = true
        text.isUserInteractionEnabled = true
        text.isScrollEnabled = true
        text.text = "Type message..."
        text.textColor = .gray
        text.font = .systemFont(ofSize: 20)
        text.delegate = context.coordinator
        return text
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<multilineTextField>) {
        
    }
    
    class Coordinator: NSObject, UITextViewDelegate{
        
        var parent: multilineTextField
        init(parent1: multilineTextField) {
            parent = parent1
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            print("did begin editing")
            if(textView.textColor == .gray)
            {
                textView.text = ""
            }
            textView.textColor = .black
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }
    
}


struct PostNavBar: View {
    
    @Binding var closeView: Bool
    @Binding var postText: String
    @Binding var parentPost: String
    
    var body: some View{
        
        ZStack{
            
            CustomNavBarBack()
            
            VStack(spacing: 0){
                HStack(spacing: 8){
                    Button(action: {
                        
                        withAnimation(.easeOut(duration: 0.5)){
                            self.closeView.toggle()
                        }
                    }){
                        Text("Cancel").foregroundColor(Color.black.opacity(0.5)).padding(9)
                    }
                    .background(Color.white)
                    .shadow(color: .gray, radius: 7, x: 1, y: 1)
                    .clipShape(Capsule())
                    Spacer()
                    
                    Button(action: {
                        
                        if(self.postText != "")
                        {
                            print("post text: ", self.postText)
                            self.createPost(postText: self.postText)
                        }
                    }){
                        Text("Post").foregroundColor(self.postText == "" ? Color.white.opacity(0.9) : Color.black.opacity(0.5) ).padding(9)
                    }
                    .disabled(self.postText == "" ? true : false)
                    .background(Color.white)
                    .shadow(color: .gray, radius: 7, x: 1, y: 1)
                    .clipShape(Capsule())
                }
                .padding(.top , (UIApplication.shared.windows.first?.safeAreaInsets.top)! )
                .padding(.horizontal)
                .padding(.bottom, 5)
                    
                .background(Color.black.opacity(0.3))
                
            }
        }
    }
    
    func createPost(postText: String)
    {
        let uid = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        let ref = Firestore.firestore().document("users/\(uid!)")
        
        ref.getDocument{ (snapshot, error) in
            
            guard let snapshot = snapshot, snapshot.exists else { return }
            let data = snapshot.data()
            let name = (data!["name"] as? String)!
            let profileimage = UserDefaults.standard.string(forKey: "image")!
            let parentPost = self.parentPost
            let createdAt = Date().timeIntervalSince1970 as NSNumber
            
            let values = ["userId": uid!, "name": name, "image": "", "profileimage": profileimage, "body": postText, "comments": [String]() as NSArray, "favorites": 0, "createdAt": createdAt, "parentPost": parentPost] as [String : Any]
            
            let collection = db.collection("posts")
            let doc = collection.document()
            let id = doc.documentID
            doc.setData(values)
            var userRef = db.collection("users/").document("\(uid!)")
            userRef.updateData(["user_posts": FieldValue.arrayUnion([id])])
            
            if(parentPost != "")
            {
                userRef = db.collection("posts/").document("\(parentPost)")
                userRef.updateData(["comments" : FieldValue.arrayUnion([id])])
            }
        }
        
        self.postText = ""
        withAnimation(.easeOut(duration: 0.5)){
            self.closeView.toggle()
        }
    }
    
    struct CustomNavBarBack: View {
        
        
        var body: some View{
            
            VStack(spacing: 0){
                HStack(spacing: 8){
                    
                    Text("")
                    Spacer()
                }
                .padding(.top , (UIApplication.shared.windows.first?.safeAreaInsets.top)! )
                .padding(.horizontal)
                .padding(.bottom, 5)
                    
                .background(Color.white)
            }
        }
    }
}

struct imagePicker: UIViewControllerRepresentable {
    
    
    @Binding var picker: Bool
    @Binding var picData: Data
    
    func makeCoordinator() -> imagePicker.Coordinator {
        
        return imagePicker.Coordinator(parent1: self)
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<imagePicker>) -> UIImagePickerController {
        
        let picker1 = UIImagePickerController()
        picker1.sourceType = .photoLibrary
        picker1.delegate = context.coordinator
        return picker1
        
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<imagePicker>) {
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: imagePicker
        
        init(parent1: imagePicker)
        {
            parent = parent1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.picker.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as! UIImage
            let picdata = image.jpegData(compressionQuality: 0.25)
            self.parent.picData = picdata!
            self.parent.picker.toggle()
        }
        
    }
    
}




















