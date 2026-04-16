import SwiftUI

struct SubscriptionsView: View {
    @Binding var showAddSubscription: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 40) {

                    // Header Section
                    VStack(alignment: .leading, spacing: 4) {
                        Text("MANAGEMENT")
                            .font(.custom("Inter", size: 14).weight(.medium))
                            .tracking(0.5)
                            .foregroundColor(Color.onSurfaceVariant)
                        Text("Subscriptions")
                            .font(.custom("Inter", size: 36).weight(.heavy))
                            .tracking(-1)
                            .foregroundColor(Color.onSurface)
                    }
                    .padding(.horizontal, 24)

                    // Warning / Upcoming Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("DUE IN NEXT 7 DAYS")
                                .font(.custom("Inter", size: 14).weight(.bold))
                                .tracking(1)
                                .foregroundColor(Color.tertiaryContainer)
                            Spacer()
                            Capsule()
                                .fill(Color.tertiaryContainer)
                                .frame(width: 48, height: 4)
                        }
                        .padding(.horizontal, 24)

                        VStack(spacing: 16) {
                            WarningCard(
                                icon: "play.tv.fill",
                                title: "Netflix Premium",
                                subtext: "Due in 2 days • Entertainment",
                                amount: "$19.99",
                                badge: "CRITICAL"
                            )
                            WarningCard(
                                icon: "bolt.fill",
                                title: "Adobe Creative Cloud",
                                subtext: "Due in 5 days • Professional",
                                amount: "$54.99",
                                badge: "UPCOMING"
                            )
                        }
                        .padding(.horizontal, 24)
                    }

                    // All Subscriptions
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            Text("ALL SUBSCRIPTIONS")
                                .font(.custom("Inter", size: 14).weight(.bold))
                                .tracking(1)
                                .foregroundColor(Color.onSurfaceVariant)
                            Spacer()
                            Button("Sort by Date") { }
                                .font(.custom("Inter", size: 14).weight(.bold))
                                .foregroundColor(Color.primaryColor)
                        }
                        .padding(.horizontal, 24)

                        VStack(spacing: 12) {
                            SubscriptionRow(icon: "music.note", iconColor: Color.secondary, bgColor: Color.secondaryContainer.opacity(0.2), title: "Spotify Family", subtext: "Monthly • Renewing on 24th", amount: "$16.99")
                            SubscriptionRow(icon: "cloud.fill", iconColor: Color.primaryColor, bgColor: Color.primaryContainer.opacity(0.1), title: "iCloud+ 2TB", subtext: "Monthly • Renewing on 28th", amount: "$9.99")
                            SubscriptionRow(icon: "brain", iconColor: Color.onSurface, bgColor: Color.surfaceContainerHighest, title: "ChatGPT Plus", subtext: "Monthly • Renewing on 15th", amount: "$20.00")
                        }
                        .padding(.horizontal, 24)
                    }

                    Spacer().frame(height: 200) // Space for persistent footer and bottom nav
                }
                .padding(.top, 100)
            }
            .background(Color.surface)

            // Persistent Total Footer
            VStack {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("TOTAL MONTHLY FIXED COST")
                            .font(.custom("Inter", size: 10).weight(.bold))
                            .tracking(1)
                            .opacity(0.7)
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("$").font(.custom("Inter", size: 14).weight(.medium)).opacity(0.6)
                            Text("1,121.96").font(.custom("Inter", size: 24).weight(.black)).tracking(-0.5)
                        }
                    }
                    Spacer()
                    Text("WITHIN BUDGET")
                        .font(.custom("Inter", size: 11).weight(.bold))
                        .foregroundColor(Color.secondaryFixedDim)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.onSecondaryContainer.opacity(0.2))
                        .overlay(Capsule().stroke(Color.secondary.opacity(0.2), lineWidth: 1))
                        .clipShape(Capsule())
                }
                .padding(24)
                .background(
                    Color.inverseSurface.opacity(0.95)
                        .background(.ultraThinMaterial)
                )
                .foregroundColor(Color.inverseOnSurface)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.2), radius: 20, y: 10)
                .padding(.horizontal, 24)
                .padding(.bottom, 120) // Nav bar spacing
            }

            // FAB
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { showAddSubscription = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(Color.onPrimary)
                            .frame(width: 64, height: 64)
                            .background(
                                LinearGradient(colors: [Color.primaryColor, Color.primaryContainer], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .clipShape(Circle())
                            .shadow(color: Color.primaryColor.opacity(0.3), radius: 15, x: 0, y: 8)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 220)
                }
            }
        }
    }
}

struct WarningCard: View {
    var icon: String
    var title: String
    var subtext: String
    var amount: String
    var badge: String

    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.surfaceContainerHigh)
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(Color.tertiary)
                        .font(.system(size: 24))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Inter", size: 16).weight(.bold))
                    .foregroundColor(Color.onSurface)
                Text(subtext)
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(Color.onSurfaceVariant)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(amount)
                    .font(.custom("Inter", size: 20).weight(.bold))
                    .foregroundColor(Color.onSurface)
                Text(badge)
                    .font(.custom("Inter", size: 10).weight(.bold))
                    .foregroundColor(Color.tertiaryContainer)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.tertiaryFixed)
                    .clipShape(Capsule())
            }
        }
        .padding(20)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 15, y: 4)
        .overlay(
            HStack {
                Rectangle()
                    .fill(Color.tertiaryContainer)
                    .frame(width: 6)
                Spacer()
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
        )
    }
}

struct SubscriptionRow: View {
    var icon: String
    var iconColor: Color
    var bgColor: Color
    var title: String
    var subtext: String
    var amount: String

    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(bgColor)
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .font(.system(size: 24))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Inter", size: 16).weight(.semibold))
                    .foregroundColor(Color.onSurface)
                Text(subtext)
                    .font(.custom("Inter", size: 12))
                    .foregroundColor(Color.onSurfaceVariant)
            }

            Spacer()

            Text(amount)
                .font(.custom("Inter", size: 18).weight(.bold))
                .foregroundColor(Color.onSurface)
        }
        .padding(20)
        .background(Color.surfaceContainerLow)
        .cornerRadius(16)
    }
}
