//
//  Record.swift
//  deacount
//
//  Created by tamnt5 on 3/23/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

class Record: NSObject {
    var recordID:String?
    var transID:String?
    var type:DEA? = DEA.unknown
    var value:Double?
    var source:String?
    var sourcepc:String?
    var deacount:String?
    var target:String?
    var date:Date?
    var des:String?
}
