//
//  DebtCollectionViewCell.swift
//  deacount
//
//  Created by tamnt2692 on 3/24/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

class DebtCollectionViewCell: UICollectionViewCell {
    
    private(set) var item:ItemDebtCell?
    
    // MARK: init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }
    
    // MARK: item
    public func setItem(_item: ItemDebtCell) {
        self.item = _item
        self.titleLabel.text = self.item?.nameDr
        self.titleLabel1.text = self.item?.nameCr
        self.totalLabel.text = self.item?.value
        self.relayout()
    }
    
    // MARK: subviews
    func initViews() {
        self.addSubview(titleLabel)
        self.addSubview(titleLabel1)
        self.addSubview(desLabel)
        self.addSubview(totalLabel)
        self.relayout()
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor.init(red: 230/255.0, green: 92/255.0, blue: 0/255.0, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLabel1: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor.init(red: 230/255.0, green: 92/255.0, blue: 0/255.0, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.backgroundColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let desLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        label.text = "Owes"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: layout
    override func layoutSubviews() {
        self.relayout()
    }
    
    private func relayout() {
        titleLabel.leftAnchor.constraint(equalTo:leftAnchor, constant: 15).isActive = true
        titleLabel.topAnchor.constraint(equalTo:topAnchor, constant: 15).isActive = true
        
        desLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        desLabel.topAnchor.constraint(equalTo:titleLabel.bottomAnchor, constant: 10).isActive = true
        
        titleLabel1.leftAnchor.constraint(equalTo:leftAnchor, constant: 15).isActive = true
        titleLabel1.rightAnchor.constraint(equalTo:totalLabel.leftAnchor, constant: -15).isActive = true
        titleLabel1.topAnchor.constraint(equalTo:desLabel.bottomAnchor, constant: 10).isActive = true
        
        totalLabel.rightAnchor.constraint(equalTo:rightAnchor, constant: -20).isActive = true
        totalLabel.topAnchor.constraint(equalTo:titleLabel.topAnchor, constant: 0).isActive = true
        totalLabel.centerYAnchor.constraint(equalTo:desLabel.centerYAnchor, constant: 0).isActive = true
    }
}
