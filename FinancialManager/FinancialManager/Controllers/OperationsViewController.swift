//
//  OperationsViewController.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 08/01/21.
//

import UIKit

class OperationsViewController: UIViewController {
    
    
    @IBOutlet weak var titleOperation: UILabel!
    @IBOutlet weak var amountOperation: UILabel!
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var newOperation: UIButton!
    @IBOutlet weak var segmentedOperation: UISegmentedControl!
    @IBOutlet weak var operationsTable: UITableView!
    
    let expenses = ExpenseManager().mockData
    let incomes = IncomeManager().mockData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setSegmentedOperation()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch segmentedOperation.selectedSegmentIndex {
            case 0:
                amountOperation.text = "R$ \(ExpenseManager().totalExpenses())"
            default:
                amountOperation.text = "R$ \(IncomeManager().totalIncomes())"
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
                titleOperation.text = "Despesas Totais"
                amountOperation.text = "R$ \(ExpenseManager().totalExpenses())"
            default:
                segmentedOperation.selectedSegmentTintColor = .incomeSegmented
                titleOperation.text = "Receitas Totais"
                amountOperation.text = "R$ \(IncomeManager().totalIncomes())"

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
        let storyboard = UIStoryboard(name: "CreateAndEditOperation", bundle: nil)
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
        print("Selecionou a célula: \(indexPath.row)")
    }
}
