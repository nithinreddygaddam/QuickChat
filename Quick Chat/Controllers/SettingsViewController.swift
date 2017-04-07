//
//  SettingsViewController.swift
//  Quick Chat
//
//  Created by Nithin Reddy Gaddam on 4/6/17.
//  Copyright © 2017 Nithin Reddy Gaddam. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Settings"
        
        //make nav bar darker
        navigationController?.navigationBar.isTranslucent = false
        
    }
    
    @IBAction func btnSignOutAct(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginViewController = LoginViewController()
        present(loginViewController, animated: true, completion: nil)

    }
}
