//
//  Dispatcher.swift
//  deacount
//
//  Created by tamnt2692 on 3/24/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

class Dispatcher: NSObject {
    
    let queue = DispatchQueue(label: "Dispatcher.queue")
    
    // MARK: init
    static let shared = Dispatcher()
    private override init() {}
    
    // MARK: actions
    public func dispatchActionCreateGroup(_title:String, _des:String, _members:Array<String>) {
        queue.async {
            DataManager.shared.createGroup(_title: _title, _des: _des, _members:_members)
        }
    }
    
    public func dispatchActionCreateTransaction(_transData: TransactionData) {
        queue.async {
            TransactionManager.shared.equeueTransactionData(_transData: _transData)
        }
    }
}
