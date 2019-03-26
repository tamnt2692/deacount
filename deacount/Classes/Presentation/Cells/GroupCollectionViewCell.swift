//
//  GroupCollectionViewCell.swift
//  deacount
//
//  Created by tamnt2692 on 3/23/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

class GroupCollectionViewCell: HighlightCollectionViewCell {
    
    static let arrowImage = UIImage(named: "ic_arrow")
    private(set) var item:Group?

    // MARK: init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }
    
    // MARK: item
    public func setItem(_item: Group) {
        self.item = _item
        self.titleLabel.text = self.item?.title
        self.desLabel.text = self.item?.des
        self.relayout()
    }
    
    // MARK: subviews
    func initViews() {
        self.addSubview(titleLabel)
        self.addSubview(desLabel)
        self.addSubview(arrowImageView)
        self.relayout()
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let desLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = arrowImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: layout
    override func layoutSubviews() {
        self.relayout()
    }
    
    private func relayout() {
        titleLabel.leftAnchor.constraint(equalTo:leftAnchor, constant: 15).isActive = true
        titleLabel.topAnchor.constraint(equalTo:topAnchor, constant: 15).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        
        desLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        desLabel.topAnchor.constraint(equalTo:titleLabel.bottomAnchor, constant: 4).isActive = true
        desLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        desLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        
        arrowImageView.rightAnchor.constraint(equalTo:rightAnchor, constant: -20).isActive = true
        arrowImageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        arrowImageView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
}
