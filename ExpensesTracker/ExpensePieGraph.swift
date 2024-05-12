//
//  ExpensePieGraph.swift
//  ExpensesTracker
//
//  Created by Dylan Inafuku on 5/6/24.
//

import SwiftUI
import Charts

// struct for pie graph page
struct ExpensePieGraphPage: View {
    // expense is an array of transactions
    let expenses: [Transaction]
    
    var body: some View {
        // sort expenses
        let sortedExpenses = expenses.sorted { $0.category < $1.category }
        // ensure display when empty
        if sortedExpenses.isEmpty {
            Text("No expenses to display")
                .navigationBarTitle("Expense Pie Graph")
        } else {
            NavigationView {
                // show pie graph if not empty
                ExpensePieGraph(expenses: sortedExpenses)
                    .navigationBarTitle("Expense Pie Graph")
                    .navigationBarBackButtonHidden(true) // Hide the back button
            }
        }
    }
}

struct ExpensePieGraph: View {
    let expenses: [Transaction]
    
    var body: some View {
        Spacer()
        // get most expensive category to display
        let mostExpensiveCategory = calculateMostExpensiveCategory()
        // use chart to display transaction totals
        Chart(expenses) { transaction in
            SectorMark(
                angle: .value(
                    Text(verbatim: transaction.category),
                    transaction.amount
                ),
                innerRadius: .ratio(0.618)
            )
            .cornerRadius(8)
            .foregroundStyle(
                by: .value(Text(verbatim:transaction.category),transaction.category))
        }
        // add the test inside the pie graph and reframe the size
        .chartBackground { chartProxy in
            GeometryReader{ geometry in
                let frame = geometry[chartProxy.plotAreaFrame]
                VStack{
                    Text("Most Expensive")
                        .font(.title3.bold())
                        .foregroundColor(.black)
                    Text("Category")
                        .font(.title3.bold())
                        .foregroundColor(.black)
                    if let mostExpensiveCategory = mostExpensiveCategory {
                        let textColor = getCategoryColor(mostExpensiveCategory.category)
                        Text(mostExpensiveCategory.category)
                            .font(.headline)
                            .foregroundColor(getCategoryColor(mostExpensiveCategory.category))
                    }
                }
                .position(x:frame.midX,y:frame.midY)
            }
        }
        // edit the key to correspond with category colors
        .chartForegroundStyleScale([
            "Food": getCategoryColor("food"), "Gas": getCategoryColor("gas"), "Rent": getCategoryColor("rent"), "Shopping": getCategoryColor("shopping"), "Other": getCategoryColor("other")
        ])
        .frame(width:350,height:350)
        Spacer()
    }
    
    private func calculateMostExpensiveCategory() -> Transaction? {
        var categoryTotals: [String: Double] = [:]
        
        // Calculate total amount for each category
        for transaction in expenses {
            if let total = categoryTotals[transaction.category] {
                categoryTotals[transaction.category] = total + transaction.amount
            } else {
                categoryTotals[transaction.category] = transaction.amount
            }
        }
        
        // Find the category with the highest total amount
        if let mostExpensiveCategory = categoryTotals.min(by: { $0.value < $1.value }) {
            return Transaction(category: mostExpensiveCategory.key, description: "", amount: mostExpensiveCategory.value)
        }
        
        return nil
    }
    
    // return color by category
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
