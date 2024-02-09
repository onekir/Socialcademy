//
//  SocialcademyApp.swift
//  Socialcademy
//
//  Created by Александр Кириченко on 03.05.2023.
//

import SwiftUI
import Firebase

@main
struct SocialcademyApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
}
