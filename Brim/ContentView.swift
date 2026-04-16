import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @State private var showLogTransaction: Bool = false
    @State private var showAddSubscription: Bool = false

    var body: some View {
        ZStack {
            // Main Content Area
            Group {
                switch selectedTab {
                case .home:
                    HomeView(showLogTransaction: $showLogTransaction)
                case .analytics:
                    AnalyticsView()
                        .padding(.top, 64) // Make room for the TopAppBar
                case .subscriptions:
                    SubscriptionsView(showAddSubscription: $showAddSubscription)
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Fixed Top App Bar for Analytics & Settings (since Home/Subs have their own custom scrolling or specific headers in the designs, though the reference shows top app bars for all. We'll add it globally or per view. Settings has a top bar. Home has one. Subscriptions has one.)
            // Actually, based on designs, all screens have a top app bar.
            // HomeView and SettingsView have `Brim` and `Settings` respectively.
            // SubscriptionsView has `Brim` too.
            // Let's place a global TopAppBar for the screens that don't embed it (Home and Subs designs show 'Brim' and 'Settings').

            VStack {
                if selectedTab == .home || selectedTab == .subscriptions || selectedTab == .analytics {
                    TopAppBar(title: "Brim")
                } else if selectedTab == .settings {
                    TopAppBar(title: "Settings")
                }
                Spacer()
            }

            // Custom Tab Bar Overlay
            VStack {
                Spacer()
                BottomNavBar(selectedTab: $selectedTab)
            }
        }
        .fullScreenCover(isPresented: $showLogTransaction) {
            LogTransactionView()
        }
        .fullScreenCover(isPresented: $showAddSubscription) {
            AddSubscriptionView()
        }
        .edgesIgnoringSafeArea(.bottom) // Let BottomNavBar handle its own safe area
    }
}

#Preview {
    ContentView()
}
