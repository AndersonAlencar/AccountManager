//
//  IncomeManager.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 08/01/21.
//

import Foundation


class IncomeManager {
    
    static let shared: IncomeManager = {
        return IncomeManager()
    }()
    
    var mockData = [Income(incomeValue: 254.54, description: "Aluguel da Maria", dateOperation: Date(), receivedStatus: true),
                    Income(incomeValue: 1300.76, description: "Salário", dateOperation: Date(), receivedStatus: false),
                    Income(incomeValue: 37.67, description: "Pagamento do Felipe", dateOperation: Date(), receivedStatus: true),
                    Income(incomeValue: 89.76, description: "Reembolso de Viagem", dateOperation: Date(), receivedStatus: false)]
    
    
    func totalIncomes() -> String {
        var amount: Double = 0
        for expense in mockData {
            if expense.receivedStatus == true {
                amount += expense.value
            }
        }
        return String(format: "%.2f", amount)
    }
    
    private init () {
        
    }
}
