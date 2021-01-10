//
//  Income.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 08/01/21.
//

import Foundation

class Income: Codable, ModelProtocol {
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
    
    convenience init(dict: [String : Any]) {
        let receivedStatus: Bool!

        if dict["receivedStatus"] as! Int == 0 {
            receivedStatus = false
        } else {
            receivedStatus = true
        }

        let dc = dict["date"] as! Double
        self.init(incomeValue: dict["value"] as! Double, description: dict["description"] as! String, dateOperation: Date(timeIntervalSinceReferenceDate: dc), receivedStatus: receivedStatus)
    }

//    func documentInformations(at index: Int) -> (value: Double, description: String, date: Date, statusOperation: Bool, index: Int) {
//        return (self.value,self.description,self.date,self.receivedStatus,index)
//    }
}
