//
//  Signin.swift
//  jamit
//
//  Created by Apple on 18/02/2023.
//

import SwiftUI


import SwiftUI
import AudioToolbox
import FirebaseAuth


struct  signin: View {
    @ObservedObject var audioRecorder =  AudioRecorder2()
    @State private var showAlertView: Bool = false
    @State private var signupToggle: Bool = false
    @State var email  = ""
    @State var password  = ""
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    var body: some View {
     NavigationView {
            VStack (spacing:20){
                HStack{
                    Image(systemName: "mail")
                        .foregroundColor(.blue)
                    TextField("email", text: $email)
                }
                .autocapitalization(.none)
                .textContentType(.emailAddress)
                HStack{
                    Image(systemName: "key.viewfinder")
                        .foregroundColor(.red)
                    TextField("password", text: $password)
                }
                
                .autocapitalization(.none)
                .textContentType(.password)
                Button{
                    self.signin()
                }label:{
                  Text("Signin")
                }
                Button{
                    self.forgotpassword()
                }label:{
                  Text("password recovery")
                }
                NavigationLink(destination: SignupScreen()) {
                    Text("Signup Here!")
                }
            }
            .alert(isPresented: $showAlertView) {
                Alert(title: Text(alertTitle),message:Text (alertMessage), dismissButton: .cancel())
            }
            .fullScreenCover(isPresented: $signupToggle, content: {
                ContentView()
                    .environmentObject( audioRecorder)
        })
        }
     .navigationTitle("SIGN In")
    }
        
        func signin() {
     
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                guard error == nil else {
                    
                    alertTitle = "Uh-oh!"
                    alertMessage = (error!.localizedDescription)
                    showAlertView.toggle()
                    return
                }
                UserDefaults.standard.set(email, forKey: "email")
                        
               
                    signupToggle = true
                    print("User signed up!")
                }
            
        }
        func forgotpassword() {
            
            Auth.auth().sendPasswordReset(withEmail:email) { error in
            guard error == nil else {
                alertTitle = "Uh-oh!"
                alertMessage = (error!.localizedDescription)
                showAlertView.toggle()
                return
            }
            alertTitle = "passwordsent"
            alertMessage =  "check your email box"
            showAlertView.toggle()
          }
        }
    
}
struct  signin_Previews: PreviewProvider {
    static var previews: some View {
      signin()
    }
}
