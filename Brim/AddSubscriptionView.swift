import SwiftUI
import SwiftData

struct AddSubscriptionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var amount: String = ""
    @State private var serviceName: String = ""
    @State private var cycle: Int = 0
    @State private var category: Int = 0
    @State private var reminder: Bool = true
    @State private var date: Date = Date()

    var body: some View {
        VStack(spacing: 0) {
            TopAppBar(title: "Add Subscription", showBackButton: true, action: {
                dismiss()
            })

            ScrollView(showsIndicators: false) {
                VStack(spacing: 40) {
                    // Amount Section
                    VStack(spacing: 8) {
                        Text("Monthly Commitment")
                            .font(.custom("Inter", size: 16).weight(.medium))
                            .foregroundColor(Color.onSurfaceVariant)

                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("$")
                                .font(.custom("Inter", size: 36).weight(.bold))
                                .foregroundColor(Color.onSurfaceVariant)

                            TextField("0.00", text: $amount)
                                .font(.custom("Inter", size: 48).weight(.heavy))
                                .foregroundColor(Color.onSurface)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.center)
                                .frame(width: 150)
                        }
                    }
                    .padding(.top, 40)

                    VStack(spacing: 24) {
                        // Service Details
                        VStack(alignment: .leading, spacing: 12) {
                            Text("SERVICE DETAILS")
                                .font(.custom("Inter", size: 14).weight(.semibold))
                                .tracking(1)
                                .foregroundColor(Color.onSurfaceVariant)
                                .padding(.horizontal, 4)

                            HStack(spacing: 12) {
                                Image(systemName: "tag.fill")
                                    .foregroundColor(Color.onSurfaceVariant)
                                TextField("Service Name (e.g. Netflix)", text: $serviceName)
                                    .font(.custom("Inter", size: 16))
                            }
                            .padding(20)
                            .background(Color.surfaceContainerHigh)
                            .cornerRadius(16)
                        }

                        // Cycle & Category
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                        .font(.system(size: 14))
                                    Text("BILLING CYCLE")
                                        .font(.custom("Inter", size: 12).weight(.bold))
                                        .tracking(1)
                                }
                                .foregroundColor(Color.onSurfaceVariant)

                                Picker("", selection: $cycle) {
                                    Text("Monthly").tag(0)
                                    Text("Yearly").tag(1)
                                }
                                .pickerStyle(.menu)
                                .accentColor(.onSurface)
                                .font(.custom("Inter", size: 16).weight(.semibold))
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.surfaceContainerLow)
                            .cornerRadius(16)

                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "square.grid.2x2.fill")
                                        .font(.system(size: 14))
                                    Text("CATEGORY")
                                        .font(.custom("Inter", size: 12).weight(.bold))
                                        .tracking(1)
                                }
                                .foregroundColor(Color.onSurfaceVariant)

                                Picker("", selection: $category) {
                                    Text("Entertainment").tag(0)
                                    Text("Software").tag(1)
                                }
                                .pickerStyle(.menu)
                                .accentColor(.onSurface)
                                .font(.custom("Inter", size: 16).weight(.semibold))
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.surfaceContainerLow)
                            .cornerRadius(16)
                        }

                        // Date
                        HStack {
                            Circle()
                                .fill(Color.primaryColor.opacity(0.1))
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Image(systemName: "calendar")
                                        .foregroundColor(Color.primaryColor)
                                )

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Next Payment")
                                    .font(.custom("Inter", size: 12).weight(.medium))
                                    .foregroundColor(Color.onSurfaceVariant)
                                DatePicker("", selection: $date, displayedComponents: .date)
                                    .labelsHidden()
                                    .accentColor(.primaryColor)
                            }
                            Spacer()
                        }
                        .padding(20)
                        .background(Color.surfaceContainerLowest)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.02), radius: 15, y: 4)

                        // Reminder Toggle
                        HStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.tertiaryContainer.opacity(0.1))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: "bell.badge.fill")
                                        .foregroundColor(Color.tertiaryContainer)
                                )

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Payment Reminder")
                                    .font(.custom("Inter", size: 16).weight(.bold))
                                    .foregroundColor(Color.onSurface)
                                Text("Notify 2 days before")
                                    .font(.custom("Inter", size: 12))
                                    .foregroundColor(Color.onSurfaceVariant)
                            }

                            Spacer()

                            Toggle("", isOn: $reminder)
                                .labelsHidden()
                                .tint(Color.secondary)
                        }
                        .padding(20)
                        .background(Color.surfaceContainerLow)
                        .cornerRadius(16)

                        // Submit Button
                        Button(action: {
                            let amountValue = Double(amount) ?? 0.0
                            let newSubscription = Subscription(amount: amountValue, serviceName: serviceName, cycle: cycle, category: category, nextPaymentDate: date, reminder: reminder)
                            modelContext.insert(newSubscription)
                            dismiss()
                        }) {
                            Text("Add Subscription")
                                .font(.custom("Inter", size: 18).weight(.bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(
                                    LinearGradient(colors: [Color.primaryColor, Color.primaryContainer], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .foregroundColor(Color.onPrimary)
                                .cornerRadius(16)
                                .shadow(color: Color.primaryColor.opacity(0.2), radius: 15, y: 8)
                        }
                    }
                    .padding(.horizontal, 24)

                    // Info Card
                    HStack(alignment: .top, spacing: 16) {
                        Image(systemName: "heart.text.square.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color.secondary)

                        Text("Adding subscriptions helps Brim identify **unused services** and suggests ways to optimize your monthly recurring expenses.")
                            .font(.custom("Inter", size: 14))
                            .foregroundColor(Color.onSecondaryFixedVariant)
                            .lineSpacing(4)
                    }
                    .padding(24)
                    .background(Color.secondaryContainer.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.secondaryContainer.opacity(0.2), lineWidth: 1)
                    )
                    .cornerRadius(16)
                    .padding(.horizontal, 24)

                    Spacer().frame(height: 40)
                }
            }
            .background(Color.surface)
        }
    }
}
