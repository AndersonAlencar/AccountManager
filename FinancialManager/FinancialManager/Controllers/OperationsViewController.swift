//
//  OperationsViewController.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 08/01/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class OperationsViewController: UIViewController {
    
    
    @IBOutlet weak var titleOperation: UILabel!
    @IBOutlet weak var amountOperation: UILabel!
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var newOperation: UIButton!
    @IBOutlet weak var segmentedOperation: UISegmentedControl!
    @IBOutlet weak var operationsTable: UITableView!
    
    let expenseManager = ExpenseManager.shared
    let incomeManager = IncomeManager.shared
    var expenseListener: ListenerRegistration!
    var incomeListener: ListenerRegistration!
    
    var expenses = [Expense]()
    var incomes = [Income]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setSegmentedOperation()
        configureTableView()
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
                if segmentedOperation.selectedSegmentIndex == 0 {
                    operationsTable.reloadData()
                }
                updateAmount()
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
                if segmentedOperation.selectedSegmentIndex == 1 {
                    operationsTable.reloadData()
                }
                updateAmount()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        expenseListener.remove()
        incomeListener.remove()
    }
    
    func updateAmount() {
        switch segmentedOperation.selectedSegmentIndex {
            case 0:
                amountOperation.text = "R$ \(expenseManager.totalExpenses(expenses: expenses))".replacingOccurrences(of: ".", with: ",")
            default:
                amountOperation.text = "R$ \(incomeManager.totalIncomes(incomes: incomes))".replacingOccurrences(of: ".", with: ",")
        }
    }
    
    func setSegmentedOperation() {
        segmentedOperation.backgroundColor = .clear
        segmentedOperation.tintColor = .clear
        segmentedOperation.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        segmentedOperation.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 21), NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedOperation.addTarget(self, action: #selector(handleSegmentedOperation), for: .valueChanged)
    }
    
    @objc func handleSegmentedOperation() {
        switch segmentedOperation.selectedSegmentIndex {
            case 0:
                segmentedOperation.selectedSegmentTintColor = .expenseSegmented
                titleOperation.text = "Despesas Pendentes"
                amountOperation.text = "R$ \(expenseManager.totalExpenses(expenses: expenses))"
            default:
                segmentedOperation.selectedSegmentTintColor = .incomeSegmented
                titleOperation.text = "Receitas Recebidas"
                amountOperation.text = "R$ \(incomeManager.totalIncomes(incomes: incomes))"

        }
        operationsTable.reloadData()
    }
    
    func configureTableView() {
        operationsTable.delegate = self
        operationsTable.dataSource = self
        operationsTable.tableFooterView = UIView()
        operationsTable.backgroundColor = .primaryColor
        operationsTable.separatorStyle = .none
        operationsTable.register(UINib.init(nibName: "OperationTableViewCell", bundle: nil), forCellReuseIdentifier: "OperationCellIdentifier")
    }
    
    @IBAction func addNewOperation(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "CreateNewOperation", bundle: nil)
        let newOperationController = storyboard.instantiateViewController(withIdentifier: "OperationControllerID") as! UINavigationController
        present(newOperationController, animated: true, completion: nil)
    }
    
}


extension OperationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedOperation.selectedSegmentIndex {
            case 0:
                return expenses.count
            default:
                return incomes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "OperationCellIdentifier", for: indexPath) as! OperationTableViewCell
        cell.selectionStyle = .none
        switch segmentedOperation.selectedSegmentIndex {
            case 0:
                cell.configureCell(descriptionOperation: expenses[indexPath.row].description, value: expenses[indexPath.row].value, date: expenses[indexPath.row].date, statusOperation: expenses[indexPath.row].paymentStatus)
            default:
                cell.configureCell(descriptionOperation: incomes[indexPath.row].description, value: incomes[indexPath.row].value, date: incomes[indexPath.row].date, statusOperation: incomes[indexPath.row].receivedStatus)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "EditOperation", bundle: nil)
        let editOperationController = storyboard.instantiateViewController(withIdentifier: "EditOperationID") as! UINavigationController
        let rootController = editOperationController.topViewController as! EditOperationViewController
        rootController.index = indexPath.row
        if segmentedOperation.selectedSegmentIndex == 0 {
            rootController.documentOperation = expenses[indexPath.row]
        } else {
            rootController.documentOperation = incomes[indexPath.row]

        }
        present(editOperationController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }

    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Deletar") { [self] (action, view, completion) in
            switch segmentedOperation.selectedSegmentIndex {
                case 0:
                    expenseManager.deleteDocument(documentID: expenseManager.documentReferences[indexPath.row])
                default:
                    incomeManager.deleteDocument(documentID: incomeManager.documentReferences[indexPath.row])
            }
            completion(true)
        }
        action.image = UIImage(named: "trash")
        action.backgroundColor = .secondaryColor
        return action
    }
}
