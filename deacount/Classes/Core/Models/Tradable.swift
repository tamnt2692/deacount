//
//  Tradable.swift
//  deacount
//
//  Created by tamnt5 on 3/23/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

class Tradable: NSObject {
    var tradableID:String?
    var transactions:Array<String>? = Array<String>()
    var records:Array<String>? = Array<String>()
    var targets:Dictionary<String, String>? = Dictionary<String, String>()
    var total:Double = 0
    private var _lock:pthread_rwlock_t = pthread_rwlock_t()
    
    public func doTransaction(_transaction: Transaction, _records: Array<Record>) {
        // begin transaction
        pthread_rwlock_wrlock(&_lock)
        self.transactions?.append(_transaction.transID!)
        for record in _records {
            if (record.type == .dr) {
                self.total -= record.value!
            } else if (record.type == .cr) {
                self.total += record.value!
            }
            let target:String? = record.target
            if (target != nil) {
                self.targets![target!] = target
            }
            self.records?.append(record.recordID!)
        }
        pthread_rwlock_unlock(&_lock)
        // end transaction
    }
    
    public func totalTransaction() -> Array<String> {
        pthread_rwlock_rdlock(&_lock)
        let trans = self.transactions
        pthread_rwlock_unlock(&_lock)
        return trans!
    }
    
    public func totalWallet() -> Double {
        pthread_rwlock_rdlock(&_lock)
        let total:Double = self.total
        pthread_rwlock_unlock(&_lock)
        return total
    }
    
    public func totalRecord() -> Array<String> {
        pthread_rwlock_rdlock(&_lock)
        let records = self.records
        pthread_rwlock_unlock(&_lock)
        return records!
    }
    
    public func totalTarget() -> Dictionary<String, String> {
        pthread_rwlock_rdlock(&_lock)
        let targets = self.targets
        pthread_rwlock_unlock(&_lock)
        return targets!
    }
    
    public func canDoTransaction(_transaction: Transaction) -> Bool {
        return true
    }
}
