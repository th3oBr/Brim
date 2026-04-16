import SwiftUI

struct LogTransactionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var amount: String = "0.00"
    @State private var merchant: String = ""
    @State private var date: Date = Date()
    @State private var category: String = "Dining"

    var body: some View {
        VStack(spacing: 0) {
            TopAppBar(title: "Brim", showBackButton: true, action: {
                dismiss()
            })

            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    // Amount Section
                    VStack(spacing: 8) {
                        Text("Transaction Amount")
                            .font(.custom("Inter", size: 14).weight(.medium))
                            .foregroundColor(Color.onSurfaceVariant)

                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("$")
                                .font(.custom("Inter", size: 36).weight(.heavy))
                                .foregroundColor(Color.primaryContainer)

                            TextField("0.00", text: $amount)
                                .font(.custom("Inter", size: 72).weight(.black))
                                .foregroundColor(Color.onSurface)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.center)
                                .frame(width: 180)
                        }
                    }
                    .padding(.top, 32)

                    // Form Elements
                    VStack(spacing: 16) {
                        // Merchant Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("MERCHANT")
                                .font(.custom("Inter", size: 12).weight(.bold))
                                .tracking(1)
                                .foregroundColor(Color.onSurfaceVariant)

                            HStack(spacing: 12) {
                                Image(systemName: "storefront")
                                    .foregroundColor(Color.primaryColor)
                                    .font(.system(size: 20))
                                TextField("Blue Bottle Coffee", text: $merchant)
                                    .font(.custom("Inter", size: 18).weight(.medium))
                                    .foregroundColor(Color.onSurface)
                            }
                            .padding(20)
                            .background(Color.surfaceContainerLow)
                            .cornerRadius(16)
                        }

                        HStack(spacing: 16) {
                            // Date Picker (Simulated)
                            VStack(alignment: .leading, spacing: 8) {
                                Text("DATE")
                                    .font(.custom("Inter", size: 12).weight(.bold))
                                    .tracking(1)
                                    .foregroundColor(Color.onSurfaceVariant)

                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(Color.primaryColor)
                                    Text("Today")
                                        .font(.custom("Inter", size: 18).weight(.medium))
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color.outlineVariant)
                                }
                                .padding(20)
                                .background(Color.surfaceContainerLow)
                                .cornerRadius(16)
                            }

                            // Category Display
                            VStack(alignment: .leading, spacing: 8) {
                                Text("CATEGORY")
                                    .font(.custom("Inter", size: 12).weight(.bold))
                                    .tracking(1)
                                    .foregroundColor(Color.onSurfaceVariant)

                                HStack {
                                    Circle()
                                        .fill(Color.tertiaryFixed)
                                        .frame(width: 32, height: 32)
                                        .overlay(
                                            Image(systemName: "fork.knife")
                                                .foregroundColor(Color.tertiary)
                                                .font(.system(size: 14))
                                        )
                                    Text("Dining")
                                        .font(.custom("Inter", size: 18).weight(.medium))
                                    Spacer()
                                    Image(systemName: "chevron.up.chevron.down")
                                        .foregroundColor(Color.outlineVariant)
                                }
                                .padding(20)
                                .background(Color.surfaceContainerLow)
                                .cornerRadius(16)
                            }
                        }
                    }

                    // Submit Button
                    Button(action: { dismiss() }) {
                        Text("Log Transaction")
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
                    .padding(.top, 16)
                }
                .padding(24)
            }
            .background(Color.surface)
        }
    }
}
