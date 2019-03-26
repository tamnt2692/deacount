//
//  Transaction.swift
//  deacount
//
//  Created by tamnt5 on 3/23/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

class Transaction: NSObject {
    var transID:String?
    var source:String?
    var mainRecord:String?
    var records:Array<String>? = Array<String>()
    var des:String?
    var date:Date?
    var transIDpc:String?
}
