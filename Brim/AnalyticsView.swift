import SwiftUI
import SwiftData

struct AnalyticsView: View {
    @Query(sort: \Transaction.date, order: .reverse) private var allTransactions: [Transaction]
    @AppStorage("monthlyBudget") private var monthlyBudget: Double = 5000.0

    @State private var selectedMonth: Date = Date()

    var transactionsForMonth: [Transaction] {
        let calendar = Calendar.current
        return allTransactions.filter { calendar.isDate($0.date, equalTo: selectedMonth, toGranularity: .month) }
    }

    var transactionsForLastMonth: [Transaction] {
        let calendar = Calendar.current
        guard let lastMonth = calendar.date(byAdding: .month, value: -1, to: selectedMonth) else { return [] }
        return allTransactions.filter { calendar.isDate($0.date, equalTo: lastMonth, toGranularity: .month) }
    }

    var spentThisMonth: Double {
        transactionsForMonth.reduce(0) { $0 + $1.amount }
    }

    var spentLastMonth: Double {
        transactionsForLastMonth.reduce(0) { $0 + $1.amount }
    }

    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("PORTFOLIO PERFORMANCE")
                            .font(.custom("Inter", size: 11).weight(.bold))
                            .tracking(2.0)
                            .foregroundColor(Color.onSurfaceVariant)
                        Spacer()

                        // Month Picker logic (simplified to prev/next for clean UI)
                        HStack(spacing: 16) {
                            Button(action: { selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) ?? selectedMonth }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(Color.primaryColor)
                            }

                            Text(monthFormatter.string(from: selectedMonth).uppercased())
                                .font(.custom("Inter", size: 12).weight(.bold))
                                .foregroundColor(Color.onSurface)

                            Button(action: { selectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) ?? selectedMonth }) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.primaryColor)
                            }
                        }
                    }

                    Text("Analytics")
                        .font(.custom("Inter", size: 40).weight(.black))
                        .foregroundColor(Color.onSurface)
                        .tracking(-1.0)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Vs Last Month Card
                VsLastMonthCard(spentThisMonth: spentThisMonth, spentLastMonth: spentLastMonth)
                    .padding(.horizontal, 24)

                // Cumulative Spend Card
                CumulativeSpendCard(spentThisMonth: spentThisMonth, monthlyBudget: monthlyBudget, selectedMonth: selectedMonth)
                    .padding(.horizontal, 24)

                // Top Categories Card
                TopCategoriesCard(transactions: transactionsForMonth, totalSpent: spentThisMonth)
                    .padding(.horizontal, 24)

                // Smart Prediction Card
                SmartPredictionCard(spentThisMonth: spentThisMonth, spentLastMonth: spentLastMonth)
                    .padding(.horizontal, 24)

                // Unusual Activity Section
                UnusualActivitySection(transactions: transactionsForMonth)
                    .padding(.horizontal, 24)

                Spacer(minLength: 120) // For BottomNavBar spacing
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }
}

// MARK: - Subviews

struct VsLastMonthCard: View {
    var spentThisMonth: Double
    var spentLastMonth: Double

    var difference: Double {
        spentThisMonth - spentLastMonth
    }

    var percentage: Double {
        if spentLastMonth == 0 { return 0 }
        return (abs(difference) / spentLastMonth) * 100
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("VS LAST MONTH")
                    .font(.custom("Inter", size: 11).weight(.bold))
                    .foregroundColor(Color.onSurfaceVariant)

                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text(String(format: "%@$%.2f", difference > 0 ? "+" : "", difference))
                        .font(.custom("Inter", size: 28).weight(.bold))
                        .foregroundColor(Color.onSurface)

                    if spentLastMonth > 0 {
                        HStack(spacing: 2) {
                            Image(systemName: difference > 0 ? "arrow.up" : "arrow.down")
                                .font(.system(size: 10, weight: .bold))
                            Text(String(format: "%.1f%%", percentage))
                                .font(.custom("Inter", size: 14).weight(.bold))
                        }
                        .foregroundColor(difference > 0 ? Color.errorContainer : Color.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background((difference > 0 ? Color.errorContainer : Color.secondary).opacity(0.1))
                        .cornerRadius(12)
                    }
                }
            }
            Spacer()

