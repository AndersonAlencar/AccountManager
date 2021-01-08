//
//  Income.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 08/01/21.
//

import Foundation

class Income {
    var value: Double
    var description: String
    var date: Date
    var receivedStatus: Bool
    
    init(incomeValue: Double, description: String, dateOperation: Date, receivedStatus: Bool) {
        self.value = incomeValue
        self.description = description
        self.date = dateOperation
        self.receivedStatus = receivedStatus
    }
}
