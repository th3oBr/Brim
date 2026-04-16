import SwiftUI

struct NotificationsView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                NotificationRow(title: "Payment Successful", message: "Your Netflix subscription was paid.", time: "2h ago", isUnread: true)
                NotificationRow(title: "Budget Alert", message: "You've reached 80% of your Dining budget.", time: "Yesterday", isUnread: true)
                NotificationRow(title: "New Feature", message: "Check out the new analytics dashboard!", time: "3 days ago", isUnread: false)
            }
            .listStyle(.plain)
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct NotificationRow: View {
    var title: String
    var message: String
    var time: String
    var isUnread: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(isUnread ? Color.primaryColor : Color.surfaceContainerHigh)
                .frame(width: 8, height: 8)
                .padding(.top, 6)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.custom("Inter", size: 16).weight(.semibold))
                        .foregroundColor(Color.onSurface)
                    Spacer()
                    Text(time)
                        .font(.custom("Inter", size: 12))
                        .foregroundColor(Color.onSurfaceVariant)
                }

                Text(message)
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(Color.onSurfaceVariant)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NotificationsView()
}
