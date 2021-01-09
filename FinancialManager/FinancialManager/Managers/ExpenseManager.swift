//
//  ExpenseManager.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 08/01/21.
//

import Foundation


struct ExpenseManager {
    
    var mockData = [Expense(expenseValue: 250.86, description: "Viagem pra caponga", dateOperation: Date(), paymentStatus: true),
                    Expense(expenseValue: 32.43, description: "Vinho do bom", dateOperation: Date(), paymentStatus: false),
                    Expense(expenseValue: 76.98, description: "Jantar com o viado", dateOperation: Date(), paymentStatus: true),
                    Expense(expenseValue: 233.23, description: "Fatura Nubank", dateOperation: Date(), paymentStatus: false)]
    
    func totalExpenses() -> String {
        var amount: Double = 0
        for expense in mockData {
            if expense.paymentStatus == false {
                amount += expense.value
            }
        }
        return String(format: "%.2f", amount)
    }
}
