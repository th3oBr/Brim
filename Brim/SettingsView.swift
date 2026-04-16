import SwiftUI

struct SettingsView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                // Profile Section
                HStack(spacing: 16) {
                    Image("profile_placeholder") // Replace with actual image later
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 64, height: 64)
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
                        Text("Alex Richardson")
                            .font(.custom("Inter", size: 18).weight(.bold))
                            .foregroundColor(Color.onSurface)
                        Text("alex.richardson@example.com")
                            .font(.custom("Inter", size: 14))
                            .foregroundColor(Color.onSurfaceVariant)
                    }

                    Spacer()

                    Button(action: {}) {
                        Text("Edit Profile")
                            .font(.custom("Inter", size: 14).weight(.semibold))
                            .foregroundColor(Color.onPrimary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.primaryColor)
                            .clipShape(Capsule())
                    }
                }
                .padding(24)
                .background(Color.surfaceContainerLowest)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.02), radius: 10, y: 4)

                // Preferences
                SettingsGroup(title: "Preferences") {
                    SettingsRow(icon: "banknote", title: "Currency", value: "USD ($)")
                    SettingsRow(icon: "globe", title: "Language", value: "English")
                    SettingsRow(icon: "circle.lefthalf.filled", title: "Theme", value: "System")
                }

                // Shortcuts Integration
                VStack(alignment: .leading, spacing: 12) {
                    Text("SHORTCUTS INTEGRATION")
                        .font(.custom("Inter", size: 12).weight(.bold))
                        .tracking(1)
                        .foregroundColor(Color.onSurfaceVariant)
                        .padding(.horizontal, 4)

                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "bolt.fill")
                                .foregroundColor(Color.onPrimary)
                                .padding(8)
                                .background(Color.onPrimary.opacity(0.2))
                                .cornerRadius(8)

                            Spacer()

                            Toggle("", isOn: .constant(true))
                                .labelsHidden()
                                .tint(Color.white)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Log Transaction Shortcut")
                                .font(.custom("Inter", size: 18).weight(.bold))
                                .foregroundColor(Color.onPrimary)
                            Text("Automatically trigger the spend logger when you tap your phone on registered NFC tags or use Siri commands.")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(Color.onPrimary.opacity(0.8))
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Button(action: {}) {
                            HStack {
                                Image(systemName: "antenna.radiowaves.left.and.right")
                                Text("Manage Automation")
                                    .font(.custom("Inter", size: 14).weight(.semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .foregroundColor(Color.onPrimary)
                            .background(Color.white.opacity(0.1))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.2), lineWidth: 1))
                            .cornerRadius(12)
                        }
                    }
                    .padding(24)
                    .background(
                        LinearGradient(colors: [Color.primaryColor, Color.primaryContainer], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .cornerRadius(16)
                    .shadow(color: Color.primaryColor.opacity(0.2), radius: 15, y: 8)
                }

                // Notifications & Security
                HStack(alignment: .top, spacing: 24) {
                    SettingsGroup(title: "Notifications") {
                        SettingsToggleRow(icon: "bell.slash", title: "Silent confirmation", isOn: false)
                        SettingsToggleRow(icon: "calendar.badge.clock", title: "Bill Reminders", isOn: true)
                    }

                    SettingsGroup(title: "Security") {
                        SettingsToggleRow(icon: "faceid", title: "FaceID Login", isOn: true)
                        SettingsRow(icon: "lock.shield", title: "Change Passcode", value: nil)
                    }
                }

                // Support
                SettingsGroup(title: "Support") {
                    SettingsRow(icon: "questionmark.circle", title: "Help Center", value: nil, isExternal: true)
                    SettingsRow(icon: "hand.raised", title: "Privacy Policy", value: nil)
                    SettingsRow(icon: "doc.text", title: "Terms of Service", value: nil)
                }

                // Sign Out
                VStack(spacing: 24) {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sign Out")
                        }
                        .font(.custom("Inter", size: 16).weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.errorContainer)
                        .foregroundColor(Color.onErrorContainer)
                        .cornerRadius(12)
                    }

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
