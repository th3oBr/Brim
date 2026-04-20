import SwiftUI

struct SettingsView: View {
    @AppStorage("userName") private var userName: String = "Alex Richardson"
    @AppStorage("monthlyBudget") private var monthlyBudget: Double = 500.0
    @AppStorage("currencySymbol") private var currencySymbol: String = "$"
    @AppStorage("currencyCode") private var currencyCode: String = "USD"

    let currencies = [
        ("USD", "$"), ("EUR", "€"), ("GBP", "£"), ("JPY", "¥")
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                // Profile Section
                HStack(spacing: 16) {
                    Image(systemName: "person.crop.square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 64, height: 64)
                        .foregroundColor(Color.primaryColor)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.surfaceContainerHigh, lineWidth: 1)
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.surfaceContainerHigh)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, y: 2)
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Your Name", text: $userName)
                            .font(.custom("Inter", size: 18).weight(.bold))
                            .foregroundColor(Color.onSurface)
                            .autocorrectionDisabled()
                    }

                    Spacer()
                }
                .padding(24)
                .background(Color.surfaceContainerLowest)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.02), radius: 10, y: 4)

                // Preferences
                SettingsGroup(title: "Preferences") {
                    SettingsBudgetRow(icon: "chart.bar.fill", title: "Monthly Budget", budget: $monthlyBudget, currencyCode: currencyCode)

                    HStack(spacing: 12) {
                        Image(systemName: "banknote")
                            .foregroundColor(Color.primaryColor)
                            .frame(width: 24)
                        Text("Currency")
                            .font(.custom("Inter", size: 16).weight(.medium))
                            .foregroundColor(Color.onSurface)

                        Spacer()

                        Picker("Currency", selection: Binding(
                            get: { self.currencyCode },
                            set: { newValue in
                                self.currencyCode = newValue
                                if let symbol = currencies.first(where: { $0.0 == newValue })?.1 {
                                    self.currencySymbol = symbol
                                }
                            }
                        )) {
                            ForEach(currencies, id: \.0) { currency in
                                Text("\(currency.0) (\(currency.1))").tag(currency.0)
                            }
                        }
                        .tint(Color.onSurfaceVariant)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                }

                SettingsGroup(title: "Shortcuts - Apple Pay") {
                    SettingsToggleRow(icon: "bell.slash", title: "Apple Pay Integration", isOn: false)
                    SettingsToggleRow(icon: "bell.slash", title: "Silent confirmation", isOn: false)
                }

                VStack(spacing: 24) {
                    Text("BRIM v2.4.1 (Build 882)")
                        .font(.custom("Inter", size: 10))
                        .foregroundColor(Color.onSurfaceVariant)
                        .opacity(0.6)
                }
                .padding(.top, 16)

                Spacer().frame(height: 120) // Bottom nav spacing
            }
            .padding(24)
            .padding(.top, 80) // Top app bar spacing
        }
        .background(Color.surfaceBright)
    }
}

struct SettingsGroup<Content: View>: View {
    var title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.custom("Inter", size: 12).weight(.bold))
                .tracking(1)
                .foregroundColor(Color.onSurfaceVariant)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                content
            }
            .background(Color.surfaceContainerLow)
            .cornerRadius(16)
        }
    }
}

struct SettingsRow: View {
    var icon: String
    var title: String
    var value: String?
    var isExternal: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color.primaryColor)
                .frame(width: 24)
            Text(title)
                .font(.custom("Inter", size: 16).weight(.medium))
                .foregroundColor(Color.onSurface)

            Spacer()

            if let value = value {
                Text(value)
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(Color.onSurfaceVariant)
            }

            Image(systemName: isExternal ? "arrow.up.right" : "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(Color.outline)
        }
        .padding(16)
    }
}

struct SettingsBudgetRow: View {
    var icon: String
    var title: String
    @Binding var budget: Double
    var currencyCode: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color.primaryColor)
                .frame(width: 24)
            Text(title)
                .font(.custom("Inter", size: 16).weight(.medium))
                .foregroundColor(Color.onSurface)

            Spacer()

            TextField("Budget", value: $budget, format: .currency(code: currencyCode))
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .font(.custom("Inter", size: 14))
                .foregroundColor(Color.onSurfaceVariant)
                .frame(width: 100)
        }
        .padding(16)
    }
}

struct SettingsToggleRow: View {
    var icon: String
    var title: String
    @State var isOn: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color.primaryColor)
                .frame(width: 24)
            Text(title)
                .font(.custom("Inter", size: 14).weight(.medium))
                .foregroundColor(Color.onSurface)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color.primaryColor)
        }
        .padding(16)
    }
}
