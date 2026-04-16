import SwiftData
import Foundation

@Model
final class Transaction {
    var amount: Double
    var merchant: String
    var date: Date
    var category: String
    var isFixed: Bool

    init(amount: Double, merchant: String, date: Date, category: String, isFixed: Bool = false) {
        self.amount = amount
        self.merchant = merchant
        self.date = date
        self.category = category
        self.isFixed = isFixed
    }
}

@Model
final class Subscription {
    var amount: Double
    var serviceName: String
    var cycle: Int // 0 for Monthly, 1 for Yearly
    var category: Int // 0 for Entertainment, 1 for Software
    var nextPaymentDate: Date
    var reminder: Bool

    init(amount: Double, serviceName: String, cycle: Int, category: Int, nextPaymentDate: Date, reminder: Bool) {
        self.amount = amount
        self.serviceName = serviceName
        self.cycle = cycle
        self.category = category
        self.nextPaymentDate = nextPaymentDate
        self.reminder = reminder
    }
}
