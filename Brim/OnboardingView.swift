import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            WelcomeScreen(path: $path)
                .navigationBarBackButtonHidden(true)
                .navigationDestination(for: String.self) { value in
                    if value == "ProfileSetup" {
                        ProfileSetupScreen(hasCompletedOnboarding: $hasCompletedOnboarding, onBack: {
                            path.removeLast()
                        })
                        .navigationBarBackButtonHidden(true)
                    }
                }
        }
    }
}

struct WelcomeScreen: View {
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                Spacer()

                // Mock Illustration Area
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(Color.primaryContainer)
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-10))
                        .offset(x: -20, y: -20)
                        .shadow(color: Color.primaryContainer.opacity(0.3), radius: 20, x: 0, y: 10)

                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.surfaceContainerLowest)
                        .frame(width: 160, height: 180)
                        .rotationEffect(.degrees(5))
                        .offset(x: 30, y: 30)
                        .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 8)
                }
                .padding(.bottom, 60)

                // Branding & Copy
                Text("Brim")
                    .font(.custom("Inter", size: 48).weight(.black).italic())
                    .tracking(-2)
                    .foregroundColor(Color.primaryColor)
                    .padding(.bottom, 16)

                Text("Manage your finances with the\nclarity of a professional curator.")
                    .font(.custom("Inter", size: 18))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.onSurfaceVariant)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 48)

                Spacer()

                // Actions
                VStack(spacing: 16) {
                    Button(action: {
                        path.append("ProfileSetup")
                    }) {
                        Text("Get Started")
                            .font(.custom("Inter", size: 18).weight(.bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.primaryColor)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 32)

                    Button(action: {
                        // Action for Sign In (Not required for this task)
                    }) {
                        Text("Sign In")
                            .font(.custom("Inter", size: 16).weight(.semibold))
                            .foregroundColor(Color.primaryColor)
                    }
                    .padding(.bottom, 32)
                }

                Text("PREMIUM FINANCIAL INTELLIGENCE")
                    .font(.custom("Inter", size: 10).weight(.bold))
                    .tracking(2)
                    .foregroundColor(Color.outline)
                    .padding(.bottom, 24)
            }
        }
    }
}

struct ProfileSetupScreen: View {
    @Binding var hasCompletedOnboarding: Bool
    var onBack: (() -> Void)? = nil
    @State private var fullName: String = ""
    @State private var selectedCurrency: String = "USD"

    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading, spacing: 0) {
                // Header (Top App Bar equivalent)
                HStack {
                    Button(action: {
                        withAnimation {
                            onBack?()
                        }
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color.primaryColor)
                    }

                    Spacer()

                    Text("Brim")
                        .font(.custom("Inter", size: 24).weight(.black).italic())
                        .tracking(-1)
                        .foregroundColor(Color.primaryColor)

                    Spacer()

                    // Invisible view for balancing the HStack
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.clear)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 32)

                ScrollView {
                    VStack(alignment: .leading, spacing: 40) {
                        // Title
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Set Up Your Profile")
                                .font(.custom("Inter", size: 32).weight(.black))
                                .foregroundColor(Color.onBackground)

                            Text("Welcome to your new financial\nconcierge. Let's personalize your\nexperience.")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(Color.onSurfaceVariant)
                                .lineSpacing(4)
                        }
                        .padding(.horizontal, 24)

                        // Form
                        VStack(alignment: .leading, spacing: 32) {
                            // Full Name Input
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Full Name")
                                    .font(.custom("Inter", size: 16).weight(.semibold))
                                    .foregroundColor(Color.onSurfaceVariant)

                                TextField("Enter your name", text: $fullName)
                                    .font(.custom("Inter", size: 18))
                                    .padding(.horizontal, 24)
                                    .frame(height: 64)
                                    .background(Color.surfaceContainerHigh)
                                    .cornerRadius(16)
                            }

                            // Preferred Currency
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Preferred Currency")
                                    .font(.custom("Inter", size: 16).weight(.semibold))
                                    .foregroundColor(Color.onSurfaceVariant)

                                VStack(spacing: 0) {
                                    CurrencyRow(
                                        symbol: "$",
                                        code: "USD",
                                        name: "United States Dollar",
                                        isSelected: selectedCurrency == "USD"
                                    ) {
                                        selectedCurrency = "USD"
                                    }

                                    CurrencyRow(
                                        symbol: "€",
                                        code: "EUR",
                                        name: "Euro",
                                        isSelected: selectedCurrency == "EUR"
                                    ) {
                                        selectedCurrency = "EUR"
                                    }

                                    CurrencyRow(
                                        symbol: "£",
                                        code: "GBP",
                                        name: "British Pound Sterling",
                                        isSelected: selectedCurrency == "GBP"
                                    ) {
                                        selectedCurrency = "GBP"
                                    }
                                }
                                .background(Color.surfaceContainerLow)
                                .cornerRadius(16)
                            }
                        }
                        .padding(.horizontal, 24)

                        Spacer(minLength: 120)
                    }
                }
            }

            // Bottom Action Bar
            VStack {
                Spacer()
                VStack {
                    Button(action: {
                        withAnimation {
                            hasCompletedOnboarding = true
                        }
                    }) {
                        Text("Continue")
                            .font(.custom("Inter", size: 18).weight(.bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.primaryColor)
                            .cornerRadius(16)
                            .shadow(color: Color.primaryColor.opacity(0.2), radius: 20, x: 0, y: 4)
                    }
                }
                .padding(24)
                .background(
                    Color.surface.opacity(0.8)
                        .background(.ultraThinMaterial)
                )
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}

struct CurrencyRow: View {
    var symbol: String
    var code: String
    var name: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Circle Icon
                ZStack {
                    Circle()
                        .fill(Color.surfaceContainerLowest)
                        .frame(width: 48, height: 48)
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)

                    Text(symbol)
                        .font(.custom("Inter", size: 20).weight(.bold))
                        .foregroundColor(Color.primaryColor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(code)
                        .font(.custom("Inter", size: 16).weight(.bold))
                        .foregroundColor(Color.onSurface)
                    Text(name)
                        .font(.custom("Inter", size: 12))
                        .foregroundColor(Color.onSurfaceVariant)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color.primaryColor)
                }
            }
            .padding(20)
            .background(isSelected ? Color.surfaceContainerHigh : Color.clear)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
