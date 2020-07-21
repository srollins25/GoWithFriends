//
//  ReportUserView.swift
//  GoWithFriends
//
//  Created by stephan rollins on 7/19/20.
//  Copyright © 2020 OmniStack. All rights reserved.
//

import SwiftUI
import Firebase

struct ReportUserView: View {
    
    @Binding var userId: String
    @Binding var showReportButton: Bool
    @State var reportText = ""
    @State var showAlert = false
    @State var showConfirmAlert = false
    @State var message = ""
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        ZStack{
            Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)
            VStack{
                Text("Report an issue").foregroundColor(self.scheme == .dark ? Color.white : Color.black).font(.title).fontWeight(.bold).padding(.top, 10).padding(.bottom, 20)

                Text("Describe the problem with this user.").foregroundColor(self.scheme == .dark ? Color.white : Color.black)
                multilineTextField(text: $reportText).padding()
                Divider()
                Button(action: {
                    
                    if(self.reportText == "")
                    {
                        self.showAlert.toggle()
                    }
                    else
                    {
                        
                        self.sendReport(postId: self.userId, text: self.reportText)
                        self.showConfirmAlert.toggle()
                    }
                    
                }){
                    Text("Send report").foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color.green.opacity(0.8))
                    .clipShape(Capsule())
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
                }.disabled(self.reportText == "" || self.reportText == " " ? true : false).alert(isPresented: self.$showAlert){
                    

                        Alert(title: Text("Report Sent"), message: Text(self.message), dismissButton: .default(Text("Done")))
                    
                    
                }
                Spacer().frame(height: UIScreen.main.bounds.height * 0.5)
            }
            
            Spacer()
        }
        
        
            
        .onDisappear(perform: {
            withAnimation(.spring()){
                self.showReportButton.toggle()
            }
        })
    }
    
    func sendReport(postId: String, text: String)
    {
        let db = Firestore.firestore()
        let collection = db.collection("reports")
        let doc = collection.document()
        let createdAt = Date().timeIntervalSince1970 as NSNumber
        
        let values = ["userId": postId, "report": text, "createdAt": createdAt] as [String : Any]
        
        doc.setData(values){ err in
            if let err = err {
                
                self.message = err.localizedDescription
                self.showAlert.toggle()
            } else {
                self.message = "Your report has been sent and will be reviewed."
                self.showAlert.toggle()
                self.reportText = ""
                
            }
        }
        
    }
}

//struct ReportUserView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportUserView()
//    }
//}
