//
//  ResumeExpenseViewController.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 08/01/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class ResumeExpenseViewController: UIViewController {

    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var acessoryView: UIView!
    @IBOutlet weak var incomeReceived: UILabel!
    @IBOutlet weak var incomePending: UILabel!
    @IBOutlet weak var expensesPaid: UILabel!
    @IBOutlet weak var expensesPending: UILabel!
    @IBOutlet weak var incomeAmount: UILabel!
    @IBOutlet weak var expenseAmount: UILabel!
    @IBOutlet weak var balance: UILabel!
    
    let expenseManager = ExpenseManager.shared
    let incomeManager = IncomeManager.shared
    var expenseListener: ListenerRegistration!
    var incomeListener: ListenerRegistration!
    
    var expenses = [Expense]()
    var incomes = [Income]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let queryExpense = expenseManager.collectionReference.order(by: "date")
        expenseListener = queryExpense.addSnapshotListener  { [self] (querySnapchot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                expenses.removeAll()
                expenseManager.documentReferences.removeAll()
                var newExpenses = [Expense]()
                for document in querySnapchot!.documents {
                    let expense = Expense(dict: document.data())
                    newExpenses.append(expense)
                    expenseManager.documentReferences.append(document.documentID)
                }
                expenses = newExpenses
                setResume()
            }
        }
        
        let queryIncome = incomeManager.collectionReference.order(by: "date")
        incomeListener = queryIncome.addSnapshotListener  { [self] (querySnapchot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                incomes.removeAll()
                incomeManager.documentReferences.removeAll()
                var newIncomes = [Income]()
                for document in querySnapchot!.documents {
                    let income = Income(dict: document.data())
                    newIncomes.append(income)
                    incomeManager.documentReferences.append(document.documentID)
                }
                incomes = newIncomes
                setResume()
            }
        }
    }

    func setLayout() {
        view.backgroundColor = .primaryColor
        topView.backgroundColor = .secondaryColor
        acessoryView.backgroundColor = .secondaryColor
        incomeReceived.textColor = .acessoryGreen
        
        incomeAmount.textColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
        expenseAmount.textColor = UIColor(red: 0.85, green: 0.12, blue: 0.12, alpha: 1.00)
        balance.textColor = UIColor(red: 0.34, green: 0.84, blue: 0.95, alpha: 1.00)
    }
    
    func setResume() {
        incomeReceived.text = incomeManager.incomeAmount(incomes: incomes, received: true)
        incomePending.text = incomeManager.incomeAmount(incomes: incomes, received: false)
        incomeAmount.text = "\(incomeManager.amount(incomes: incomes))".replacingOccurrences(of: ".", with: ",")
        
        expensesPaid.text = expenseManager.expenseAmount(expenses: expenses, paid: true)
        expensesPending.text = expenseManager.expenseAmount(expenses: expenses, paid: false)
        expenseAmount.text = String(format: "%.2f", expenseManager.amount(expenses: expenses)).replacingOccurrences(of: ".", with: ",")
        
        balance.text = incomeManager.balance(expenses: expenses, incomes: incomes)
    }
    
}
