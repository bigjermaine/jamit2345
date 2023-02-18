//
//  jamitApp.swift
//  jamit
//
//  Created by Apple on 17/02/2023.
//

import SwiftUI
import FirebaseCore


   
@main
struct jamitApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            signin()
        }
    }
    
}
