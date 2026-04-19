import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var spendType: Int = 0 // 0 = Variable, 1 = Fixed
    @Binding var showLogTransaction: Bool
    @Binding var showAddSubscription: Bool

    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    @Query(sort: \Subscription.nextPaymentDate) private var subscriptions: [Subscription]
    @AppStorage("monthlyBudget") private var monthlyBudget: Double = 5000.0
    @AppStorage("currencySymbol") private var currencySymbol: String = "$"

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

    var adjustedMonthlyBudget: Double {
        return max(0, monthlyBudget - totalMonthlyFixedCost)
    }

    var spentToday: Double {
        let calendar = Calendar.current
        return transactions.filter { calendar.isDateInToday($0.date) }.reduce(0) { $0 + $1.amount }
    }

    var dailyAllowance: Double {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: Date())!
        let numDays = Double(range.count)
        return adjustedMonthlyBudget / numDays
    }

    var spentThisMonth: Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: Date())
        if let startOfMonth = calendar.date(from: components) {
            return transactions.filter { $0.date >= startOfMonth }.reduce(0) { $0 + $1.amount }
        }
        return 0
    }

    var availableToSpend: Double {
        return max(0, adjustedMonthlyBudget - spentThisMonth)
    }

    var dailySpentRatio: Double {
        return min(spentToday / dailyAllowance, 1.0)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 40) {
                // Hero Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Available to Spend")
                        .font(.custom("Inter", size: 16).weight(.medium))
                        .foregroundColor(Color.onSurfaceVariant)

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(String(format: "%@%.2f", currencySymbol, availableToSpend))
                            .font(.custom("Inter", size: 48).weight(.heavy))
                            .tracking(-1)
                            .foregroundColor(Color.onSurface)
                        Text("/ month")
                            .font(.custom("Inter", size: 16).weight(.medium))
                            .foregroundColor(Color.onSurfaceVariant)
                    }
                }
                .padding(.horizontal, 24)

                // Gauge Section
                HStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .stroke(Color.surfaceContainerHighest, lineWidth: 12)
                            .frame(width: 140, height: 140)

                        Circle()
                            .trim(from: 0, to: CGFloat(dailySpentRatio))
                            .stroke(
                                LinearGradient(colors: [Color.primaryColor, Color.primaryContainer], startPoint: .top, endPoint: .bottom),
                                style: StrokeStyle(lineWidth: 12, lineCap: .round)
                            )
                            .frame(width: 140, height: 140)
                            .rotationEffect(.degrees(-90))

                        VStack(spacing: 0) {
                            Text(String(format: "%@%.0f", currencySymbol, max(0, dailyAllowance - spentToday)))
                                .font(.custom("Inter", size: 30).weight(.bold))
                                .foregroundColor(Color.onSurface)
                            Text("LEFT TODAY")
                                .font(.custom("Inter", size: 10).weight(.bold))
                                .tracking(1)
                                .foregroundColor(Color.onSurfaceVariant)
                        }
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Daily Allowance")
                                .font(.custom("Inter", size: 20).weight(.bold))
                                .tracking(-0.5)
                            Text("You've spent **\(currencySymbol)\(String(format: "%.0f", spentToday))** of your \(currencySymbol)\(String(format: "%.0f", dailyAllowance)) daily limit. Great pace!")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(Color.onSurfaceVariant)
                                .lineLimit(3)
                        }

                        HStack(spacing: 8) {
                            Image(systemName: spentToday > dailyAllowance ? "exclamationmark.circle.fill" : "checkmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(spentToday > dailyAllowance ? Color.onErrorContainer : Color.onSecondaryContainer)
                            Text(spentToday > dailyAllowance ? "OVER BUDGET" : "UNDER BUDGET")
                                .font(.custom("Inter", size: 12).weight(.bold))
                                .tracking(0.5)
                                .foregroundColor(spentToday > dailyAllowance ? Color.onErrorContainer : Color.onSecondaryContainer)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(spentToday > dailyAllowance ? Color.errorContainer : Color.secondaryContainer)
                        .cornerRadius(20)
                    }
                }
                .padding(24)
                .background(Color.surfaceContainerLow)
                .cornerRadius(24)
                .padding(.horizontal, 24)

                // Segmented Control & List
                VStack(spacing: 24) {
                    // Segmented Control
                    HStack(spacing: 0) {
                        Button(action: { spendType = 0 }) {
                            Text("Variable")
                                .font(.custom("Inter", size: 14).weight(spendType == 0 ? .bold : .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .foregroundColor(spendType == 0 ? Color.primaryColor : Color.onSurfaceVariant)
                                .background(spendType == 0 ? Color.surfaceContainerLowest : Color.clear)
                                .cornerRadius(20)
                                .shadow(color: spendType == 0 ? Color.black.opacity(0.05) : Color.clear, radius: 2, y: 1)
                        }

                        Button(action: { spendType = 1 }) {
                            Text("Fixed")
                                .font(.custom("Inter", size: 14).weight(spendType == 1 ? .bold : .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .foregroundColor(spendType == 1 ? Color.primaryColor : Color.onSurfaceVariant)
                                .background(spendType == 1 ? Color.surfaceContainerLowest : Color.clear)
                                .cornerRadius(20)
                                .shadow(color: spendType == 1 ? Color.black.opacity(0.05) : Color.clear, radius: 2, y: 1)
                        }
                    }
                    .padding(4)
                    .background(Color.surfaceContainerHigh)
                    .cornerRadius(24)
                    .frame(maxWidth: 300)
                    .padding(.horizontal, 24)

                    // Transactions / Subscriptions content
                    if spendType == 0 {
                        VStack(spacing: 24) {
                            if transactions.isEmpty {
                                Text("No transactions yet.")
                                    .font(.custom("Inter", size: 16))
                                    .foregroundColor(Color.onSurfaceVariant)
                                    .padding()
                            } else {
                                // Simplify to a single list of recent transactions for now
                                VStack(spacing: 12) {
                                    HStack {
                                        Text("RECENT")
                                            .font(.custom("Inter", size: 12).weight(.bold))
                                            .tracking(1)
                                            .foregroundColor(Color.onSurfaceVariant)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 8)

                                    VStack(spacing: 12) {
                                        ForEach(transactions.filter { $0.isFixed == false }.prefix(10)) { transaction in
                                            let isIncome = transaction.amount < 0
                                            let displayAmount = abs(transaction.amount)
                                            let prefix = isIncome ? "+" : "-"
                                            let textColor = isIncome ? Color.primaryColor : Color.onSurface
                                            TransactionRow(
                                                icon: getIconForCategory(transaction.category),
                                                merchant: transaction.merchant,
                                                category: transaction.category,
                                                amount: String(format: "%@%@%.2f", prefix, currencySymbol, displayAmount),
                                                amountColor: textColor
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    } else {
                        // Fixed (Subscriptions)
                        VStack(spacing: 32) {
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
                                                amount: String(format: "%@%.2f", currencySymbol, sub.amount),
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
                                                amount: String(format: "%@%.2f", currencySymbol, sub.amount)
                                            )
                                        }
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }

                HStack(alignment: .center) {
                        VStack(alignment: .leading){
                            Text("SAVING TREND")
                                .font(.custom("Inter", size: 10).weight(.bold))
                                .tracking(1)
                                .opacity(0.8)
                            Text("12% Down")
                                .font(.custom("Inter", size: 24).weight(.black))
                                .padding(.vertical, 2)
                            Text("vs last month")
                                .font(.custom("Inter", size: 12))
                                .opacity(0.8)
                        }
                        Spacer()
                        Image(systemName: "arrow.down.right")
                            .font(.system(size: 32))
                            .padding(.bottom, 16)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(24)
                    .background(Color.primaryContainer)
                    .foregroundColor(Color.onPrimaryContainer)
                    .cornerRadius(24)
                    .padding(.horizontal, 24)

                Spacer().frame(height: 140) // Bottom Nav spacing
            }
            .padding(.top, 100) // Top App bar spacing
        }
        .background(Color.surface)
        .overlay(
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        if spendType == 0 {
                            showLogTransaction = true
                        } else {
                            showAddSubscription = true
                        }
                    }) {
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
        )
    }
}

struct TransactionRow: View {
    var icon: String
    var merchant: String
    var category: String
    var amount: String
    var amountColor: Color = Color.onSurface

    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.surfaceContainer)
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(Color.primaryColor)
                        .font(.system(size: 20))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(merchant)
                    .font(.custom("Inter", size: 16).weight(.medium))
                    .foregroundColor(Color.onSurface)
                Text(category)
                    .font(.custom("Inter", size: 12))
                    .foregroundColor(Color.onSurfaceVariant)
            }

            Spacer()

            Text(amount)
                .font(.custom("Inter", size: 16).weight(.bold))
                .foregroundColor(amountColor)
        }
        .padding(16)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.02), radius: 10, y: 4)
    }
}

func getIconForCategory(_ category: String) -> String {
    switch category {
    case "Dining & Drinks": return "cup.and.saucer.fill"
    case "Groceries": return "bag.fill"
    case "Transport": return "tram.fill"
    case "Shopping": return "cart.fill"
    case "Entertainment": return "play.tv.fill"
    default: return "dollarsign.circle.fill"
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
