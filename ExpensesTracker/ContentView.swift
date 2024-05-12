//
//  ContentView.swift
//  ExpensesTracker
//
//  Created by Dylan Inafuku on 5/5/24.
//

import SwiftUI

struct ContentView: View {
    // Initialized transactions array to store and hold transactions
    @State private var transactions: [Transaction] = [
        Transaction(category: "Food", description: "Hmart", amount: -120.00),
        Transaction(category: "Gas", description: "Chevron", amount: -60.00),
        Transaction(category: "Rent", description: "Monthly rent payment", amount: -1100.00)
    ]
    
    // create a state variable for showAddExpenseView to pull up that view
    @State private var showAddExpenseView = false
    
    var body: some View {
        // create a tab view at the bottom fo the screen to navigate through pages
        TabView {
            NavigationView {
                VStack {
                    // Display the list of transactions
                    List {
                        ForEach(transactions) { transaction in
                            NavigationLink(destination: ExpenseDetail(transaction: transaction)) {
                                TransactionRow(transaction: transaction)
                            }
                        }
                        // allow for deletion and movement of list entries
                        .onDelete(perform: deleteTransaction)
                        .onMove(perform: moveTransaction)
                    }
                    // create bar title and way to navigate to add expense view
                    .navigationBarTitle("Home")
                    .navigationBarItems(leading: addButton, trailing: EditButton())
                    .sheet(isPresented: $showAddExpenseView) {
                        AddExpenseView(isPresented: self.$showAddExpenseView, addTransaction: self.addTransaction)
                    }
                }
            }
            // indicate tab icon for home page
            .tabItem {
                Image(systemName: "house.circle.fill")
                Text("Home")
            }
            
            // navigate to expense pie graph page from tab item
            ExpensePieGraphPage(expenses: transactions)
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("Expense Pie Graph")
                }
            
            // navigate to expenses organized page when tab item is clicked
            NavigationView {
                ExpensesOrganized(transactions: transactions)
            }
            .tabItem {
                Image(systemName: "list.dash")
                Text("Expense Organized")
            }
        }
        .overlay(
            // this divider is a small gray line to separate the views from the tab items visually
            Divider()
                .background(Color.gray)
                .edgesIgnoringSafeArea(.horizontal)
                .frame(height: 110),
            alignment: .bottom
        )
    }
    
    // functions for add button
    private var addButton: some View {
        Button(action: {
            self.showAddExpenseView.toggle()
        }) {
            Text("Add")
        }
    }
    // adds transaction to list
    func addTransaction(transaction: Transaction) {
        transactions.append(transaction)
    }
    // removes transaction frmo list
    func deleteTransaction(at offsets: IndexSet) {
        transactions.remove(atOffsets: offsets)
    }
    // moves transactinos accordingly
    func moveTransaction(from source: IndexSet, to destination: Int) {
        transactions.move(fromOffsets: source, toOffset: destination)
    }
}

// create transaction row view
struct TransactionRow: View {
    var transaction: Transaction
    
    var body: some View {
        // every transaction should consist of a colored icon for the category and description
        HStack {
            // utilizing sf symbols for the icons
            let (symbolName, symbolColor) = icon(for: transaction.category)
            Image(systemName: symbolName)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(symbolColor)
            // display transaction amount in red
            VStack(alignment: .leading) {
                Text(transaction.description)
                Text(String(format: "$%.2f", transaction.amount))
                    .foregroundColor(transaction.amount < 0 ? .red : .black)
            }
            Spacer()
        }
    }
    
    // function to get SF Symbol name and color based on category
    private func icon(for category: String) -> (String, Color) {
        switch category.lowercased() {
        case "food":
            return ("leaf.fill", .green) // SF Symbol for Food
        case "gas":
            return ("car.fill", .blue) // SF Symbol for Gas
        case "rent":
            return ("house.fill", .orange) // SF Symbol for Rent
        case "shopping":
            return ("cart.fill", .purple) // SF Symbol for Shopping
        default:
            return ("square.and.pencil", .gray) // Default SF Symbol for Other
        }
    }
}

// create transaction struct
struct Transaction: Identifiable {
    let id = UUID()
    let category: String
    let description: String
    let amount: Double
}

#Preview {
    ContentView()
}
