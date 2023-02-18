//
//  Signup.swift
//  jamit
//
//  Created by Apple on 18/02/2023.
//

import SwiftUI
import AudioToolbox
import FirebaseAuth


struct SignupScreen: View {
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
                    self.signup()
                }label:{
                  Text("Signup")
                }
               
                
                
            }
            .alert(isPresented: $showAlertView) {
                Alert(title: Text(alertTitle),message:Text (alertMessage), dismissButton: .cancel())
            }
            .fullScreenCover(isPresented: $signupToggle, content: {
                   ContentView()
                    .environmentObject( audioRecorder)
        })
         .navigationTitle("SIGN UP")
        }
    }
        
        func signup() {
         
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    guard error == nil else {
                        self.alertTitle = "Uh-oh!"
                        self.alertMessage = (error!.localizedDescription)
                        self.showAlertView.toggle()
                        return
                        
                    }
                    print("User signed up!")
                    signupToggle = true
                    UserDefaults.standard.set(email, forKey: "email")
                }
           
            }
    
}
struct SignupScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignupScreen()
    }
}
