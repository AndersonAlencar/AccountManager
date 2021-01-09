//
//  NewOperationViewController.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 08/01/21.
//

import UIKit

class NewOperationViewController: UIViewController {

    
    @IBOutlet weak var expenseCategory: UIButton!
    @IBOutlet weak var incomeCategory: UIButton!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var valueOperation: UITextField!
    @IBOutlet weak var descriptionOperation: UITextField!
    @IBOutlet weak var dateOperation: UIDatePicker!
    @IBOutlet weak var paymentStatus: UISwitch!
    @IBOutlet weak var descriptorStatus: UILabel!
    
    weak var delegateOperation: OperationsViewController!
    
    var flag = true
    var operation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.view.backgroundColor = .primaryColor
        self.isModalInPresentation = true
        borderTF()
        setDatePicker()
        indicatorView.layer.cornerRadius = 4
        expenseCategory.setTitleColor(.expenseTextColor, for: .normal)
        incomeCategory.setTitleColor(.incomeSegmented, for: .normal)
    }
    
    func borderTF(){
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
    
    func setDatePicker() {
        //dateOperation.maximumDate = Date()
        //dateOperation.preferredDatePickerStyle = .compact
        //dateOperation.tintColor = .incomeSegmented
        dateOperation.backgroundColor = .white
//        let loc = Locale(identifier: "pt-br")
//        dateOperation.locale = loc
//        dateOperation.calendar.locale = loc
        
    }
    
    
    @IBAction func selectExpense(_ sender: UIButton) {
        descriptorStatus.text = "Pago"
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.indicatorView.center.x = self.expenseCategory.center.x
            self.indicatorView.layoutIfNeeded()
            self.indicatorView.superview?.layoutIfNeeded()
        } completion: { [self] finished in
            operation = 0
        }
    }
    
    
    @IBAction func selectIncome(_ sender: Any) {
        descriptorStatus.text = "Recebido"
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) {
            self.indicatorView.center.x = self.incomeCategory.center.x
            self.indicatorView.layoutIfNeeded()
            self.indicatorView.superview?.layoutIfNeeded()
        } completion: { [self] finished in
            operation = 1
            switch flag {
                case true:
                    incomeCategory.sendActions(for: .touchUpInside)
                    flag = false
                default:
                    flag = true
            }
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)

    }
    
    @IBAction func cancelOperation(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveOperation(_ sender: Any) {
        switch operation {
            case 0:
                let formatter = NumberFormatter()
                formatter.locale = Locale(identifier: "pt_BR")

                let value = formatter.number(from: valueOperation.text!) as! Double//Double(valueOperation.text!) ?? 0 as!
                
                var description = "Sem Descrição"
                if let desc = descriptionOperation.text{
                    if !desc.isEmpty {
                        description = desc
                    }
                }
                let expense = Expense(expenseValue: value, description: description, dateOperation: dateOperation.date, paymentStatus: paymentStatus.isOn)
                ExpenseManager.shared.mockData.append(expense)
            default:
                let formatter = NumberFormatter()
                formatter.locale = Locale(identifier: "pt_BR")
                let value = formatter.number(from: valueOperation.text!) as! Double//Double(valueOperation.text!) ?? 0 as!
                
                var description = "Sem Descrição"
                if let desc = descriptionOperation.text{
                    if !desc.isEmpty {
                        description = desc
                    }
                }
                let income = Income(incomeValue: value, description: description, dateOperation: dateOperation.date, receivedStatus: paymentStatus.isOn)
                IncomeManager.shared.mockData.append(income)
        }
        delegateOperation.reloadData()
        dismiss(animated: true, completion: nil)

    }
}
