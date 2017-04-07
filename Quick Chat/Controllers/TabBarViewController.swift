//
//  TabBarViewController.swift
//  Quick Chat
//
//  Created by Nithin Reddy Gaddam on 4/5/17.
//  Copyright © 2017 Nithin Reddy Gaddam. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userController = UsersViewController()
        let navigationController = UINavigationController(rootViewController: userController)
        navigationController.title = "Users"
        navigationController.tabBarItem.image = #imageLiteral(resourceName: "Users")
        
        let groupController = GroupsViewController()
        let secondNavigationController = UINavigationController(rootViewController: groupController)
        secondNavigationController.title = "Groups"
        secondNavigationController.tabBarItem.image = #imageLiteral(resourceName: "Groups")
        
        let chatLogController = ChatLogViewController()
        let thirdNavigationController = UINavigationController(rootViewController: chatLogController)
        thirdNavigationController.title = "Chat"
        thirdNavigationController.tabBarItem.image = #imageLiteral(resourceName: "Chat")
        
        let settingsViewController = SettingsViewController()
        let fourthNavigationController = UINavigationController(rootViewController: settingsViewController)
        fourthNavigationController.title = "Settings"
        fourthNavigationController.tabBarItem.image = #imageLiteral(resourceName: "Settings")
        
        viewControllers = [navigationController, secondNavigationController, thirdNavigationController, fourthNavigationController]
    }
}
