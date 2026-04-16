import SwiftUI

struct AnalyticsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("PORTFOLIO PERFORMANCE")
                        .font(.custom("Inter", size: 11).weight(.bold))
                        .tracking(2.0)
                        .foregroundColor(Color.onSurfaceVariant)

                    Text("Analytics")
                        .font(.custom("Inter", size: 40).weight(.black))
                        .foregroundColor(Color.onSurface)
                        .tracking(-1.0)

                    Text("Detailed overview of your financial trajectory and spending habits for October 2023.")
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(Color.onSurfaceVariant)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Vs Last Month Card
                VsLastMonthCard()
                    .padding(.horizontal, 24)

                // Cumulative Spend Card
                CumulativeSpendCard()
                    .padding(.horizontal, 24)

                // Top Categories Card
                TopCategoriesCard()
                    .padding(.horizontal, 24)

                // Smart Prediction Card
                SmartPredictionCard()
                    .padding(.horizontal, 24)

                // Unusual Activity Section
                UnusualActivitySection()
                    .padding(.horizontal, 24)

                Spacer(minLength: 120) // For BottomNavBar spacing
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }
}

// MARK: - Subviews

struct VsLastMonthCard: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("VS LAST MONTH")
                    .font(.custom("Inter", size: 11).weight(.bold))
                    .foregroundColor(Color.onSurfaceVariant)

                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text("-$420.50")
                        .font(.custom("Inter", size: 28).weight(.bold))
                        .foregroundColor(Color.onSurface)

                    HStack(spacing: 2) {
                        Image(systemName: "arrow.down")
                            .font(.system(size: 10, weight: .bold))
                        Text("12.4%")
                            .font(.custom("Inter", size: 14).weight(.bold))
                    }
                    .foregroundColor(Color.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(12)
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
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Cumulative\nSpend")
                        .font(.custom("Inter", size: 22).weight(.bold))
                        .foregroundColor(Color.onSurface)

                    Text("Real-time tracking\nagainst $5,000 monthly\ngoal")
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
                    Text("$3.2k")
                        .font(.custom("Inter", size: 18).weight(.bold))
                        .foregroundColor(Color.onSurface)
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 4) {
                    Text("REMAINING")
                        .font(.custom("Inter", size: 10).weight(.bold))
                        .foregroundColor(Color.onSurfaceVariant)
                    Text("$1.8k")
                        .font(.custom("Inter", size: 18).weight(.bold))
                        .foregroundColor(Color.secondary)
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 4) {
                    Text("DAILY AVG")
                        .font(.custom("Inter", size: 10).weight(.bold))
                        .foregroundColor(Color.onSurfaceVariant)
                    Text("$135")
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

            // Donut Chart
            ZStack {
                Circle()
                    .stroke(Color.surfaceContainerHigh, lineWidth: 24)
                    .frame(width: 160, height: 160)

                // Housing 40%
                Circle()
                    .trim(from: 0.0, to: 0.40)
                    .stroke(Color.primaryColor, style: StrokeStyle(lineWidth: 24, lineCap: .round))
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))

                // Dining 25%
                Circle()
                    .trim(from: 0.0, to: 0.25)
                    .stroke(Color.secondary, style: StrokeStyle(lineWidth: 24, lineCap: .round))
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90 + (0.43 * 360)))

                // Entertainment 15%
                Circle()
                    .trim(from: 0.0, to: 0.15)
                    .stroke(Color.tertiary, style: StrokeStyle(lineWidth: 24, lineCap: .round))
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90 + (0.71 * 360)))

                VStack(spacing: 2) {
                    Text("$4.5k")
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
                HStack {
                    HStack(spacing: 12) {
                        Circle().fill(Color.primaryColor).frame(width: 12, height: 12)
                        Text("Housing")
                            .font(.custom("Inter", size: 14).weight(.medium))
                            .foregroundColor(Color.onSurface)
                    }
                    Spacer()
                    Text("40%")
                        .font(.custom("Inter", size: 14).weight(.bold))
                        .foregroundColor(Color.onSurface)
                }

                HStack {
                    HStack(spacing: 12) {
                        Circle().fill(Color.secondary).frame(width: 12, height: 12)
                        Text("Dining")
                            .font(.custom("Inter", size: 14).weight(.medium))
                            .foregroundColor(Color.onSurface)
                    }
                    Spacer()
                    Text("25%")
                        .font(.custom("Inter", size: 14).weight(.bold))
                        .foregroundColor(Color.onSurface)
                }

                HStack {
                    HStack(spacing: 12) {
                        Circle().fill(Color.tertiary).frame(width: 12, height: 12)
                        Text("Entertainment")
                            .font(.custom("Inter", size: 14).weight(.medium))
                            .foregroundColor(Color.onSurface)
                    }
                    Spacer()
                    Text("15%")
                        .font(.custom("Inter", size: 14).weight(.bold))
                        .foregroundColor(Color.onSurface)
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
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("SMART PREDICTION")
                .font(.custom("Inter", size: 10).weight(.bold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.2))
                .cornerRadius(16)

            Text("You're on track to save $450 more than last month.")
                .font(.custom("Inter", size: 24).weight(.bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Text("Based on your current trajectory, we recommend moving $200 into your High Yield Savings.")
                .font(.custom("Inter", size: 14))
                .foregroundColor(Color.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
                .fixedSize(horizontal: false, vertical: true)

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
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Unusual Activity")
                .font(.custom("Inter", size: 20).weight(.bold))
                .foregroundColor(Color.onSurface)

            VStack(spacing: 16) {
                // Subscription Spike
                HStack(spacing: 16) {
                    Circle()
                        .fill(Color.tertiary.opacity(0.2))
                        .frame(width: 48, height: 48)
                        .overlay(
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(Color.tertiary)
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Subscription Spike")
                            .font(.custom("Inter", size: 16).weight(.bold))
                            .foregroundColor(Color.onSurface)
                        Text("Cloud Storage increased by\n15% this period")
                            .font(.custom("Inter", size: 12))
                            .foregroundColor(Color.onSurfaceVariant)
                            .lineLimit(2)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("+$14.99")
                            .font(.custom("Inter", size: 16).weight(.bold))
                            .foregroundColor(Color.tertiary)
                        Text("RECURRING")
                            .font(.custom("Inter", size: 10).weight(.bold))
                            .foregroundColor(Color.onSurfaceVariant)
                    }
                }
                .padding(20)
                .background(Color.surfaceContainerLowest)
                .cornerRadius(20)

                // Sustainability Win
                HStack(spacing: 16) {
                    Circle()
                        .fill(Color.secondary.opacity(0.2))
                        .frame(width: 48, height: 48)
                        .overlay(
                            Image(systemName: "leaf.fill")
                                .foregroundColor(Color.secondary)
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Sustainability Win")
                            .font(.custom("Inter", size: 16).weight(.bold))
                            .foregroundColor(Color.onSurface)
                        Text("Transport costs reduced by\nutilizing bike sharing")
                            .font(.custom("Inter", size: 12))
                            .foregroundColor(Color.onSurfaceVariant)
                            .lineLimit(2)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("-$62.00")
                            .font(.custom("Inter", size: 16).weight(.bold))
                            .foregroundColor(Color.secondary)
                        Text("ONE-TIME")
                            .font(.custom("Inter", size: 10).weight(.bold))
                            .foregroundColor(Color.onSurfaceVariant)
                    }
                }
                .padding(20)
                .background(Color.surfaceContainerLowest)
                .cornerRadius(20)
            }
        }
    }
}

#Preview {
    AnalyticsView()
}
