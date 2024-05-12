//
//  ExpenseDetail.swift
//  ExpensesTracker
//
//  Created by Dylan Inafuku on 5/6/24.
//

import SwiftUI

// expense detail page after clicking on a transaction in home view
struct ExpenseDetail: View {
    // define transaction
    let transaction: Transaction
    // use a state variable for the color
    @State private var changeColor = false
    
    var body: some View {
        VStack {
            // use a form style
            Form {
                Section(header: Text("Expense Details")) {
                    // shows icon for view
                    Image(systemName: icon(for: transaction.category).0)
                        .resizable()
                        .cornerRadius(12.0)
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .foregroundColor(icon(for: transaction.category).1)
                    // show category
                    Text("Category: \(transaction.category)")
                        .font(.headline)
                        .foregroundColor(changeColor ? .red : .primary)
                    // show description
                    Text("Description: \(transaction.description)")
                        .font(.body)
                        .foregroundColor(changeColor ? .red : .primary)
                    // show amount
                    Text("Amount: \(String(format: "$%.2f", transaction.amount))")
                        .font(.body)
                        .foregroundColor(changeColor ? .red : .primary)
                }
            }
        }
        .navigationBarTitle("Expense Detail")
    }
    // get icon with respective color for category
    private func icon(for category: String) -> (String, Color) {
        switch category.lowercased() {
        case "food":
            return ("leaf.fill", .green)
        case "gas":
            return ("car.fill", .blue)
        case "rent":
            return ("house.fill", .orange)
        case "shopping":
            return ("cart.fill", .purple)
        default:
            return ("square.and.pencil", .gray)
        }
    }
}
