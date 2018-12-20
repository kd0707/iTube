////
////  FacebookManager.swift
////  iTube
////
////  Created by Kamaluddin Khan on 13/11/18.
////  Copyright © 2018 Kamaluddin Khan. All rights reserved.
////
//
//import Foundation
//class FacebookManager {
//    
//    var faceBookLoginManger = FBSDKLoginManager()
//    faceBookLoginManger.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], handler: { (result, error)-> Void in
//    //result is FBSDKLoginManagerLoginResult
//    if (error != nil)
//    {
//    print("error is \(error)")
//    }
//    if (result!.isCancelled)
//    {
//    //handle cancelations
//    }
//    if result!.grantedPermissions.contains("email")
//    {
//    self.returnUserData()
//    }
//    })
//    
//    
//}
//
//func returnUserData()
//{
//    let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
//    graphRequest.start(completionHandler: { (connection, result, error) -> Void in
//        
//        if ((error) != nil)
//        {
//            // Process error
//            print("Error: \(error)")
//        }
//        else
//        {
//            print("the access token is \(FBSDKAccessToken.current().tokenString)")
//            
//            var accessToken = FBSDKAccessToken.current().tokenString
//            
//            var userID = result
//            var facebookProfileUrl = "http://graph.facebook.com/\(userID)/picture?type=large"
//            
//            
//            
//            print("fetched user: \(result)")
//            
//            
//        }
//    })
//}
//    
//}




//MARK:- From Login

//
////        let fbLoginManager = FBSDKLoginManager()
////        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
////            if let error = error {
////                print("Error Logging In \(error.localizedDescription)")
////                return
////            }
////
////            guard let accessToken = FBSDKAccessToken.current() else {
////                print("Failed to get access token")
////                return
////            }
////
////            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
////
////            Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
////                if let error = error {
////                    print("Login error: \(error.localizedDescription)")
////                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
////                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
////                    alertController.addAction(okayAction)
////                    self.present(alertController, animated: true, completion: nil)
////                    return
////                }
////                print("User Detail................: \(result)")
////                print("Successfully Loggedin using Facebook")
////        let userHomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserHomeViewController") as! UserHomeViewController
////        self.present(userHomeViewController, animated: true)
////            })
////        }
//
//
//
//
////        if (FBSDKAccessToken.current() != nil)
////        {
////            // User is already logged in, do work such as go to next view controller.
////            print("already logged in ")
////            self.returnUserData()
////
////            return
////        }
//
//
//        let faceBookLoginManger = FBSDKLoginManager()
//        faceBookLoginManger.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], handler: { (result, error)-> Void in
//            //result is FBSDKLoginManagerLoginResult
//            if (error != nil)
//            {
//                print("error is \(String(describing: error))")
//                return
//            }
//            if (result!.isCancelled)
//            {
//                //handle cancelations
//                return
//            }
//            if result!.grantedPermissions.contains("email")
//            {
//                self.returnUserData()
//                let userTabViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserTabViewController") as! UserTabViewController
//                self.present(userTabViewController, animated: true)
//
//                self.emailTextField.text = ""
//                self.passwordTextField.text = ""
//
//            }
//        })
//
//
//
//    }
//
//    func returnUserData()
//    {
//        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
//        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
//
//            if ((error) != nil)
//            {
//                // Process error
//                print("Error: \(String(describing: error))")
//            }
//            else
//            {
//                print("the access token is \(String(describing: FBSDKAccessToken.current().tokenString))")
//
//                var accessToken = FBSDKAccessToken.current().tokenString
//
//                var userID = result
//                var facebookProfileUrl = "http://graph.facebook.com/\(String(describing: userID))/picture?type=large"
//
//
//
//                print("fetched user: \(String(describing: result))")
//
//
//            }
//        })
//    }
//
//
//
//
//    @IBAction func signInButtonTabbed(_ sender: Any) {
//        let email = emailTextField.text!
//        guard email.isEmail else{
//            errorLabel.text = "Enter Valid Email id"
//            return
//        }
//
//        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(results, error) in
//            if let error = error{
//                print("Error",error)
//                return
//            }
//            print("Success:", results)
//            return
//        })
//
//    }
//
//    @IBAction func forgotPasswordButtonTabbed(_ sender: Any) {
//        let forgotPasswordViewController = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
//        self.present(forgotPasswordViewController, animated: true, completion: nil)
//    }
//
//    @IBAction func signUpButtonTabbed(_ sender: Any) {
//
//        let registrationViewController = storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
//
//        self.present(registrationViewController, animated: true, completion: nil)
//
//    }
//}


