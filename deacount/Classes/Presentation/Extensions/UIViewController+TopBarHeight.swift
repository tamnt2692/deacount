//
//  UIViewController+TopBarHeight.swift
//  deacount
//
//  Created by tamnt5 on 3/25/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    var topbarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
