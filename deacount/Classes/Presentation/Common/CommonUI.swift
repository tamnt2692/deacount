//
//  CommonUI.swift
//  deacount
//
//  Created by tamnt2692 on 3/24/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

class CommonUI: NSObject {
    static var loginUser:User?
    static var dateFormatter:DateFormatter?
    
    public static func setupCommonUIWhenStartApp() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        dateFormatter = formatter
    }
    
    // MARK: UI builder
    public static func buildGroupDetailTitleNavigationBar(_title:String, _members: Array<String>) -> String {
        var result = String(format: "%@\n", _title)
        let count = _members.count
        for (i, name) in _members.enumerated() {
            if (i == count-1) {
                result.append(name)
            } else {
                result.append(CommonUI.appendCommaToSuffixOfString(_string: name))
            }
        }
        return result
    }
    
    public static func buildItemTransactionCell(_trans: Transaction) -> ItemTransactionCell {
        let item = ItemTransactionCell()
        item.des = _trans.des
        item.date = dateFormatter?.string(from: _trans.date!)
        
        // whopay, value
        let record = DataManager.shared.getRecord(_recordID: _trans.mainRecord!)
        var source = record.source
        if (record.type == .drv) {
            source = record.sourcepc
            let tran = DataManager.shared.getTransaction(_transactionID: _trans.transIDpc!)
            var value:Double = 0.0
            var spent:Double = 0.0
            if (tran.source == CommonUI.loginUser?.tradableID!) {
                let recordRelated = DataManager.shared.getRecords(_recordIDs: tran.records!)
                for r in recordRelated {
                    value += r.value!
                }
                spent = record.value!-value
                
            } else {
                let recordRelated = DataManager.shared.getRecords(_recordIDs: tran.records!).filter { (r) -> Bool in
                    r.target == CommonUI.loginUser?.tradableID!
                }
                for r in recordRelated {
                    value -= r.value!
                }
                spent = Swift.abs(value)
            }
            
            item.vspent = spent
            item.vbalance = value
            item.balance = CommonUI.buildBalanceString(_value: value)
            item.balanceColor = CommonUI.buildBalanceColor(_value: value)
        }
        let user = DataManager.shared.getUser(_userID: source!)
        item.whopay = CommonUI.buildPresentationForLoginUser(_string: user.name!, _userID: user.tradableID!)
        item.value = CommonUI.buildValueString(_value: record.value!)
        return item
    }
    
    public static func buildItemDebtCell(_debt: DebtData) -> ItemDebtCell {
        let item = ItemDebtCell()
        let value = _debt.value!
        item.value = CommonUI.buildValueString(_value: Swift.abs(value))
        if (value > 0.0) {
            item.nameCr = CommonUI.buildPresentationForLoginUser(_string: _debt.left!, _userID: _debt.leftID!)
            item.nameDr = CommonUI.buildPresentationForLoginUser(_string: _debt.right!, _userID: _debt.rightID!)
        } else {
            item.nameCr = CommonUI.buildPresentationForLoginUser(_string: _debt.right!, _userID: _debt.rightID!)
            item.nameDr = CommonUI.buildPresentationForLoginUser(_string: _debt.left!, _userID: _debt.leftID!)
        }
        return item
    }
    
    public static func buildItemForWhomCell(_user: User) -> ItemForWhomCell {
        let item = ItemForWhomCell()
        item.checked = false
        item.name = _user.name
        item.memberID = _user.tradableID
        item.value = 0
        return item
    }
    
    static func buildPresentationForLoginUser(_string:String, _userID:String) -> String {
        var result = _string
        if (_userID == CommonUI.loginUser?.tradableID) {
            result = String(format: "%@ (me)", _string)
        }
        return result
    }
    
    public static func buildValueString(_value:Double) -> String {
        return String(format: "$%.2f", _value)
    }
    
    public static func buildBalanceString(_value:Double) -> String {
        if (_value > 0) {
            return String(format: "+$%.2f", Swift.abs(_value))
        }
        return String(format: "-$%.2f", Swift.abs(_value))
    }
    
    public static func buildBalanceColor(_value:Double) -> UIColor {
        if (_value > 0) {
            return UIColor.green
        }
        return UIColor.red
    }
    
    public static func appendCommaToSuffixOfString(_string:String) -> String {
        let result = String(format: "%@, ", _string)
        return result
    }
}
