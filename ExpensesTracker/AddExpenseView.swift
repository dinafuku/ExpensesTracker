//
//  AddExpenseView.swift
//  ExpensesTracker
//
//  Created by Dylan Inafuku on 5/6/24.
//

import SwiftUI

// view to add expenses
struct AddExpenseView: View {
    @Binding var isPresented: Bool
    var addTransaction: (Transaction) -> Void
    
    @State private var category = "Food"
    @State private var description = ""
    @State private var amount = ""
    
    let categories = ["Food", "Gas", "Rent", "Shopping", "Other"]
    
    var body: some View {
        // form view
        Form {
            // have an icon for the page at the top
            Section(header: Text("Expense Details")) {
                Image(systemName: "dollarsign.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 250)
                    .padding()
                    .foregroundColor(.yellow)
                // get an input from the user for the category of the transaction
                DataInput(title: "Description", userInput: $description)
                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) {
                        Text($0)
                    }
                }
                // get amount of the transaction
                DataInput(title: "Amount", userInput: $amount)
                    .keyboardType(.decimalPad)
            }
            // add expense but ensure the amount is negative
            Button(action: {
                if let amount = Double(self.amount) {
                    let adjustedAmount = amount > 0 ? -amount : amount
                    let transaction = Transaction(category: self.category, description: self.description, amount: adjustedAmount)
                    self.addTransaction(transaction)
                    self.isPresented = false
                }
            }) {
                Text("Add Expense")
            }
        }
        .navigationBarTitle("Add Expense")
    }
}
// data input struct for add view
struct DataInput: View {
    var title: String
    @Binding var userInput: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            TextField("Enter \(title)", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
    }
}
