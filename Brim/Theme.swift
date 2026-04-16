import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    static let surfaceBright = Color(hex: "#faf9fe")
    static let outline = Color(hex: "#717786")
    static let primaryContainer = Color(hex: "#0070eb")
    static let onSurfaceVariant = Color(hex: "#414755")
    static let secondaryFixedDim = Color(hex: "#53e16f")
    static let tertiaryFixedDim = Color(hex: "#ffb874")
    static let secondaryContainer = Color(hex: "#6ffb85")
    static let primaryFixedDim = Color(hex: "#adc6ff")
    static let onPrimaryFixedVariant = Color(hex: "#004493")
    static let inverseSurface = Color(hex: "#2f3034")
    static let surfaceContainerHigh = Color(hex: "#e9e7ed")
    static let onTertiary = Color(hex: "#ffffff")
    static let onPrimaryFixed = Color(hex: "#001a41")
    static let onSecondary = Color(hex: "#ffffff")
    static let onPrimary = Color(hex: "#ffffff")
    static let secondaryFixed = Color(hex: "#72fe88")
    static let inversePrimary = Color(hex: "#adc6ff")
    static let onSecondaryFixedVariant = Color(hex: "#00531c")
    static let surfaceVariant = Color(hex: "#e3e2e7")
    static let secondary = Color(hex: "#006e28")
    static let onSurface = Color(hex: "#1a1b1f")
    static let onTertiaryContainer = Color(hex: "#fffbff")
    static let onSecondaryFixed = Color(hex: "#002107")
    static let onErrorContainer = Color(hex: "#93000a")
    static let tertiaryFixed = Color(hex: "#ffdcbf")
    static let surfaceDim = Color(hex: "#dad9df")
    static let outlineVariant = Color(hex: "#c1c6d7")
    static let background = Color(hex: "#faf9fe")
    static let surfaceContainerLow = Color(hex: "#f4f3f8")
    static let onError = Color(hex: "#ffffff")
    static let surfaceContainer = Color(hex: "#eeedf3")
    static let onTertiaryFixed = Color(hex: "#2d1600")
    static let primaryFixed = Color(hex: "#d8e2ff")
    static let tertiary = Color(hex: "#894d00")
    static let primaryColor = Color(hex: "#0058bc")
    static let onSecondaryContainer = Color(hex: "#00732a")
    static let surfaceTint = Color(hex: "#005bc1")
    static let surfaceContainerLowest = Color(hex: "#ffffff")
    static let onBackground = Color(hex: "#1a1b1f")
    static let tertiaryContainer = Color(hex: "#ac6300")
    static let surfaceContainerHighest = Color(hex: "#e3e2e7")
    static let onPrimaryContainer = Color(hex: "#fefcff")
    static let errorColor = Color(hex: "#ba1a1a")
    static let onTertiaryFixedVariant = Color(hex: "#6a3b00")
    static let errorContainer = Color(hex: "#ffdad6")
    static let surface = Color(hex: "#faf9fe")
    static let inverseOnSurface = Color(hex: "#f1f0f5")
}
