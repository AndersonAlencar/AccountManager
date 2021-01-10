//
//  ExpenseManager.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 08/01/21.
//

import Foundation
import Firebase
import FirebaseFirestore


class ExpenseManager: FirebaseProtocol {
    private let dataBase = Firestore.firestore()
    let collectionReference: CollectionReference!
    var documentReferences = [String]()
    
    static let shared: ExpenseManager = {
        return ExpenseManager()
    }()

    private init() {
        collectionReference = dataBase.collection("expenseColletion")
    }
    
    func totalExpenses(expenses: [Expense]) -> String {
        var amount: Double = 0
        for expense in expenses {
            if expense.paymentStatus == false {
                amount += expense.value
            }
        }
        return String(format: "%.2f", amount)
    }
    
    func addNewDocument(dataDocument dataExpense: [String:Any]) {
        var ref: DocumentReference? = nil
        ref = collectionReference.addDocument(data: dataExpense) { (error) in
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
}
