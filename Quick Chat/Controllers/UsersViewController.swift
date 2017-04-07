//
//  UsersViewController.swift
//  Quick Chat
//
//  Created by Nithin Reddy Gaddam on 4/5/17.
//  Copyright © 2017 Nithin Reddy Gaddam. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

var group:Bool = false
//var privateChatID = ""

class UsersViewController: UITableViewController {

    static let cellId = "cellId"
    
    var users: [User] = []
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Users"
        
        //make nav bar darker
        navigationController?.navigationBar.isTranslucent = false
        
        usersRef.observe(.value, with: { snapshot in
            
            var newUsers = Set<User>()
            for user in snapshot.children {
                let currentUser = User(snapshot: user as! FIRDataSnapshot)
                if(currentUser.key != FIRAuth.auth()?.currentUser?.uid){
                    newUsers.insert(currentUser)
                }
            }
            
            //unique users
            self.users = Array(Set(newUsers))
            self.tableView.register(UserCell.self, forCellReuseIdentifier: UsersViewController.cellId)
            
            self.tableView.reloadData()
        })

        tableView.separatorColor = UIColor.rgb(229, green: 231, blue: 235)
        tableView.sectionHeaderHeight = 26
        
        tableView.register(UsersViewCell.self, forCellReuseIdentifier: UsersViewController.cellId)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersViewController.cellId, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        if(user.online == true){
            cell.detailTextLabel?.text = "Online"
            cell.detailTextLabel?.textColor = UIColor.green
        } else {
            cell.detailTextLabel?.text = "Offline"
            cell.detailTextLabel?.textColor = UIColor.red
        }
        
        if let profileimageUrl = FIRAuth.auth()?.currentUser?.photoURL {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileimageUrl.path)
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.tableView.cellForRow(at: indexPath) != nil else { return }
        let tempUser = users[indexPath.row]
        
        let chatLogController = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = tempUser
        navigationController?.pushViewController(chatLogController, animated: true)
        
    }
    
    func toAnyObject(tempUser: User) -> Any {
        return [
            "user1": tempUser.key,
            "user2": FIRAuth.auth()?.currentUser?.uid
        ]
    }
    
}


class UsersViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

