import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var spendType: Int = 0 // 0 = Variable, 1 = Fixed
    @Binding var showLogTransaction: Bool

    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]

    var dailyAllowance: Double = 120.0
    var monthlyBudget: Double = 3000.0

    var spentToday: Double {
        let calendar = Calendar.current
        return transactions.filter { calendar.isDateInToday($0.date) }.reduce(0) { $0 + $1.amount }
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
        return max(0, monthlyBudget - spentThisMonth)
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
                        Text(String(format: "$%.2f", availableToSpend))
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
                            Text(String(format: "$%.0f", max(0, dailyAllowance - spentToday)))
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
                            Text("You've spent **$\(String(format: "%.0f", spentToday))** of your $\(String(format: "%.0f", dailyAllowance)) daily limit. Great pace!")
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

                    // Transactions
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
                                    ForEach(transactions) { transaction in
                                        TransactionRow(
                                            icon: getIconForCategory(transaction.category),
                                            merchant: transaction.merchant,
                                            category: transaction.category,
                                            amount: String(format: "-$%.2f", transaction.amount)
                                        )
                                    }
                                }
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
                    Button(action: { showLogTransaction = true }) {
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
                    .padding(.bottom, 100)
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
                .foregroundColor(Color.onSurface)
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
