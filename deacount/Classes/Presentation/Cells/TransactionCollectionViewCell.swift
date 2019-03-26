//
//  TransactionCollectionViewCell.swift
//  deacount
//
//  Created by tamnt2692 on 3/24/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

class TransactionCollectionViewCell: UICollectionViewCell {
    
    private(set) var item:ItemTransactionCell?
    
    // MARK: init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }
    
    // MARK: item
    public func setItem(_item: ItemTransactionCell) {
        self.item = _item
        self.desLabel.text = self.item?.des
        self.whopayLabel.text = self.item?.whopay
        self.valueLabel.text = self.item?.value
        self.dateLabel.text = self.item?.date
        self.balanceLabel.text = self.item?.balance
        self.balanceLabel.textColor = self.item?.balanceColor
        self.relayout()
    }
    
    // MARK: layout
    override func layoutSubviews() {
        self.relayout()
    }
    
    private func relayout() {
        desLabel.leftAnchor.constraint(equalTo:leftAnchor, constant: 15).isActive = true
        desLabel.rightAnchor.constraint(equalTo:valueLabel.leftAnchor, constant: -15).isActive = true
        desLabel.topAnchor.constraint(equalTo:topAnchor, constant: 15).isActive = true
        
        paidByLabel.leftAnchor.constraint(equalTo: desLabel.leftAnchor).isActive = true
        paidByLabel.topAnchor.constraint(equalTo: desLabel.bottomAnchor, constant: 4).isActive = true
        
        whopayLabel.leftAnchor.constraint(equalTo: paidByLabel.rightAnchor).isActive = true
        whopayLabel.topAnchor.constraint(equalTo:paidByLabel.topAnchor, constant: 0).isActive = true
        
        valueLabel.rightAnchor.constraint(equalTo:rightAnchor, constant: -20).isActive = true
        valueLabel.topAnchor.constraint(equalTo:desLabel.topAnchor, constant: 0).isActive = true
        
        dateLabel.rightAnchor.constraint(equalTo:valueLabel.rightAnchor, constant: 0).isActive = true
        dateLabel.topAnchor.constraint(equalTo:paidByLabel.topAnchor, constant: 0).isActive = true
        
        balanceLabel.rightAnchor.constraint(equalTo:valueLabel.rightAnchor, constant: 0).isActive = true
        balanceLabel.topAnchor.constraint(equalTo:dateLabel.bottomAnchor, constant: 0).isActive = true
    }
    
    // MARK: views
    func initViews() {
        self.addSubview(desLabel)
        self.addSubview(paidByLabel)
        self.addSubview(whopayLabel)
        self.addSubview(valueLabel)
        self.addSubview(dateLabel)
        self.addSubview(balanceLabel)
        self.relayout()
    }
    
    let desLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.init(red: 230/255.0, green: 92/255.0, blue: 0/255.0, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.init(red: 230/255.0, green: 92/255.0, blue: 0/255.0, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let paidByLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.darkGray
        label.text = "Paid by "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let whopayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
}
