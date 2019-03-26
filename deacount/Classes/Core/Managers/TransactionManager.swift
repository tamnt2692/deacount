//
//  TransactionManager.swift
//  deacount
//
//  Created by tamnt5 on 3/23/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

class TransactionManager : NSObject {
    static let shared:TransactionManager = TransactionManager()
    private override init() {}
    private let queue = DispatchQueue(label: "TransactionManager.queue")
    
    // MARK: public
    public func equeueTransactionData(_transData: TransactionData) {
        queue.async {
            let result = TransactionManager.processTransactionData(_transData: _transData)
            TransactionManager.performTransactionResult(_result: result)
        }
    }

    // MARK: private
    private static func processTransactionData(_transData: TransactionData) -> TransactionResult {
        
        let result = TransactionResult()
        result.data = _transData
        
        // BEGIN CREATE RECORDS
        var records:Dictionary<String, Record> = Dictionary<String, Record>()
        
        var memberDrRecords:Array<Record> = Array<Record>()
        var memberCrRecordsTransfered:Array<Record> = Array<Record>()
        for recordData in _transData.memberDrRecordDatas! {
            
            let record = TransactionManager.createRecord(_recordData: recordData, _deacount: _transData.deacount!)
            let recordTransfered = TransactionManager.transferDrRecordToCrRecord(_drRecord: record)
            memberDrRecords.append(record)
            memberCrRecordsTransfered.append(recordTransfered)
            
            records[record.recordID!] = record
            records[recordTransfered.recordID!] = recordTransfered
        }
        
        
        let ownerCrRecord = TransactionManager.createRecord(_recordData: _transData.ownerCrRecordData!, _deacount: _transData.deacount!)
        ownerCrRecord.type = .drpc
        records[ownerCrRecord.recordID!] = ownerCrRecord
        
        
        let groupDrRecord = TransactionManager.createRecord(_recordData: _transData.groupDrRecordData!, _deacount: _transData.deacount!)
        groupDrRecord.type = .drv
        groupDrRecord.sourcepc = ownerCrRecord.source
        records[groupDrRecord.recordID!] = groupDrRecord
        // END CREATE RECORDS
        
        // BEGIN CREATE TRANSACTIONS
        var transactions:Dictionary<String, Transaction> = Dictionary<String, Transaction>()
        
        var memberDrTransactions:Array<Transaction> = Array<Transaction>()
        for record in memberDrRecords {
            
            let transaction = Transaction()
            transaction.transID = UUIDBuilder.build()
            transaction.source = record.source
            record.transID = transaction.transID
            transaction.mainRecord = record.recordID
            transaction.records?.append(record.recordID!)
            transaction.des = record.des
            transaction.date = record.date
            
            memberDrTransactions.append(transaction)
            transactions[transaction.transID!] = transaction
        }
        
        let ownerCrTransaction = Transaction()
        ownerCrTransaction.transID = UUIDBuilder.build()
        ownerCrTransaction.source = ownerCrRecord.source
        ownerCrTransaction.des = ownerCrRecord.des
        ownerCrTransaction.date = ownerCrRecord.date
        ownerCrTransaction.mainRecord = ownerCrRecord.recordID
        ownerCrRecord.transID = ownerCrTransaction.transID
        
        for record in memberCrRecordsTransfered {
            record.transID = ownerCrTransaction.transID
            ownerCrTransaction.records?.append(record.recordID!)
        }
        transactions[ownerCrTransaction.transID!] = ownerCrTransaction
        
        let groupDrTransaction = Transaction()
        groupDrTransaction.transID = UUIDBuilder.build()
        groupDrTransaction.source = groupDrRecord.source
        groupDrRecord.transID = groupDrTransaction.transID
        groupDrTransaction.mainRecord = groupDrRecord.recordID
        groupDrTransaction.records?.append(groupDrRecord.recordID!)
        groupDrTransaction.des = groupDrRecord.des
        groupDrTransaction.date = groupDrRecord.date
        if (groupDrRecord.type == .drv && ownerCrRecord.type == .drpc) {
            groupDrTransaction.transIDpc = ownerCrTransaction.transID
        }
        transactions[groupDrTransaction.transID!] = groupDrTransaction
        // END CREATE TRANSACTIONS
        
        result.records = records
        result.transactions = transactions
        result.group = groupDrTransaction
        result.owner = ownerCrTransaction
        result.members = memberDrTransactions
        return result
    }
    
    
    private static func performTransactionResult(_result: TransactionResult) {
        let records:Dictionary<String, Record> = _result.records!
        let transactions:Dictionary<String, Transaction> = _result.transactions!
        let groupDrTransaction:Transaction = _result.group!
        let ownerCrTransaction:Transaction = _result.owner!
        let memberDrTransactions:Array<Transaction> = _result.members!
        
        // BEGIN PERFORM TRANSACTIONS
        let group = TransactionManager.performTransaction(_trans: groupDrTransaction, _recordsCached: records) as! Group
        let owner = TransactionManager.performTransaction(_trans: ownerCrTransaction, _recordsCached: records) as! User
        var users = Array<User>()
        users.append(owner)
        for trans in memberDrTransactions {
            let u = TransactionManager.performTransaction(_trans: trans, _recordsCached: records) as! User
            users.append(u)
        }
        // END PERFORM TRANSACTIONS
        
        // BEGIN PERSISTENT DATA
        DataManager.shared.update(_group: group, _users: users)
        DataManager.shared.add(_transactions: transactions, _records: records)
        // END PERSISTENT DATA
    }
    
    private static func performTransaction(_trans: Transaction, _recordsCached: Dictionary<String, Record>) -> Tradable {
        var records = Array<Record>()
        let mainRecord = _recordsCached[_trans.mainRecord!]!
        records.append(mainRecord)
        for recordID in _trans.records! {
            let record = _recordsCached[recordID]
            records.append(record!)
        }
        let tradable = DataManager.shared.getTradable(_tradableID: _trans.source!)
        tradable.doTransaction(_transaction: _trans, _records: records)
        return tradable
    }
    
    // MARK: utils
    private static func createRecord(_recordData: RecordData, _deacount: String) -> Record {
        let record = Record()
        record.recordID = UUIDBuilder.build()
        record.type = _recordData.type
        record.value = _recordData.value
        record.source = _recordData.source
        record.deacount = _deacount
        record.target = _recordData.target
        record.date = _recordData.date
        record.des = _recordData.des
        return record
    }
    
    private static func transferDrRecordToCrRecord(_drRecord: Record) -> Record {
        assert(_drRecord.type == .dr, "need Dr record")
        let record = Record()
        record.recordID = UUIDBuilder.build()
        if (_drRecord.type == .dr) {
            record.type = DEA.cr
            record.value = _drRecord.value
            record.source = _drRecord.target
            record.target = _drRecord.source
            record.sourcepc = _drRecord.sourcepc
            record.deacount = _drRecord.deacount
            record.date = _drRecord.date
            record.des = _drRecord.des
        }
        
        return record
    }
    
    // MARK: test
    public static func processTransactionDataTestFunc(_transData: TransactionData) -> TransactionResult {
        return self.processTransactionData(_transData: _transData)
    }
    
}
