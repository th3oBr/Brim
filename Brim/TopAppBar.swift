import SwiftUI

struct TopAppBar: View {
    var title: String
    var showBackButton: Bool = false
    var action: (() -> Void)? = nil
    var onNotificationTap: (() -> Void)? = nil

    var body: some View {
        HStack {
            if showBackButton {
                Button(action: {
                    action?()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.primaryColor)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(Color.clear)
                        )
                }
            } else {
                HStack(spacing: 12) {
                    Text(title)
                        .font(.custom("Inter", size: 18).weight(.black))
                        .tracking(-0.5)
                        .foregroundColor(Color.primaryColor)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(height: 64)
        .background(
            Color.surfaceBright.opacity(0.8)
                .background(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.03), radius: 30, x: 0, y: 4)
        )
    }
}
