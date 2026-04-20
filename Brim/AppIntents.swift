import Foundation
import AppIntents
import SwiftData

struct LogExpenseIntent: AppIntent {
    static var title: LocalizedStringResource = "Log Apple Pay Expense"
    static var description = IntentDescription("Logs an Apple Pay transaction (expense) into Brim.")

    @Parameter(title: "Amount")
    var amount: Double

    @Parameter(title: "Merchant")
    var merchant: String

    func perform() async throws -> some IntentResult {
        let container = try ModelContainer(for: Transaction.self)
        let context = ModelContext(container)

        // Expenses are represented as positive amount values
        let expenseAmount = abs(amount)

        let transaction = Transaction(
            amount: expenseAmount,
            merchant: merchant,
            date: Date(),
            category: "Expense" // Defaulting to generic expense, as it's from Apple Pay
        )

        context.insert(transaction)
        try context.save()

        return .result()
    }
}

struct BrimShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: LogExpenseIntent(),
            phrases: [
                "Log a payment in \(.applicationName)",
                "Log an expense in \(.applicationName)",
                "Record Apple Pay transaction in \(.applicationName)"
            ],
            shortTitle: "Log Expense",
            systemImageName: "creditcard"
        )
    }
}
