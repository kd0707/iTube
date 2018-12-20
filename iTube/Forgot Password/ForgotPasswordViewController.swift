//
//  ForgotPasswordViewController.swift
//  iTube
//
//  Created by Kamaluddin Khan on 13/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import UIKit
//import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    
    @IBOutlet weak var resetEmailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        resetEmailTextField.setBottomBorder()
        
    }
    @IBAction func sentResetLinkTabbed(_ sender: Any) {
        
        //        let resetEmail = resetEmailTextField.text
        //        Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
        //            if error != nil{
        //                let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
        //                resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //                self.present(resetFailedAlert, animated: true, completion: nil)
        //            }else {
        //                let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
        //                resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
        //                    self.dismiss(animated: true, completion: nil)
        //
        //                }))
        //                self.present(resetEmailSentAlert, animated: true, completion: nil)
        //            }
        //        })
    }
    
    @IBAction func cancelButtonTabbed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
