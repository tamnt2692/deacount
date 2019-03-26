//
//  ForWhomInfoCollectionViewCell.swift
//  deacount
//
//  Created by tamnt2692 on 3/25/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

class ForWhomInfoCollectionViewCell: UICollectionViewCell {
    private(set) var item:ItemForWhomCell?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    // MARK: item
    public func setItem(_item: ItemForWhomCell) {
        self.item = _item
        self.nameLabel.text = self.item?.name
        self.totalLabel.text = String(format: "%.2f", (self.item?.value)!)
        self.relayout()
    }
    
    override func layoutSubviews() {
        self.relayout()
    }
    
    func relayout() {
        
        //        profileImageButton.removeConstraints(profileImageButton.constraints)
        
        //        profileImageButton.isHidden = false
        //        profileImageButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        //        profileImageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //        profileImageButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        //        profileImageButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 17).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        payLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        payLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        totalLabel.rightAnchor.constraint(equalTo: payLabel.leftAnchor, constant: 0).isActive = true
        totalLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        //        checkButton.leftAnchor.constraint(equalTo:leftAnchor, constant: 20).isActive = true
        //        checkButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        //        checkButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        //        checkButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        //
        //        nameLabel.rightAnchor.constraint(equalTo: pricePerHourLabel.leftAnchor).isActive = true
    }
    
    func addViews() {
        addSubview(nameLabel)
        addSubview(totalLabel)
        addSubview(payLabel)
        self.relayout()
    }
    
    
    @objc func didCLickForButton(_sender: UIButton) {
        let selected = _sender.alpha < 1
        if (selected) {
            _sender.alpha = 1
        } else {
            _sender.alpha = 0.5
        }
    }
    
    // MARK: subviews
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.orange
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didCLickForButton(_sender:)), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let payTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.black
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let payLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.text = "$"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
