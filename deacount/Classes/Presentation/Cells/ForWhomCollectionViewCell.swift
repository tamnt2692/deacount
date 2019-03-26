//
//  ForWhomCollectionViewCell.swift
//  deacount
//
//  Created by tamnt2692 on 3/25/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

class ForWhomCollectionViewCell: HighlightCollectionViewCell, UITextFieldDelegate {
    
    private(set) var item:ItemForWhomCell?
    var indexPath:IndexPath?
    weak var tfDelegate:UITextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    // MARK: item
    public func setItem(_item: ItemForWhomCell) {
        self.item = _item
        self.nameLabel.text = self.item?.name
        self.relayout()
    }
    
    override func layoutSubviews() {
        self.relayout()
    }
    
    func relayout() {
        
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 17).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        payLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        payLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        totalTextField.rightAnchor.constraint(equalTo: payLabel.leftAnchor, constant: 0).isActive = true
        totalTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    @objc func textFieldEditingDidChange(_sender: UITextField) {
        if let value = Double(_sender.text!) {
            self.item?.value = value
        }
    }
    
    func addViews() {
        totalTextField.addTarget(self, action: #selector(textFieldEditingDidChange(_sender:)), for: UIControl.Event.editingChanged)
        addSubview(nameLabel)
        addSubview(totalTextField)
        addSubview(payLabel)
        self.relayout()
    }
    
    // MARK: subviews
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
    
    let totalTextField: UITextField = {
        let placeholder = NSAttributedString(string: "total", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let textField = UITextField()
        textField.attributedPlaceholder = placeholder
        textField.textColor = UIColor.black
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
}
