//
//  UserCollectionViewCell.swift
//  deacount
//
//  Created by tamnt2692 on 3/24/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

class UserCollectionViewCell: HighlightCollectionViewCell {
    
    private(set) var item:User?
    
    // MARK: init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addViews()
    }
    
    // MARK: item
    public func setItem(_item:User) {
        self.item = _item
        self.nameLabel.text = self.item?.name
        self.relayout()
    }
    
    
    // MARK: views
    func addViews() {
        addSubview(nameLabel)
        self.relayout()
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: layout
    override func layoutSubviews() {
        self.relayout()
    }
    
    func relayout() {
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 17).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
