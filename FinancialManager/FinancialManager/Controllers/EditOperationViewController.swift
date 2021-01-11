//
//  EditOperationViewController.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 10/01/21.
//

import UIKit

class EditOperationViewController: UIViewController {

    
    
    @IBOutlet weak var valueOperation: FloatingLabelInput!
    @IBOutlet weak var descriptionOperation: FloatingLabelInput!
    @IBOutlet weak var dateOperation: UIDatePicker!
    @IBOutlet weak var descriptorStatus: UILabel!
    @IBOutlet weak var paymentStatus: UISwitch!
    
    lazy var expenseManager: ExpenseManager = {
        return ExpenseManager.shared
    }()
    
    lazy var incomeManager: IncomeManager = {
        return IncomeManager.shared
    }()
    
    var documentOperation: ModelProtocol!
    var index: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .primaryColor
        editBorderTF()
        loadLayout()
        self.isModalInPresentation = true
    }
    
    func loadLayout() {
        valueOperation.text = "\(documentOperation.value)".replacingOccurrences(of: ".", with: ",")
        descriptionOperation.text = "\(documentOperation.description)"
        dateOperation.date = documentOperation.date
        descriptorStatus.text = "\(documentOperation.statusDescription)"
        paymentStatus.isOn = documentOperation.status
        if documentOperation is Expense {
            navigationItem.title = "Despesa"
        } else {
            navigationItem.title = "Receita"
        }
    }
    
    func editBorderTF(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: valueOperation.frame.height - 1, width: valueOperation.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        valueOperation.borderStyle = UITextField.BorderStyle.none
        valueOperation.layer.addSublayer(bottomLine)
        valueOperation.attributedPlaceholder = NSAttributedString(string: "Valor", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0.0, y: descriptionOperation.frame.height - 1, width: descriptionOperation.frame.width, height: 1.0)
        bottomLine2.backgroundColor = UIColor.white.cgColor
        descriptionOperation.borderStyle = UITextField.BorderStyle.none
        descriptionOperation.layer.addSublayer(bottomLine2)
        descriptionOperation.attributedPlaceholder = NSAttributedString(string: "Descrição", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    
    @IBAction func cancelEdition(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveEdition(_ sender: Any) {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        let value = formatter.number(from: valueOperation.text!) as! Double
        var description = "Sem Descrição"
        
        if let desc = descriptionOperation.text{
            if !desc.isEmpty {
                description = desc
            }
        }
        if documentOperation is Expense {
            let expense = Expense(expenseValue: value, description: description, dateOperation: dateOperation.date, paymentStatus: paymentStatus.isOn)
            expenseManager.updateDocument(dataDocument: expense.dictionary, documentID: expenseManager.documentReferences[index])
        } else {
            let income = Income(incomeValue: value, description: description, dateOperation: dateOperation.date, receivedStatus: paymentStatus.isOn)
            incomeManager.updateDocument(dataDocument: income.dictionary, documentID: incomeManager.documentReferences[index])
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
