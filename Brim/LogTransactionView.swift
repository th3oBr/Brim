import SwiftUI
import SwiftData

struct LogTransactionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var amount: String = ""
    @State private var merchant: String = ""
    @State private var date: Date = Date()
    @State private var category: String = "Dining & Drinks"
    @State private var type: Int = 0 // 0 = Expense, 1 = Income
    @AppStorage("currencySymbol") private var currencySymbol: String = "$"

    let categories = ["Dining & Drinks", "Groceries", "Transport", "Shopping", "Entertainment"]

    var body: some View {
        VStack(spacing: 0) {
            TopAppBar(title: "Brim", showBackButton: true, action: {
                dismiss()
            })

            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    // Segmented Control for Type
                    HStack(spacing: 0) {
                        Button(action: { type = 0 }) {
                            Text("Expense")
                                .font(.custom("Inter", size: 14).weight(type == 0 ? .bold : .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .foregroundColor(type == 0 ? Color.primaryColor : Color.onSurfaceVariant)
                                .background(type == 0 ? Color.surfaceContainerLowest : Color.clear)
                                .cornerRadius(20)
                                .shadow(color: type == 0 ? Color.black.opacity(0.05) : Color.clear, radius: 2, y: 1)
                        }

                        Button(action: { type = 1 }) {
                            Text("Income")
                                .font(.custom("Inter", size: 14).weight(type == 1 ? .bold : .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .foregroundColor(type == 1 ? Color.primaryColor : Color.onSurfaceVariant)
                                .background(type == 1 ? Color.surfaceContainerLowest : Color.clear)
                                .cornerRadius(20)
                                .shadow(color: type == 1 ? Color.black.opacity(0.05) : Color.clear, radius: 2, y: 1)
                        }
                    }
                    .padding(4)
                    .background(Color.surfaceContainerHigh)
                    .cornerRadius(24)
                    .frame(maxWidth: 300)
                    .padding(.top, 24)

                    // Amount Section
                    VStack(spacing: 8) {
                        Text(type == 0 ? "Transaction Amount" : "Income Amount")
                            .font(.custom("Inter", size: 14).weight(.medium))
                            .foregroundColor(Color.onSurfaceVariant)

                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text(currencySymbol)
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

                                DatePicker("", selection: $date, displayedComponents: .date)
                                    .labelsHidden()
                                    .accentColor(.primaryColor)
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 20)
                                    .background(Color.surfaceContainerLow)
                                    .cornerRadius(16)
                            }

                            // Category Display
                            VStack(alignment: .leading, spacing: 8) {
                                Text("CATEGORY")
                                    .font(.custom("Inter", size: 12).weight(.bold))
                                    .tracking(1)
                                    .foregroundColor(Color.onSurfaceVariant)

                                Picker("Category", selection: $category) {
                                    ForEach(categories, id: \.self) { cat in
                                        Text(cat).tag(cat)
                                    }
                                }
                                .pickerStyle(.menu)
                                .accentColor(.onSurface)
                                .font(.custom("Inter", size: 16).weight(.medium))
                                .padding(.vertical, 14)
                                .padding(.horizontal, 20)
                                .background(Color.surfaceContainerLow)
                                .cornerRadius(16)
                            }
                        }
                    }

                    // Submit Button
                    Button(action: {
                        let parsedAmount = Double(amount) ?? 0.0
                        let finalAmount = type == 0 ? parsedAmount : -parsedAmount
                        let newTransaction = Transaction(amount: finalAmount, merchant: merchant, date: date, category: type == 0 ? category : "Income")
                        modelContext.insert(newTransaction)
                        dismiss()
                    }) {
                        Text(type == 0 ? "Log Expense" : "Log Income")
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
