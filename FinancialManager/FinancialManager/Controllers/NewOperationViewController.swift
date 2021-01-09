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
    
    var flag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.layer.cornerRadius = 4
        expenseCategory.setTitleColor(.expenseTextColor, for: .normal)
        incomeCategory.setTitleColor(.incomeSegmented, for: .normal)
    }
    
    
    @IBAction func selectExpense(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            self.indicatorView.center.x = self.expenseCategory.center.x
        } completion: { finished in
            print("Acabou a ação 2 !")
        }
    }
    
    
    @IBAction func selectIncome(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            self.indicatorView.center.x = self.incomeCategory.center.x
            self.indicatorView.layoutIfNeeded()
            self.indicatorView.superview?.layoutIfNeeded()
        } completion: { finished in
            print("Acabou a ação 1 !")
            //self.expenseCategory.setTitleColor(.lightGray, for: .normal)
            //self.incomeCategory.setTitleColor(.incomeSegmented, for: .normal)
        }
    }
    
}
