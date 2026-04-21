import Foundation

struct AppCurrency: Identifiable {
    var id: String { code }
    let code: String
    let symbol: String
    let name: String
}

let AppCurrencies: [AppCurrency] = [
    AppCurrency(code: "USD", symbol: "$", name: "United States Dollar"),
    AppCurrency(code: "EUR", symbol: "€", name: "Euro"),
    AppCurrency(code: "GBP", symbol: "£", name: "British Pound Sterling"),
    AppCurrency(code: "JPY", symbol: "¥", name: "Japanese Yen")
]

struct AppCategory: Identifiable {
    var id: String { name }
    let name: String
    let icon: String
}

let TransactionCategories: [AppCategory] = [
    AppCategory(name: "Dining & Drinks", icon: "cup.and.saucer.fill"),
    AppCategory(name: "Groceries", icon: "bag.fill"),
    AppCategory(name: "Transport", icon: "tram.fill"),
    AppCategory(name: "Shopping", icon: "cart.fill"),
    AppCategory(name: "Entertainment", icon: "play.tv.fill")
]

struct SubscriptionCategory: Identifiable {
    var id: Int { value }
    let value: Int
    let name: String
    let icon: String
}

let SubscriptionCategories: [SubscriptionCategory] = [
    SubscriptionCategory(value: 0, name: "Entertainment", icon: "play.tv.fill"),
    SubscriptionCategory(value: 1, name: "Software", icon: "bolt.fill")
]

struct SubscriptionCycle: Identifiable {
    var id: Int { value }
    let value: Int
    let name: String
}

let SubscriptionCycles: [SubscriptionCycle] = [
    SubscriptionCycle(value: 0, name: "Monthly"),
    SubscriptionCycle(value: 1, name: "Yearly")
]
