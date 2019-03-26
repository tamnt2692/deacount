//
//  RecordData.swift
//  deacount
//
//  Created by tamnt5 on 3/23/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

class RecordData: NSObject {
    
    var source:String?
    var target:String?
    var type:DEA?
    var value:Double?
    var date:Date?
    var des:String?
    
    init(_source: String, _target: String, _type: DEA?, _value: Double, _date: Date, _des: String) {
        self.source = _source
        self.target = _target
        self.type = _type
        self.value = _value
        self.date = _date
        self.des = _des
    }
    
    public static func transferDrRecordDataToCrRecordData(_drRecordData: RecordData) -> RecordData {
        assert(_drRecordData.type == .dr, "need Dr record data")
        let recordData = RecordData.init(_source: _drRecordData.target!, _target: _drRecordData.source!, _type: .cr, _value: _drRecordData.value!, _date: _drRecordData.date!, _des: _drRecordData.des!)
        return recordData
    }
}
