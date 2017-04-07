//
//  ChatLogViewController.swift
//  Quick Chat
//
//  Created by Nithin Reddy Gaddam on 4/6/17.
//  Copyright © 2017 Nithin Reddy Gaddam. All rights reserved.
//

import UIKit
import Firebase

class ChatLogViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Chats"
        
        //make nav bar darker
        navigationController?.navigationBar.isTranslucent = false
    
    }
    
}
