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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Transaction.self, Subscription.self])
    }
}
