//
//  RegistrationViewController.swift
//  iTube
//
//  Created by Kamaluddin Khan on 12/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import UIKit
//import FirebaseAuth

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        phoneTextField.setBottomBorder()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func faceboogSignInTabbed(_ sender: Any) {
    }
    
    @IBAction func googleSignInTabbed(_ sender: Any) {
    }
    
    @IBAction func registerButtonTabbed(_ sender: Any) {
        //        let email = emailTextField.text
        //        let password = passwordTextField.text
        //        let phone = phoneTextField.text
        
        //        Auth.auth().createUser(withEmail: email!, password: password!) { (success, error) in
        //            if let error = error{
        //                print("Error:", error)
        //                return
        //            }
        //            self.emailTextField.text = ""
        //            self.passwordTextField.text = ""
        //            self.phoneTextField.text = ""
        //            print("Successfully Registered:", success)
        //        }
        
    }
    @IBAction func alreadyRegisteredButtonTabbed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
