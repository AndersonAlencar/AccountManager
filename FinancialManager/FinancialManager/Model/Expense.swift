//
//  Expense.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 08/01/21.
//

import Foundation


class Expense: Codable {
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
    
    convenience init(dict: [String : Any]) {
        let paymentStatus: Bool!
        if dict["paymentStatus"] as! Int == 0 {
            paymentStatus = false
        } else {
            paymentStatus = true
        }
        let dc = dict["date"] as! Double
        self.init(expenseValue: dict["value"] as! Double, description: dict["description"] as! String, dateOperation: Date(timeIntervalSinceReferenceDate: dc), paymentStatus: paymentStatus)
    }
}