            // Icon
            Circle()
                .fill(Color.primaryColor.opacity(0.05))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 20))
                        .foregroundColor(Color.primaryColor)
                )
        }
        .padding(20)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.03), radius: 20, x: 0, y: 10)
    }
}

struct CumulativeSpendCard: View {
    var spentThisMonth: Double
    var monthlyBudget: Double
    var selectedMonth: Date

    var dailyAvg: Double {
        let calendar = Calendar.current

        let isCurrentMonth = calendar.isDate(Date(), equalTo: selectedMonth, toGranularity: .month)

        if isCurrentMonth {
            let currentDay = calendar.component(.day, from: Date())
            return spentThisMonth / Double(currentDay == 0 ? 1 : currentDay)
        } else {
            let range = calendar.range(of: .day, in: .month, for: selectedMonth)!
            let numDays = Double(range.count)
            return spentThisMonth / numDays
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Cumulative\nSpend")
                        .font(.custom("Inter", size: 22).weight(.bold))
                        .foregroundColor(Color.onSurface)

                    Text("Real-time tracking\nagainst $\(String(format: "%.0f", monthlyBudget)) monthly\ngoal")
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(Color.onSurfaceVariant)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 8) {
                    HStack(spacing: 6) {
                        Circle().fill(Color.primaryColor).frame(width: 8, height: 8)
                        Text("ACTUAL")
                            .font(.custom("Inter", size: 10).weight(.bold))
                            .foregroundColor(Color.onSurfaceVariant)
                    }
                    HStack(spacing: 6) {
                        Circle().fill(Color.outlineVariant).frame(width: 8, height: 8)
                        Text("BUDGET")
                            .font(.custom("Inter", size: 10).weight(.bold))
                            .foregroundColor(Color.onSurfaceVariant)
                    }
                }
            }

            // Chart Placeholder
            GeometryReader { geo in
                ZStack {
                    // Dashed line for budget
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: geo.size.height * 0.8))
                        path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height * 0.2))
                    }
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
                    .foregroundColor(Color.outlineVariant)

                    // Solid line for actual
                    Path { path in
                        let w = geo.size.width
                        let h = geo.size.height
                        path.move(to: CGPoint(x: 0, y: h * 0.85))
                        path.addQuadCurve(to: CGPoint(x: w * 0.2, y: h * 0.7), control: CGPoint(x: w * 0.1, y: h * 0.8))
                        path.addQuadCurve(to: CGPoint(x: w * 0.4, y: h * 0.55), control: CGPoint(x: w * 0.3, y: h * 0.6))
                        path.addQuadCurve(to: CGPoint(x: w * 0.6, y: h * 0.55), control: CGPoint(x: w * 0.5, y: h * 0.45))
                        path.addQuadCurve(to: CGPoint(x: w * 0.8, y: h * 0.4), control: CGPoint(x: w * 0.7, y: h * 0.65))
                        path.addQuadCurve(to: CGPoint(x: w, y: h * 0.2), control: CGPoint(x: w * 0.9, y: h * 0.25))
                    }
                    .stroke(Color.primaryColor, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))

                    // Tooltip
                    VStack {
                        Text("OCT 24")
                            .font(.custom("Inter", size: 9).weight(.bold))
                            .foregroundColor(Color.onSurfaceVariant)
                        Text("$3,240.12")
                            .font(.custom("Inter", size: 14).weight(.black))
                            .foregroundColor(Color.onSurface)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.surfaceContainerLowest)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                    .position(x: geo.size.width * 0.6, y: geo.size.height * 0.35)
                }
            }
            .frame(height: 180)
            .padding(.vertical, 16)

            // Metrics
            HStack(spacing: 0) {
                VStack(spacing: 4) {
                    Text("CURRENT")
                        .font(.custom("Inter", size: 10).weight(.bold))
                        .foregroundColor(Color.onSurfaceVariant)
                    Text(String(format: "$%.0f", spentThisMonth))
                        .font(.custom("Inter", size: 18).weight(.bold))
                        .foregroundColor(Color.onSurface)
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 4) {
                    Text("REMAINING")
                        .font(.custom("Inter", size: 10).weight(.bold))
                        .foregroundColor(Color.onSurfaceVariant)
                    Text(String(format: "$%.0f", max(0, monthlyBudget - spentThisMonth)))
                        .font(.custom("Inter", size: 18).weight(.bold))
                        .foregroundColor(Color.secondary)
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 4) {
                    Text("DAILY AVG")
                        .font(.custom("Inter", size: 10).weight(.bold))
                        .foregroundColor(Color.onSurfaceVariant)
                    Text(String(format: "$%.0f", dailyAvg))
                        .font(.custom("Inter", size: 18).weight(.bold))
                        .foregroundColor(Color.onSurface)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(24)
        .background(Color.surfaceContainerLow)
        .cornerRadius(24)
    }
}

