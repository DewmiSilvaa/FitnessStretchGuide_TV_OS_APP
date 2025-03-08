//
//  FitnessStretchGuideApp.swift
//  FitnessStretchGuide
//
//  Created by Gimhan Rajapaksha on 2024-11-27.
//

import SwiftUI
import FirebaseCore
@main
struct FitnessStretchGuideApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
