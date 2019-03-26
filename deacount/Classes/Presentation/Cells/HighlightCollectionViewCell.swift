//
//  HighlightCollectionViewCell.swift
//  deacount
//
//  Created by tamnt2692 on 3/24/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0xFF00) >> 8) / 255.0, blue: CGFloat(rgb & 0xFF) / 255.0, alpha: alpha)
    }
}

private let highlightedColor = UIColor(rgb: 0xD8D8D8)

class HighlightCollectionViewCell: UICollectionViewCell {
    var shouldTintBackgroundWhenSelected = true
    var specialHighlightedArea: UIView?
    
    override var isHighlighted: Bool {
        willSet {
            onSelected(newValue)
        }
    }
    
    override var isSelected: Bool {
        willSet {
            onSelected(newValue)
        }
    }
    
    func onSelected(_ newValue: Bool) {
        guard selectedBackgroundView == nil else { return }
        if shouldTintBackgroundWhenSelected {
            contentView.backgroundColor = newValue ? highlightedColor : UIColor.clear
        }
        if let sa = specialHighlightedArea {
            sa.backgroundColor = newValue ? UIColor.black.withAlphaComponent(0.4) : UIColor.clear
        }
    }
}