struct TopCategoriesCard: View {
    var transactions: [Transaction]
    var totalSpent: Double

    var categoryTotals: [(String, Double)] {
        var totals: [String: Double] = [:]
        for t in transactions {
            totals[t.category, default: 0] += t.amount
        }
        return totals.sorted { $0.value > $1.value }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Top Categories")
                    .font(.custom("Inter", size: 20).weight(.bold))
                    .foregroundColor(Color.onSurface)

                Text("Where your money flows.")
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(Color.onSurfaceVariant)
            }

            // Simplified Real Donut Chart mapping top 3 categories
            ZStack {
                Circle()
                    .stroke(Color.surfaceContainerHigh, lineWidth: 24)
                    .frame(width: 160, height: 160)

                if totalSpent > 0 && categoryTotals.count > 0 {
                    let cat1Ratio = categoryTotals.count > 0 ? (categoryTotals[0].1 / totalSpent) : 0
                    let cat2Ratio = categoryTotals.count > 1 ? (categoryTotals[1].1 / totalSpent) : 0
                    let cat3Ratio = categoryTotals.count > 2 ? (categoryTotals[2].1 / totalSpent) : 0

                    Circle()
                        .trim(from: 0.0, to: CGFloat(cat1Ratio))
                        .stroke(Color.primaryColor, style: StrokeStyle(lineWidth: 24, lineCap: .round))
                        .frame(width: 160, height: 160)
                        .rotationEffect(.degrees(-90))

                    if cat2Ratio > 0 {
                        Circle()
                            .trim(from: 0.0, to: CGFloat(cat2Ratio))
                            .stroke(Color.secondary, style: StrokeStyle(lineWidth: 24, lineCap: .round))
                            .frame(width: 160, height: 160)
                            .rotationEffect(.degrees(-90 + (cat1Ratio * 360)))
                    }

                    if cat3Ratio > 0 {
                        Circle()
                            .trim(from: 0.0, to: CGFloat(cat3Ratio))
                            .stroke(Color.tertiary, style: StrokeStyle(lineWidth: 24, lineCap: .round))
                            .frame(width: 160, height: 160)
                            .rotationEffect(.degrees(-90 + ((cat1Ratio + cat2Ratio) * 360)))
                    }
                }

                VStack(spacing: 2) {
                    Text(String(format: "$%.0f", totalSpent))
                        .font(.custom("Inter", size: 28).weight(.black))
                        .foregroundColor(Color.onSurface)
                    Text("TOTAL")
                        .font(.custom("Inter", size: 10).weight(.bold))
                        .foregroundColor(Color.onSurfaceVariant)
                }
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)

            // Legend
            VStack(spacing: 16) {
                if categoryTotals.isEmpty {
                    Text("No expenses this month.")
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(Color.onSurfaceVariant)
                } else {
                    if categoryTotals.count > 0 {
                        CategoryLegendRow(color: Color.primaryColor, title: categoryTotals[0].0, percentage: (categoryTotals[0].1 / totalSpent) * 100)
                    }
                    if categoryTotals.count > 1 {
                        CategoryLegendRow(color: Color.secondary, title: categoryTotals[1].0, percentage: (categoryTotals[1].1 / totalSpent) * 100)
                    }
                    if categoryTotals.count > 2 {
                        CategoryLegendRow(color: Color.tertiary, title: categoryTotals[2].0, percentage: (categoryTotals[2].1 / totalSpent) * 100)
                    }
                }
            }

