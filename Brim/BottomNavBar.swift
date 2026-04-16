import SwiftUI

enum Tab: String, CaseIterable {
    case home = "Home"
    case analytics = "Analytics"
    case subscriptions = "Subscriptions"
    case settings = "Settings"

    var iconName: String {
        switch self {
        case .home: return "house"
        case .analytics: return "chart.bar"
        case .subscriptions: return "doc.plaintext"
        case .settings: return "gearshape"
        }
    }
}

struct BottomNavBar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        HStack () {
            ForEach(Tab.allCases, id: \.self) { tab in
                Spacer()
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab == selectedTab ? tab.iconName + ".fill" : tab.iconName)
                            .font(.system(size: 24))
                        Text(tab.rawValue.uppercased())
                            .font(.custom("Inter", size: 10).weight(tab == selectedTab ? .bold : .medium))
                            .tracking(0.5)
                    }
                    .foregroundColor(tab == selectedTab ? Color.primaryColor : Color.outline)
                    .padding(.vertical, 6)
                    .padding(.horizontal, tab == selectedTab ? 16 : 8)
                    .background(
                        tab == selectedTab ?
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.primaryColor.opacity(0.1))
                        : RoundedRectangle(cornerRadius: 16).fill(Color.clear)
                    )
                }
                Spacer()
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 32) // safe area spacing
        .padding(.horizontal, 20)
        .background(
            Color.surfaceBright.opacity(0.8)
                .background(.ultraThinMaterial)
                .clipShape(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 40, x: 0, y: -10)
        )
        .edgesIgnoringSafeArea(.bottom)
    }
}
