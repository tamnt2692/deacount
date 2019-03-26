//
//  UUIDBuilder.swift
//  deacount
//
//  Created by tamnt2692 on 3/24/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

class UUIDBuilder: NSObject {
    public static func build() -> String {
        let result:String = UUID.init().uuidString
        return result
    }
}
