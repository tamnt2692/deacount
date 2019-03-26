//
//  TransactionResult.swift
//  deacount
//
//  Created by tamnt2692 on 3/25/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

class TransactionResult: NSObject {
    var data:TransactionData?
    var records:Dictionary<String, Record>?
    var transactions:Dictionary<String, Transaction>?
    var group:Transaction?
    var owner:Transaction?
    var members:Array<Transaction>?
}
