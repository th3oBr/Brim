//
//  BrimApp.swift
//  Brim
//
//  Created by Theo Bröll on 16.04.26.
//

import SwiftUI
import SwiftData

@main
struct BrimApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
            } else {
                OnboardingView()
            }
        }
        .modelContainer(for: [Transaction.self, Subscription.self])
    }
}
