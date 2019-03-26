//
//  PersistentManager.swift
//  deacount
//
//  Created by tamnt2692 on 3/24/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit
import CoreData

class PersistentManager: NSObject {
    
    private(set) weak var appDelegate:AppDelegate?
    static let shared = PersistentManager()
    private override init() {}
    
    // MARK: public
    public func initWhenStartApp(_appDelegate: AppDelegate) {
        self.appDelegate = _appDelegate
    }
    
    // MARK: create
    public func createUsers() -> Dictionary<String, User> {
        
        let context = self.appDelegate?.persistentContainer.viewContext
        let users = DataManager.generateUsers()
        for (_, user) in users {
            let entity = NSEntityDescription.entity(forEntityName: CoreDataModel.UserModel, in: context!)
            let object = NSManagedObject(entity: entity!, insertInto: context)
            
            object.setValue(user.tradableID, forKey: "userid")
            object.setValue(user.name, forKey: "name")
            object.setValue(user.totalWallet(), forKey: "total")
            object.setValue(user.totalTransaction(), forKey: "transactions")
            object.setValue(user.totalRecord(), forKey: "records")
            object.setValue(user.totalTarget(), forKey: "targets")
        }
        
        do {
            try context!.save()
        } catch {
            print("Failed saving")
        }
        
        return users
    }
    
    // MARK: add
    public func addGroupToDB(_group: Group) -> Bool {
        
        let context = self.appDelegate!.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreDataModel.GroupModel, in: context)
        let object = NSManagedObject(entity: entity!, insertInto: context)
        
        object.setValue(_group.tradableID, forKey: "groupid")
        object.setValue(_group.title, forKey: "title")
        object.setValue(_group.des, forKey: "des")
        object.setValue(_group.members, forKey: "members")
        object.setValue(_group.totalRecord(), forKey: "records")
        object.setValue(_group.totalTarget(), forKey: "targets")
        object.setValue(_group.totalTransaction(), forKey: "transactions")
        object.setValue(_group.totalWallet(), forKey: "total")
        
        do {
            try context.save()
            return true
        } catch {
            print("Failed saving")
        }
        
