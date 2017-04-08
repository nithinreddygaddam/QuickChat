//
//  LoginViewController.swift
//  Quick Chat
//
//  Created by Nithin Reddy Gaddam on 4/5/17.
//  Copyright © 2017 Nithin Reddy Gaddam. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        txtEmail.delegate = self
        txtPassword.delegate = self
    }
    
    
    @IBAction func btnLoginAct(_ sender: Any) {
        //check if values are not nil
        if(txtEmail.text != nil && txtPassword.text != nil){
            // sign in the user
            self.signIn(self.txtEmail.text!, passwordField: self.txtPassword.text!)
            
        }
    }
    
    @IBAction func btnSignUpAct(_ sender: Any) {
        let alert = UIAlertController(title: "Sign Up",
                                      message: "",
                                      preferredStyle: .alert)
        
        let registerAction = UIAlertAction(title: "Register",
                                       style: .default) { action in
                                        
                                        //get the fields
                                        let nameField = alert.textFields![0]
                                        let emailField = alert.textFields![1]
                                        let passwordField = alert.textFields![2]
                                        
                                        
                                        //check if values are not nil
                                        if(emailField.text != nil && passwordField.text != nil && nameField.text != nil){
                                            // register the user
                                            FIRAuth.auth()!.createUser(withEmail: emailField.text!,
                                                                       password: passwordField.text!) { user, error in
                                                                        if error == nil {
                                                                            
                                                                            //save the name
                                                                            let user = FIRAuth.auth()?.currentUser
                                                                            if let user = user {
                                                                                let changeRequest = user.profileChangeRequest()
                                                                                
                                                                                changeRequest.displayName = nameField.text
                                                                                changeRequest.photoURL =
                                                                                    NSURL(string: "http://www.freeiconspng.com/uploads/profile-icon-9.png") as URL?
                                                                                changeRequest.commitChanges { error in
                                                                                    if error != nil {
                                                                                        // An error happened.
                                                                                    } else {
                                                                                        
                                                                                    }
                                                                                }
                                                                                
                                                                                let usersRef = FIRDatabase.database().reference(withPath: "users")
                                                                                
                                                                                let currentUser = User(key: (user.uid), name: nameField.text!, online: false)
                                                                                let currentUserRef = usersRef.child((user.uid))
                                                                                currentUserRef.setValue(currentUser.toAnyObject())
                                                                                
                                                                                // sign in the user
                                                                                self.signIn(emailField.text!, passwordField: passwordField.text!)
                                                                            }
                                                                            
                                                                            
                                                                        }
                                            }
                                        } else {
                                            let alert = UIAlertController(title: "Error", message: "Please check the credentials", preferredStyle: .alert)
                                            let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                                            
                                            alert.addAction(retryAction)
                                            
                                            self.present(alert, animated: true, completion: nil)
                                        }

        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textName in
            textName.placeholder = "Enter your name"
        }
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(registerAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func signIn(_ emailField:String, passwordField:String){
        //check if values are not nil
        if(emailField != "" && passwordField != ""){
            // register the user
            FIRAuth.auth()?.signIn(withEmail: emailField, password: passwordField) {
                (user, error) in
                if(error == nil){
                    if let user = FIRAuth.auth()?.currentUser {
                        if !user.isEmailVerified{
                            let alert = UIAlertController(title: "Verify", message: "E-mail not verified. Send another verification e-mail to \(emailField) ?", preferredStyle: .alert)
                            let okayAction = UIAlertAction(title: "Okay", style: .default) {
                                (_) in
                                user.sendEmailVerification(completion: nil)
                            }
                            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                            
                            alert.addAction(okayAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            
                            //make user online
                            let usersRef = FIRDatabase.database().reference(withPath: "users")
                            
                            usersRef.observe(.value, with: { snapshot in
                                
                                for user in snapshot.children {
                                    let currentUser = User(snapshot: user as! FIRDataSnapshot)
                                    
                                    if(currentUser.key == FIRAuth.auth()?.currentUser?.uid){
                                        currentUser.ref?.updateChildValues([
                                            "online": true
                                            ])
                                        let currentUserRef = usersRef.child(currentUser.key)
                                        currentUserRef.onDisconnectSetValue(currentUser.toOffline())
                                        
                                        let tabBarViewController:TabBarViewController = TabBarViewController()
                                        self.present(tabBarViewController, animated: true, completion: nil)
                                    }
                                }
                                
                            })
                            
                            
                        }
                    } else {
                        self.checkCredentialsAlert()
                    }
                }  else {
                    self.checkCredentialsAlert()
                }

            }
        } else {
            self.checkCredentialsAlert()
        }
        
    }
    
    func checkCredentialsAlert(){
        let alert = UIAlertController(title: "Error", message: "Please check the credentials", preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
        alert.addAction(retryAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtEmail.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
        return true
    }

}


