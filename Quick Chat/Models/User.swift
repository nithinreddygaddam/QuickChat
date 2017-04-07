//
//  User.swift
//  Quick Chat
//
//  Created by Nithin Reddy Gaddam on 4/5/17.
//  Copyright © 2017 Nithin Reddy Gaddam. All rights reserved.
//
import Firebase

struct User : Hashable, Equatable{
    let key: String
    let name: String
    let online: Bool
    let ref: FIRDatabaseReference?
    var hashValue: Int { get { return key.hashValue } }
    
    init(key: String, name: String, online: Bool) {
        self.key = key
        self.name = name
        self.online = online
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        online = snapshotValue["online"] as! Bool
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "online": online
        ]
    }
    
    func toOffline() -> Any {
        return [
            "name": name,
            "online": false
        ]
    }
    
    static func ==(left:User, right:User) -> Bool {
        return left.key == right.key
    }
}
