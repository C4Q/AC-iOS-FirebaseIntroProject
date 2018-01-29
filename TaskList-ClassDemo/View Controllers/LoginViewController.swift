//
//  ViewController.swift
//  TaskList-ClassDemo
//
//  Created by C4Q  on 1/29/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let (email, pass) = getUserEmailAndPass()
        FirebaseAPIClient.manager.login(with: email, and: pass){(user, error) in
            if let error = error {
                print(error)
                return
            }
            if let _ = user {
                self.performSegue(withIdentifier: "Segue From Login", sender: self)
            }
        }
    }
    
    @IBAction func createNewAccountButtonPressed(_ sender: UIButton) {
        let (email, pass) = getUserEmailAndPass()
        FirebaseAPIClient.manager.createAccount(with: email, and: pass){(user, error) in
            guard error == nil else { print(error!); return }
            guard let _ = user else {print("no user"); return }
            self.performSegue(withIdentifier: "Segue From Login", sender: self)
        }
    }
    
    func getUserEmailAndPass() -> (String, String) {
        //TO DO - Validate name and pass and check for nil
        let name = emailTextField.text!
        let pass = passwordTextField.text!
        return (name,pass)
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        FirebaseAPIClient.manager.logOutCurrentUser()
    }
}

