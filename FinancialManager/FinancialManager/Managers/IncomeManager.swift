//
//  IncomeManager.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 08/01/21.
//

import Foundation
import Firebase
import FirebaseFirestore

class IncomeManager: FirebaseProtocol {
    private let dataBase = Firestore.firestore()
    let collectionReference: CollectionReference!
    var documentReferences = [String]()

    static let shared: IncomeManager = {
        return IncomeManager()
    }()
    
    var mockData = [Income]()
    
    func totalIncomes(incomes: [Income]) -> String {
        var amount: Double = 0
        for income in incomes {
            if income.receivedStatus == true {
                amount += income.value
            }
        }
        return String(format: "%.2f", amount)
    }
    
    private init () {
        collectionReference = dataBase.collection("incomeColletion")
    }
    
    func addNewDocument(dataDocument dataIncome: [String:Any]) {
        var ref: DocumentReference? = nil
        ref = collectionReference.addDocument(data: dataIncome) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func updateDocument(dataDocument dataExpense: [String:Any], documentID: String) {
        let docReference = collectionReference.document(documentID)
        docReference.setData(dataExpense) { (error) in
            if let error = error {
                print("Error update document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func deleteDocument(documentID: String) {
        let docRefence = collectionReference.document(documentID)
        docRefence.delete { (error) in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func incomeAmount(incomes: [Income], received: Bool) -> String {
        var amount:Double = 0
        if received == true {
            for income in incomes {
                if income.receivedStatus == true {
                    amount += income.value
                }
            }
        } else {
            for income in incomes {
                if income.receivedStatus == false {
                    amount += income.value
                }
            }
        }
        return String(format: "%.2f", amount).replacingOccurrences(of: ".", with: ",")
    }
    
    func amount(incomes: [Income]) -> Double {
        var amount: Double = 0
        for income in incomes {
            amount += income.value
        }
        return amount
    }
    
    func balance(expenses: [Expense], incomes: [Income]) -> String {
        var expenseAmount: Double = 0
        var incomeAmount: Double = 0
        
        for expense in expenses {
            expenseAmount += expense.value
        }
        
        for income in incomes {
            incomeAmount += income.value
        }
        print(expenseAmount)
        print(incomeAmount)
        if expenseAmount > incomeAmount {
            let absoute = abs((incomeAmount - expenseAmount))
            return "-" + String(format: "%.2f", absoute).replacingOccurrences(of: ".", with: ",")
        } else {
            let absoute = incomeAmount - expenseAmount
            return String(format: "%.2f", absoute).replacingOccurrences(of: ".", with: ",")
        }
    }
}
