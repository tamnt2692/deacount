//
//  UIViewController+HideKeyboardOnTap.swift
//  deacount
//
//  Created by tamnt5 on 3/25/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
