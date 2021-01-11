//
//  SignOutAndDeleteViewController.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 11/01/21.
//

import UIKit
import Firebase
import FirebaseAuth

class SignOutAndDeleteViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .primaryColor
        self.isModalInPresentation = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func singOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginControllerID") as! LoginViewController
        present(controller, animated: true, completion: nil)
    }
}
