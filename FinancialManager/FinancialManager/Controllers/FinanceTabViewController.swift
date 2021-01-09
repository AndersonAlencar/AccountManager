//
//  FinanceTabViewController.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 08/01/21.
//

import UIKit

class FinanceTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        tabBar.barTintColor = .secondaryColor
        tabBar.isTranslucent = false
        
        tabBar.tintColor = .orange
        tabBar.unselectedItemTintColor = .lightGray
        // Do any additional setup after loading the view.
    }

}
