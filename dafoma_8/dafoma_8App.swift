//
//  dafoma_8App.swift
//  dafoma_8
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

@main
struct dafoma_8App: App {
    @StateObject private var dataManager = DataManager()
    @StateObject private var userPreferences = UserPreferences()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if userPreferences.hasCompletedOnboarding {
                    ContentView()
                        .environmentObject(dataManager)
                        .environmentObject(userPreferences)
                } else {
                    OnboardingView()
                        .environmentObject(userPreferences)
                }
            }
            .animation(.easeInOut(duration: 0.6), value: userPreferences.hasCompletedOnboarding)
        }
    }
}
