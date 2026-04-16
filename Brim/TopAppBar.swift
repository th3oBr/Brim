import SwiftUI

struct TopAppBar: View {
    var title: String
    var showBackButton: Bool = false
    var action: (() -> Void)? = nil

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
                    Image("profile_placeholder") // Assuming we will add an image later or use a standard circle
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.surfaceContainerHigh, lineWidth: 1)
                        )
                        .background(
                            Circle().fill(Color.surfaceContainerHigh)
                        )

                    Text(title)
                        .font(.custom("Inter", size: 18).weight(.black))
                        .tracking(-0.5)
                        .foregroundColor(Color.primaryColor)
                }
            }

            Spacer()

            if !showBackButton {
                Button(action: {

                }) {
                    Image(systemName: "bell")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.onSurfaceVariant)
                        .padding(8)
                }
            } else {
                Text("New Entry")
                    .font(.custom("Inter", size: 14).weight(.semibold))
                    .foregroundColor(Color.outline)
            }
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
