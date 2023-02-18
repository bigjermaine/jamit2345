//
//  ContentView.swift
//  jamit
//
//  Created by Apple on 17/02/2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var audioRecorder =  AudioRecorder2()
    var body: some View {
        TabView {
            HomeView()
                .environmentObject( audioRecorder)
            .tabItem {
            VStack{
            Text("Home")
           Image(systemName:"house.fill")
                    }
            }
            .tag(0)
            
         
            ProfileView()
                .environmentObject( audioRecorder)
            .tabItem {
            VStack{
            Text("person")
           Image(systemName:"person.fill")
                    }
            }
            .tag(1)
            
            
        }
        .accentColor(Color(hue: 0.897, saturation: 0.891, brightness: 0.924, opacity: 0.954))
       
        }
    }

 
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
