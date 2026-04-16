import SwiftUI

struct NotificationsView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack {
                Text("Notifications")
                    .font(.custom("Inter", size: 24).weight(.bold))
                    .foregroundColor(Color.onSurface)
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color.onSurfaceVariant)
                }
            }
            .padding(24)
            .background(Color.surfaceBright)

            ScrollView {
                VStack(spacing: 16) {
                    NotificationRow(title: "Payment Successful", message: "Your Netflix subscription was paid.", time: "2h ago", isUnread: true)
                    NotificationRow(title: "Budget Alert", message: "You've reached 80% of your Dining budget.", time: "Yesterday", isUnread: true)
                    NotificationRow(title: "New Feature", message: "Check out the new analytics dashboard!", time: "3 days ago", isUnread: false)
                }
                .padding(24)
            }
            .background(Color.background)
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }
}

struct NotificationRow: View {
    var title: String
    var message: String
    var time: String
    var isUnread: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Circle()
                .fill(isUnread ? Color.primaryColor : Color.surfaceContainerHigh)
                .frame(width: 12, height: 12)
                .padding(.top, 4)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title)
                        .font(.custom("Inter", size: 16).weight(.bold))
                        .foregroundColor(Color.onSurface)
                    Spacer()
                    Text(time)
                        .font(.custom("Inter", size: 12))
                        .foregroundColor(Color.onSurfaceVariant)
                }

                Text(message)
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(Color.onSurfaceVariant)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(20)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.02), radius: 10, y: 4)
    }
}

#Preview {
    NotificationsView()
}
