//
//  TransactionData.swift
//  deacount
//
//  Created by tamnt5 on 3/23/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

class TransactionData: NSObject {
    var groupID:String?
    var deacount:String?
    var des:String?
    var date:Date?
    var groupDrRecordData:RecordData?
    var ownerCrRecordData:RecordData?
    var memberDrRecordDatas:Array<RecordData>? = Array<RecordData>()
}
