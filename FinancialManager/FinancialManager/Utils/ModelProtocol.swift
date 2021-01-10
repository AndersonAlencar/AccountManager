//
//  ModelProtocol.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 10/01/21.
//

import Foundation


protocol ModelProtocol {
    var value: Double { get set }
    var description: String { get set }
    var date: Date { get set }
}

extension ModelProtocol {
    var status: Bool{
        get {
            if let expense = self as? Expense {
                return expense.paymentStatus
            } else {
                return (self as! Income).receivedStatus
            }
        }
    }
    
    var statusDescription: String{
        get {
            if self is Expense {
                return "Pago"
            } else {
                return "Recebido"
            }
        }
    }
}
