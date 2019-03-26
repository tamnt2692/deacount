//
//  deacountTests.swift
//  deacountTests
//
//  Created by tamnt5 on 3/23/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import XCTest
@testable import deacount

class deacountTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: deacount
    func testDoingTransaction() {
        let tradable = Tradable()
        let transaction = deacountTests.transactionDrWithOneRecord()
        let records = [deacountTests.recordDr()]
        tradable.doTransaction(_transaction: transaction, _records: records)
        XCTAssertEqual(tradable.totalWallet(), -10, "calculate wallet wrong !")
        let firstTransactionID = tradable.totalTransaction().first!
        XCTAssertEqual(firstTransactionID, "transaction_1", "link transaction wrong !")
        let firstRecordID = tradable.totalRecord().first!
        XCTAssertEqual(firstRecordID, "record_1", "link record wrong !")
        let firstTargetID = tradable.totalTarget().first!.key
        XCTAssertEqual(firstTargetID, "target_record_1", "save target(contact) wrong !")
    }
    
    func testTransactionManagerEqueueTransactionData() {
        
        // process
        let data = deacountTests.transactionDataForTestCase()
        let result = TransactionManager.processTransactionDataTestFunc(_transData: data)
        
        // validation
        let records = result.records!
        
        // group
        let transGroup = result.group!
        let mainRecordIDGroup = transGroup.mainRecord!
        let mainRecordGroup = records[mainRecordIDGroup]
        XCTAssertEqual(mainRecordGroup?.type, DEA.drv, "type wrong !")
        XCTAssertEqual(mainRecordGroup?.value, 220, "value wrong !")
        
        // owner
        let transOwner = result.owner!
        let mainRecordIDOwner = transOwner.mainRecord!
        let mainRecordOwner = records[mainRecordIDOwner]
        XCTAssertEqual(mainRecordOwner?.type, DEA.drpc, "type wrong !")
        XCTAssertEqual(mainRecordOwner?.value, 220, "value wrong !")
        
        // members
        let members = result.members!
        for transMember in members {
            let mainRecordIDMember = transMember.mainRecord!
            let mainRecordMember = records[mainRecordIDMember]
            XCTAssertEqual(mainRecordMember?.type, DEA.dr, "type wrong !")
            XCTAssertEqual(mainRecordMember?.value, 55, "value wrong !")
            XCTAssertEqual(mainRecordMember?.target, mainRecordOwner?.source!, "target wrong !")
        }
    }
    
    
    
    
    // MARK: utils
    private static func transactionDataForTestCase() -> TransactionData {
        
        let data:TransactionData = TransactionData()
        let groupID = "group_1_singapore_trip"
        let des = "universal_studios_singapore_ticket"
        let date = Date()
        let value:Double = 220
        
        let ownerCrID = "member_1"
        let restaurantID = "restaurant"
        
        data.groupID = groupID
        data.deacount = data.groupID
        data.des = des
        data.date = date
        
        data.groupID = groupID
        data.des = des
        data.date = date
        
        data.groupDrRecordData = RecordData.init(_source: groupID, _target: restaurantID, _type: .dr, _value: value, _date: date, _des: des)
        data.ownerCrRecordData = RecordData.transferDrRecordDataToCrRecordData(_drRecordData: data.groupDrRecordData!)
        data.ownerCrRecordData?.source = ownerCrID
        data.ownerCrRecordData?.target = groupID
        
        data.memberDrRecordDatas?.append(RecordData.init(_source: "member_2", _target: ownerCrID, _type: .dr, _value: 55, _date: date, _des: "member_2_ticket"))
        data.memberDrRecordDatas?.append(RecordData.init(_source: "member_3", _target: ownerCrID, _type: .dr, _value: 55, _date: date, _des: "member_3_ticket"))
        data.memberDrRecordDatas?.append(RecordData.init(_source: "member_4", _target: ownerCrID, _type: .dr, _value: 55, _date: date, _des: "member_4_ticket"))
        
        return data
    }
    
    private static func recordsForTestCase() -> Dictionary<String, Record> {
        let records = Dictionary<String, Record>()
        for i in 0...10 {
            let record = Record()
            record.recordID = String(i)
            record.type = .dr
            record.value = 10
            record.source = String(format: "source_%@", record.recordID!)
            record.target = String(format: "target_%@", record.recordID!)
        }
        return records
    }
    
    private static func recordForTestCase(_rawID: String, _type: DEA, _value: Double) -> Record {
        let record = Record()
        record.recordID = String(format: "record_%@", _rawID)
        record.type = _type
        record.value = _value
        record.source = String(format: "source_%@", record.recordID!)
        record.target = String(format: "target_%@", record.recordID!)
        return record
    }
    
    private static func transactionDrWithOneRecord() -> Transaction {
        let record = deacountTests.recordDr()
        let transaction = Transaction()
        let i = 1
        transaction.transID = String(format: "transaction_%@", String(i))
        transaction.source = record.source
        transaction.mainRecord = record.recordID
        transaction.records?.append(record.recordID!)
        return transaction
    }
    
    private static func recordDr() -> Record {
        let record = deacountTests.recordForTestCase(_rawID: "1", _type: .dr, _value: 10)
        return record
    }

}
