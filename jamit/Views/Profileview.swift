//
//  Profileview.swift
//  jamit
//
//  Created by Apple on 18/02/2023.
//

import SwiftUI
import FirebaseAuth

struct UpdateUserView: View {
    
    @AppStorage("UserName") var userName = "Username"
    @AppStorage("Twitter") var twitterHandle = "@TwitterHandle"
    @AppStorage("email") var eMailAdress = "user@domain.com"
    @AppStorage("Location") var location = "Location"
    @State private var  signoutToggle = false
    @State private var newUserName = ""
    @State private var newTwitterHandle = ""
    @State private var newEMail = ""
    @State private var newlocation = ""
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlertView: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Update user information:").font(.title2)
                HStack {
                    TextField("Username", text: $newUserName).textFieldStyle(.roundedBorder)
                    Button("Save") {
                        if newUserName.isEmpty == false {
                            userName = newUserName
                            newUserName = ""
                        }
                    }.buttonStyle(.bordered)
                }
                HStack {
                    TextField("Twitter", text: $newTwitterHandle).textFieldStyle(.roundedBorder)
                    Button("Save") {
                        if newTwitterHandle.isEmpty == false {
                            twitterHandle = newTwitterHandle
                            newTwitterHandle = ""
                        }
                    }.buttonStyle(.bordered)
                }
                HStack {
                    TextField("E-Mail", text: $newEMail).textFieldStyle(.roundedBorder).textInputAutocapitalization(.never)
                    Button("Save") {
                        if newEMail.isEmpty == false {
                            eMailAdress = newEMail
                            newEMail = ""
                        }
                    }.buttonStyle(.bordered)
                }
                HStack {
                    TextField("Loaction", text: $newlocation ).textFieldStyle(.roundedBorder).textInputAutocapitalization(.never)
                    Button("Save") {
                        if location.isEmpty == false {
                            location  =  newlocation
                            newlocation = ""
                        }
                    }.buttonStyle(.bordered)
                }
                
            }
            .fullScreenCover(isPresented: $signoutToggle, content: {
                signin()
            })
            .navigationTitle(Text("Profile"))
            .toolbar {
                
                Button {
                    
                    signout { sucess in
                        if  sucess  {
                    UserDefaults.standard.set(nil, forKey: "email")
                            
                        signoutToggle.toggle()
                        }else{
                            self.alertTitle = "Uh-oh!"
                            self.alertMessage = ("error signout")
                            self.showAlertView.toggle()
                            return
                        }
                    }
                    
                    
                    
                }label:{
                    Text("signout")
                }
            }
        }
    }
    func signout2() {
        try? Auth.auth().signOut()
        signoutToggle.toggle()
        
    }
  func signout( completion: @escaping (Bool)-> Void ){
        
        do {
            try  Auth.auth().signOut()
            completion(true)
        }catch{
            completion(false)
        }
        
    }
    
}
struct UpdateUserView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateUserView()
    }
}