        return false
    }
    
    public func addTransactionsToDB(_transactions: Dictionary<String, Transaction>) -> Bool {
        
        let context = self.appDelegate!.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreDataModel.TransactionModel, in: context)
        
        for (_, trans) in _transactions {
            let object = NSManagedObject(entity: entity!, insertInto: context)
            object.setValue(trans.transID, forKey: "transid")
            object.setValue(trans.source, forKey: "source")
            object.setValue(trans.mainRecord, forKey: "mainrecord")
            object.setValue(trans.records, forKey: "records")
            object.setValue(trans.des, forKey: "des")
            object.setValue(trans.date, forKey: "date")
            object.setValue(trans.transIDpc, forKey: "transidpc")
        }
        
        do {
            try context.save()
            return true
        } catch {
            print("Failed saving")
        }
        
        return false
    }
    
    public func addRecordsToDB(_records: Dictionary<String, Record>) -> Bool {
        
        let context = self.appDelegate!.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreDataModel.RecordModel, in: context)
        
        for (_, record) in _records {
            let object = NSManagedObject(entity: entity!, insertInto: context)
            object.setValue(record.recordID, forKey: "recordid")
            object.setValue(record.transID, forKey: "transid")
            object.setValue(Int32(record.type!.rawValue), forKey: "type")
            object.setValue(record.value, forKey: "value")
            object.setValue(record.source, forKey: "source")
            object.setValue(record.sourcepc, forKey: "sourcepc")
            object.setValue(record.deacount, forKey: "deacount")
            object.setValue(record.date, forKey: "date")
            object.setValue(record.target, forKey: "target")
        }
        
        do {
            try context.save()
            return true
        } catch {
            print("Failed saving")
        }
        
        return false
    }
    
    // MARK: update
    public func updateGroupsToDB(_groups: Array<Group>) -> Bool {
        
        let context = self.appDelegate!.persistentContainer.viewContext
        for group in _groups {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataModel.GroupModel)
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "(groupid = %@)", group.tradableID!)
            do {
                let results =
                    try context.fetch(request)
                let objectUpdate = results.first as! NSManagedObject
                objectUpdate.setValue(group.totalRecord(), forKey: "records")
                objectUpdate.setValue(group.totalTarget(), forKey: "targets")
                objectUpdate.setValue(group.totalTransaction(), forKey: "transactions")
                objectUpdate.setValue(group.totalWallet(), forKey: "total")
                do {
                    try context.save()
                    return true
                } catch _ as NSError {
                    
                }
            } catch _ as NSError {
                
            }
        }
        
        return false
    }
    
    public func updateUsersToDB(_users: Array<User>) -> Bool {
        
        let context = self.appDelegate!.persistentContainer.viewContext
        for user in _users {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataModel.UserModel)
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "(userid = %@)", user.tradableID!)
            do {
                let results =
                    try context.fetch(request)
                let objectUpdate = results.first as! NSManagedObject
                objectUpdate.setValue(user.totalWallet(), forKey: "total")
                objectUpdate.setValue(user.totalTransaction(), forKey: "transactions")
                objectUpdate.setValue(user.totalRecord(), forKey: "records")
                objectUpdate.setValue(user.totalTarget(), forKey: "targets")
                do {
                    try context.save()
                    return true
                } catch _ as NSError {
                    
                }
            } catch _ as NSError {
                
            }
        }
        
        return false
    }
    
    // MARK: flow
    public func loadUsers() -> Dictionary<String, User> {
        
        let context = self.appDelegate!.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataModel.UserModel)
        request.returnsObjectsAsFaults = false
        
        var users:Dictionary<String, User> = Dictionary<String, User>.init()
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let userID = data.value(forKey: "userid") as! String
                let name = data.value(forKey: "name") as! String
                let total = data.value(forKey: "total") as! Double
                let transactions = data.value(forKey: "transactions") as! Array<String>
                let records = data.value(forKey: "records") as! Array<String>
                let targets = data.value(forKey: "targets") as! Dictionary<String, String>
                
                let user = User()
                user.tradableID = userID
                user.name = name
                user.total = total
                user.transactions = transactions
                user.records = records
                user.targets = targets
                
                users[userID] = user
            }
            
        } catch {
            print("Failed")
        }
        
        return users
        
    }
    
    public func loadGroups() -> Dictionary<String, Group> {
        let context = self.appDelegate!.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataModel.GroupModel)
        request.returnsObjectsAsFaults = false
        var result = Dictionary<String, Group>.init()
        
        do {
            let fetchResult = try context.fetch(request)
            for data in fetchResult as! [NSManagedObject] {
                let group = PersistentManager.parseObjectToGroup(_data: data)
                result[group.tradableID!] = group
            }
        } catch {
            print("Failed")
        }
        
        return result
    }
    
    public func loadTransactions() -> Dictionary<String, Transaction> {
        
        let context = self.appDelegate!.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataModel.TransactionModel)
        request.returnsObjectsAsFaults = false
        var result = Dictionary<String, Transaction>.init()
        
        do {
            let fetchResult = try context.fetch(request)
            for data in fetchResult as! [NSManagedObject] {
                let trans = PersistentManager.parseObjectToTransaction(_data: data)
                result[trans.transID!] = trans
            }
        } catch {
            print("Failed")
        }
        
        return result
    }
    
    public func loadRecords() -> Dictionary<String, Record> {
        
        let context = self.appDelegate!.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataModel.RecordModel)
        request.returnsObjectsAsFaults = false
        var result = Dictionary<String, Record>.init()
        
        do {
            let fetchResult = try context.fetch(request)
            for data in fetchResult as! [NSManagedObject] {
                let record = PersistentManager.parseObjectToRecord(_data: data)
                result[record.recordID!] = record
            }
        } catch {
            print("Failed")
        }
        
        return result
    }
    
    // MARK: parse
    private static func parseObjectToGroup(_data: NSManagedObject) -> Group {
        
        let groupID = _data.value(forKey: "groupid") as! String
        let title = _data.value(forKey: "title") as! String
        let des = _data.value(forKey: "des") as! String
        let members = _data.value(forKey: "members") as! Array<String>
        let total = _data.value(forKey: "total") as! Double
        let transactions = _data.value(forKey: "transactions") as! Array<String>
        let records = _data.value(forKey: "records") as! Array<String>
        let targets = _data.value(forKey: "targets") as! Dictionary<String, String>
        
        let group = Group()
        group.tradableID = groupID
        group.title = title
        group.des = des
        group.members = members
        group.total = total
        group.transactions = transactions
        group.records = records
        group.targets = targets
        
        return group
    }
    
    private static func parseObjectToTransaction(_data: NSManagedObject) -> Transaction {
        
        let transID = _data.value(forKey: "transid") as! String
        let source = _data.value(forKey: "source") as! String
        let mainRecord = _data.value(forKey: "mainrecord") as! String
        let records = _data.value(forKey: "records") as! Array<String>
        let des = _data.value(forKey: "des") as! String
        let date = _data.value(forKey: "date") as! Date
        let transidpc = _data.value(forKey: "transidpc") as? String
        
        let transaction = Transaction()
        transaction.transID = transID
        transaction.source = source
        transaction.mainRecord = mainRecord
        transaction.records = records
        transaction.des = des
        transaction.date = date
        transaction.transIDpc = transidpc
        
        return transaction
    }
    
    private static func parseObjectToRecord(_data: NSManagedObject) -> Record {
        
        let recordid = _data.value(forKey: "recordid") as! String
        let transid = _data.value(forKey: "transid") as! String
        let type = _data.value(forKey: "type") as! Int32
        let value = _data.value(forKey: "value") as! Double
        let source = _data.value(forKey: "source") as! String
        let sourcepc = _data.value(forKey: "sourcepc") as? String
        let deacount = _data.value(forKey: "deacount") as! String
        let date = _data.value(forKey: "date") as! Date
        let target = _data.value(forKey: "target") as! String
        
        let record = Record()
        record.recordID = recordid
        record.transID = transid
        record.type = DEA(rawValue: Int(type))
        record.value = value
        record.source = source
        record.sourcepc = sourcepc
        record.deacount = deacount
        record.date = date
        record.target = target
        
        return record
    }
}
