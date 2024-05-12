//
//  ExpensesOrganized.swift
//  ExpensesTracker
//
//  Created by Dylan Inafuku on 5/7/24.
//

import SwiftUI

// view to display organized expenses per category with totals
struct ExpensesOrganized: View {
    // transaction array
    let transactions: [Transaction]
    // button to sort ascending/descending
    @State private var ascendingOrder = true

    var body: some View {
        // scroll view to view transaction categories
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    // button for ascending/descnding
                    Button(action: {
                        self.ascendingOrder.toggle()
                    }) {
                        Text("Sort")
                        Image(systemName: ascendingOrder ? "arrow.up" : "arrow.down")
                    }
                    .padding()
                    Spacer()
                }
                // iterate through each category and display category logo, description, and transaction amount, also present the total for each category
                ForEach(getCategories(), id: \.self) { category in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(category)
                                .font(.title)
                                .foregroundColor(getCategoryColor(category))
                                .bold()
                            Text(String(format: "$%.0f", getCategoryTotal(category)))
                                .font(.title3)
                                .foregroundColor(.red)
                                .bold()
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        
                        ForEach(getTransactions(for: category)) { transaction in
                            TransactionRow(transaction: transaction)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            // bar title: expenses organized
            .navigationBarTitle("Expenses Organized")
        }
    }
    // get categories and sort by ascending/descending
    private func getCategories() -> [String] {
        var categoryTotals: [String: Double] = [:]
        for transaction in transactions {
            categoryTotals[transaction.category, default: 0] += transaction.amount
        }
        let sortedCategories = ascendingOrder ? categoryTotals.sorted(by: { $0.value < $1.value }) : categoryTotals.sorted(by: { $0.value > $1.value })
        return sortedCategories.map { $0.key }
    }
    // gets transactions by category
    private func getTransactions(for category: String) -> [Transaction] {
        return transactions.filter { $0.category == category }
    }
    // output category totals
    private func getCategoryTotal(_ category: String) -> Double {
        let total = transactions.filter { $0.category == category }.reduce(0) { $0 + $1.amount }
        return total
    }
    // get category color per category
    private func getCategoryColor(_ category: String) -> Color {
        switch category.lowercased() {
        case "food":
            return .green
        case "gas":
            return .blue
        case "rent":
            return .orange
        case "shopping":
            return .purple
        default:
            return .gray
        }
    }
}
