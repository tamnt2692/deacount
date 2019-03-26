//
//  Defines.swift
//  deacount
//
//  Created by tamnt5 on 3/23/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import Foundation
import UIKit

enum DEA: Int {
    case unknown = 0
    case dr = 1
    case cr = 2
    case drpc = 3
    case drv = 4
}

enum DataChange: Int {
    case unknown = 0
    case addgroup = 1
    case addtransactions = 2
    case addrecords = 3
    case updategroup = 4
    case updateusers = 5
}

enum GroupDetail: Int {
    case unknown = 0
    case expenses = 1
    case banlances = 2
}

enum DebtNameOfloginUser: Int {
    case unknown = 0
    case dr = 1
    case cr = 2
}

struct DataManagerKeys {
    static let createdUsers = "createdUsers"
}

struct CoreDataModel {
    static let UserModel = "DBUser"
    static let GroupModel = "DBGroup"
    static let TransactionModel = "DBTransaction"
    static let RecordModel = "DBRecord"
}


