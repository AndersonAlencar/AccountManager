//
//  Expense.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 08/01/21.
//

import Foundation


class Expense {
    var value: Double
    var description: String
    var date: Date
    var paymentStatus: Bool
    
    init(expenseValue: Double, description: String, dateOperation: Date, paymentStatus: Bool) {
        self.value = expenseValue
        self.description = description
        self.date = dateOperation
        self.paymentStatus = paymentStatus
    }
}
