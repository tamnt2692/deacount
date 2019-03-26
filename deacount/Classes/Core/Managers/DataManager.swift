//
//  DataManager.swift
//  deacount
//
//  Created by tamnt5 on 3/23/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit
import CoreData

protocol DataManagerDelegate : AnyObject {
    func dataManagerDidChange(_manager: DataManager, _type: DataChange, _data: Any)
}

class DataManager: NSObject, NSCoding {
    
    var users:Dictionary<String, User> = Dictionary<String, User>()
    var groups:Dictionary<String, Group> = Dictionary<String, Group>()
    var records:Dictionary<String, Record> = Dictionary<String, Record>()
    var transactions:Dictionary<String, Transaction> = Dictionary<String, Transaction>()
    var delegates:Dictionary<String, WeakBox<AnyObject>> = Dictionary<String, WeakBox<AnyObject>>()
    private(set) var filePath:String? = ""
    private(set) var createdUsers:Bool = false
    private(set) var loadedUsers:Bool = false
    
    private var _lock:pthread_rwlock_t = pthread_rwlock_t()
    
    // MARK: init
    static let shared = DataManager()
    private override init() {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        let _filePath:String = url!.appendingPathComponent("Setting").path
        self.filePath = _filePath
    }
    
    // MARK: public
    public func loadWhenStartApp() {
        self.loadSetting()
        self.createDataIfNeeded()
        self.loadData()
    }
    
    public func getTransactions(_transactionIDs: Array<String>) -> Array<Transaction> {
        let result = Array(self.transactions.filter { (key, value) -> Bool in
            return (_transactionIDs.contains(key))
            }.values)
        return result
    }
    
    public func getTransaction(_transactionID: String) -> Transaction {
        return self.transactions[_transactionID]!
    }
    
    public func getRecords(_recordIDs: Array<String>) -> Array<Record> {
        let result = Array(self.records.filter { (key, value) -> Bool in
            return (_recordIDs.contains(key))
            }.values)
        return result
    }
    
    public func getRecordsOfDeacount(_deacount: String) -> Dictionary<String, Record> {
        let result = self.records.filter { (key, value) in
            value.deacount == _deacount
        }
        return result
    }
    
    public func getRecord(_recordID: String) -> Record {
        return self.records[_recordID]!
    }
    
    public func getGroup(_groupID: String) -> Group {
        return self.groups[_groupID]!
    }
    
    public func getUser(_userID: String) -> User {
        return self.users[_userID]!
    }
    
    public func getTradable(_tradableID: String) -> Tradable {
        var result:Tradable? = self.groups[_tradableID]
        if (result != nil) {
            return result!
        }
        result = self.users[_tradableID]
        return result!
    }
    
    public func allUser() -> Array<User> {
        return Array(self.users.values)
    }
    
    public func allGroup() -> Array<Group> {
        return Array(self.groups.values)
    }
    
    public func createGroup(_title:String, _des:String, _members:Array<String>) {
        
        let group = Group()
        let id = UUIDBuilder.build()
        group.tradableID = id
        group.title = _title
        group.des = _des
        group.members = _members
        self.groups[id] = group
        
        self.notifyDidCreateGroup(_group: group)
        _ = PersistentManager.shared.addGroupToDB(_group: group)
    }
    
    public func add(_transactions: Dictionary<String, Transaction>, _records:Dictionary<String, Record>) {
        // save mem
        for (transactionID, transaction) in _transactions {
            self.transactions[transactionID] = transaction
        }
        for (recordID, record) in _records {
            self.records[recordID] = record
        }
        
        // notify
        self.notifyDidAddTransactions(_transactions: _transactions)
        self.notifyDidAddRecords(_records: records)
        // save db
        _ = PersistentManager.shared.addTransactionsToDB(_transactions: _transactions)
        _ = PersistentManager.shared.addRecordsToDB(_records: _records)
    }
    
    public func update(_group: Group, _users: Array<User>) {
        // notify
        self.notifyDidUpdateGroup(_group: _group)
        self.notifyDidUpdateUsers(_users: _users)
        // save db
        _ = PersistentManager.shared.updateGroupsToDB(_groups: [_group])
        _ = PersistentManager.shared.updateUsersToDB(_users: _users)
    }
    
    // MARK: notify
    public func register(_delegate: AnyObject) -> String {
        let wbDelegate = WeakBox(_delegate)
        let receipt = UUIDBuilder.build()
        self.delegates[receipt] = wbDelegate
        return receipt
    }
    
    public func unregister(_receipt: String) {
        self.delegates.removeValue(forKey: _receipt)
    }
    
    private func notifyDidCreateGroup(_group:Group) {
        for (_, wb) in self.delegates {
            let delegate = wb.unbox as! DataManagerDelegate
            DispatchQueue.main.async {
                delegate.dataManagerDidChange(_manager: self, _type: .addgroup, _data: _group)
            }
        }
    }
    
    private func notifyDidAddTransactions(_transactions: Dictionary<String, Transaction>) {
        for (_, wb) in self.delegates {
            let delegate = wb.unbox as! DataManagerDelegate
            DispatchQueue.main.async {
                delegate.dataManagerDidChange(_manager: self, _type: .addtransactions, _data: _transactions)
            }
        }
    }
    
    private func notifyDidAddRecords(_records: Dictionary<String, Record>) {
        for (_, wb) in self.delegates {
            let delegate = wb.unbox as! DataManagerDelegate
            DispatchQueue.main.async {
                delegate.dataManagerDidChange(_manager: self, _type: .addrecords, _data: _records)
            }
        }
    }
    
    private func notifyDidUpdateGroup(_group: Group) {
        for (_, wb) in self.delegates {
            let delegate = wb.unbox as! DataManagerDelegate
            DispatchQueue.main.async {
                delegate.dataManagerDidChange(_manager: self, _type: .updategroup, _data: _group)
            }
        }
    }
    
    private func notifyDidUpdateUsers(_users: Array<User>) {
        for (_, wb) in self.delegates {
            let delegate = wb.unbox as! DataManagerDelegate
            DispatchQueue.main.async {
                delegate.dataManagerDidChange(_manager: self, _type: .updateusers, _data: _users)
            }
        }
    }
    
    // MARK: private
    private func loadSetting() {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath!) as? DataManager {
            self.createdUsers = ourData.createdUsers
        }
    }
    
    private func createDataIfNeeded() {
        if (self.createdUsers == false) {
            self.users = PersistentManager.shared.createUsers()
            self.createdUsers = true
            self.loadedUsers = true
            NSKeyedArchiver.archiveRootObject(self, toFile:filePath!)
        }
    }
    
    private func loadData() {
        if (!self.loadedUsers) {
            let users = PersistentManager.shared.loadUsers()
            self.users = users
        }
        self.loadedUsers = true
        self.groups = PersistentManager.shared.loadGroups()
        self.transactions = PersistentManager.shared.loadTransactions()
        self.records = PersistentManager.shared.loadRecords()
        NSLog("")
    }
    
    // MARK: coding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.createdUsers, forKey: DataManagerKeys.createdUsers)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let createUsersObject:Bool = aDecoder.decodeBool(forKey: DataManagerKeys.createdUsers)
        self.createdUsers = createUsersObject
    }
    
    // MARK: utils
    public static func generateUsers() -> Dictionary<String, User> {
        let names:Array = ["Alice", "Bob", "Matt", "Dave"]
        var result:Dictionary<String, User> = Dictionary<String, User>.init()
        for name in names {
            let id:String = UUID.init().uuidString
            let user = User.init()
            user.tradableID = id
            user.name = name
            result[id] = user
        }
        return result
    }
    
}
