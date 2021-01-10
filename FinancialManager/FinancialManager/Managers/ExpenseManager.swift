//
//  ExpenseManager.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 08/01/21.
//

import Foundation
import Firebase
import FirebaseFirestore


class ExpenseManager {
    
    //firebase persistense
    private let dataBase = Firestore.firestore()
    
    let collectionReference: CollectionReference!
    
    static let shared: ExpenseManager = {
        return ExpenseManager()
    }()
    
    var mockData = [Expense]()//Expense(expenseValue: 250.86, description: "Viagem para caponga", dateOperation: Date(), paymentStatus: true),
                    //Expense(expenseValue: 32.43, description: "Vinho do bom", dateOperation: Date(), paymentStatus: false),
                    //Expense(expenseValue: 76.98, description: "Jantar com o viado", dateOperation: Date(), paymentStatus: true),
                    //Expense(expenseValue: 233.23, description: "Fatura Nubank", dateOperation: Date(), paymentStatus: false)]
    var documentReferences = [String]()
    
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
    
    func addNewExpense(dataExpense: [String:Any]) {
        var ref: DocumentReference? = nil
        ref = collectionReference.addDocument(data: dataExpense) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func getAllExpenses() {
        let query = collectionReference.order(by: "date")
        query.getDocuments { (querySnapchot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapchot!.documents {
                    let expense = Expense(dict: document.data())
                    self.mockData.append(expense)
                    self.documentReferences.append(document.documentID)
                }
            }
        }
    }
    
    func editExpense(dataExpense: [String:Any], documentID: String) {
        let docReference = collectionReference.document(documentID)
        docReference.setData(dataExpense) { (error) in
            if let error = error {
                print("Error update document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func deleteExpense(documentID: String) {
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