            Button(action: {}) {
                Text("View Full Report")
                    .font(.custom("Inter", size: 14).weight(.bold))
                    .foregroundColor(Color.onSurface)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.surfaceContainerHigh)
                    .cornerRadius(16)
            }
            .padding(.top, 8)
        }
        .padding(24)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.04), radius: 25, x: 0, y: 10)
    }
}

struct SmartPredictionCard: View {
    var spentThisMonth: Double
    var spentLastMonth: Double

    var difference: Double {
        spentLastMonth - spentThisMonth
    }

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("SMART PREDICTION")
                .font(.custom("Inter", size: 10).weight(.bold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.2))
                .cornerRadius(16)

            if spentLastMonth == 0 {
                Text("Keep logging your transactions to get smart predictions.")
                    .font(.custom("Inter", size: 20).weight(.bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            } else if difference > 0 {
                Text("You're on track to save $\(String(format: "%.0f", difference)) more than last month.")
                    .font(.custom("Inter", size: 24).weight(.bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                Text("Based on your current trajectory, we recommend moving $\(String(format: "%.0f", difference * 0.5)) into your High Yield Savings.")
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(Color.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                Text("You've spent $\(String(format: "%.0f", abs(difference))) more than last month.")
                    .font(.custom("Inter", size: 24).weight(.bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                Text("Consider reviewing your Variable expenses to keep your savings goals on track.")
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(Color.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Button(action: {}) {
                Text("Transfer Funds")
                    .font(.custom("Inter", size: 16).weight(.bold))
                    .foregroundColor(Color.primaryColor)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(Color.white)
                    .cornerRadius(16)
            }
            .padding(.top, 8)
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(Color.primaryColor)
        .cornerRadius(24)
    }
}

struct UnusualActivitySection: View {
    var transactions: [Transaction]

    var highestTransaction: Transaction? {
        transactions.max(by: { $0.amount < $1.amount })
    }

    var body: some View {
        if let maxTx = highestTransaction {
            VStack(alignment: .leading, spacing: 16) {
                Text("Notable Activity")
                    .font(.custom("Inter", size: 20).weight(.bold))
                    .foregroundColor(Color.onSurface)

                VStack(spacing: 16) {
                    // Highest Expense
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.tertiary.opacity(0.2))
                            .frame(width: 48, height: 48)
                            .overlay(
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(Color.tertiary)
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Large Transaction")
                                .font(.custom("Inter", size: 16).weight(.bold))
                                .foregroundColor(Color.onSurface)
                            Text("Highest spend this month:\n\(maxTx.merchant)")
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(Color.onSurfaceVariant)
                                .lineLimit(2)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            Text(String(format: "$%.2f", maxTx.amount))
                                .font(.custom("Inter", size: 16).weight(.bold))
                                .foregroundColor(Color.tertiary)
                            Text(maxTx.isFixed ? "FIXED" : "VARIABLE")
                                .font(.custom("Inter", size: 10).weight(.bold))
                                .foregroundColor(Color.onSurfaceVariant)
                        }
                    }
                    .padding(20)
                    .background(Color.surfaceContainerLowest)
                    .cornerRadius(20)
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct CategoryLegendRow: View {
    var color: Color
    var title: String
    var percentage: Double

    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Circle().fill(color).frame(width: 12, height: 12)
                Text(title)
                    .font(.custom("Inter", size: 14).weight(.medium))
                    .foregroundColor(Color.onSurface)
            }
            Spacer()
            Text(String(format: "%.0f%%", percentage))
                .font(.custom("Inter", size: 14).weight(.bold))
                .foregroundColor(Color.onSurface)
        }
    }
}
