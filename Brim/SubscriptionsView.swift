import SwiftUI
import SwiftData

struct SubscriptionsView: View {
    @Binding var showAddSubscription: Bool

    @Query(sort: \Subscription.nextPaymentDate) private var subscriptions: [Subscription]

    var upcomingSubscriptions: [Subscription] {
        let calendar = Calendar.current
        let today = Date()
        if let nextWeek = calendar.date(byAdding: .day, value: 7, to: today) {
            return subscriptions.filter { $0.nextPaymentDate >= today && $0.nextPaymentDate <= nextWeek }
        }
        return []
    }

    var totalMonthlyFixedCost: Double {
        subscriptions.reduce(0) { total, sub in
            if sub.cycle == 0 { // Monthly
                return total + sub.amount
            } else { // Yearly
                return total + (sub.amount / 12)
            }
        }
    }
    
    let formatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "d"
            return f
        }()

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

                    // Summary Card
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("TOTAL MONTHLY FIXED COST")
                                    .font(.custom("Inter", size: 10).weight(.bold))
                                    .tracking(1)
                                    .opacity(0.8)
                                    .foregroundColor(Color.onPrimaryContainer)
                                HStack(alignment: .firstTextBaseline, spacing: 4) {
                                    Text("$").font(.custom("Inter", size: 14).weight(.medium)).opacity(0.8).foregroundColor(Color.onPrimaryContainer)
                                    Text(String(format: "%.2f", totalMonthlyFixedCost)).font(.custom("Inter", size: 32).weight(.black)).tracking(-0.5).foregroundColor(Color.onPrimary)
                                }
                            }
                            Spacer()
                        }
                        .padding(24)
                        .background(Color.primaryContainer)
                        .cornerRadius(16)
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
                            if upcomingSubscriptions.isEmpty {
                                Text("No subscriptions due soon.")
                                    .font(.custom("Inter", size: 14))
                                    .foregroundColor(Color.onSurfaceVariant)
                                    .padding(.vertical, 8)
                            } else {
                                ForEach(upcomingSubscriptions) { sub in
                                    let daysUntil = Calendar.current.dateComponents([.day], from: Date(), to: sub.nextPaymentDate).day ?? 0
                                    WarningCard(
                                        icon: sub.category == 0 ? "play.tv.fill" : "bolt.fill",
                                        title: sub.serviceName,
                                        subtext: "Due in \(daysUntil) days • \(sub.category == 0 ? "Entertainment" : "Software")",
                                        amount: String(format: "$%.2f", sub.amount),
                                        badge: daysUntil <= 2 ? "CRITICAL" : "UPCOMING"
                                    )
                                }
                            }
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
                            if subscriptions.isEmpty {
                                Text("No subscriptions found.")
                                    .font(.custom("Inter", size: 14))
                                    .foregroundColor(Color.onSurfaceVariant)
                            } else {
                                ForEach(subscriptions) { sub in
                                    let day = formatter.string(from: sub.nextPaymentDate)
                                    let nthDay = "\(day)\(daySuffix(from: day))"

                                    let (iconName, iColor, bColor): (String, Color, Color) = {
                                        let name = sub.serviceName.lowercased()
                                        
                                        switch name {
                                        case _ where name.contains("spotify"):
                                            return ("music.note", .secondary, .secondaryContainer.opacity(0.2))
                                            
                                        case _ where name.contains("icloud"):
                                            return ("cloud.fill", .primaryColor, .primaryContainer.opacity(0.1))
                                            
                                        case _ where name.contains("chatgpt"):
                                            return ("gearshape.fill", .onSurface, .surfaceContainerHighest)
                                            
                                        default:
                                            let icon = sub.category == 0 ? "play.tv.fill" : "bolt.fill"
                                            return (icon, .primaryColor, .primaryContainer.opacity(0.1))
                                        }
                                    }()
                                    SubscriptionRow(
                                        icon: iconName,
                                        iconColor: iColor,
                                        bgColor: bColor,
                                        title: sub.serviceName,
                                        subtext: "\(sub.cycle == 0 ? "Monthly" : "Yearly") • Renewing on \(nthDay)",
                                        amount: String(format: "$%.2f", sub.amount)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }

                    Spacer().frame(height: 200) // Space for persistent footer and bottom nav
                }
                .padding(.top, 100)
            }
            .background(Color.surface)

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
                    .padding(.bottom, 136)
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

func daySuffix(from dayString: String) -> String {
    if let day = Int(dayString) {
        switch day {
        case 11, 12, 13: return "th"
        default:
            switch day % 10 {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
            }
        }
    }
    return ""
}
