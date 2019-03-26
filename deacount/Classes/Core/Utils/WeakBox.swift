//
//  WeakBox.swift
//  deacount
//
//  Created by tamnt5 on 3/25/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

final class WeakBox<A: AnyObject> {
    weak var unbox: A?
    init(_ value: A) {
        unbox = value
    }
}
