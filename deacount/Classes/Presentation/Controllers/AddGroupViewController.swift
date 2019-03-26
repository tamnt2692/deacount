//
//  AddGroupViewController.swift
//  deacount
//
//  Created by tamnt2692 on 3/23/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

class AddGroupViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    
    private(set) var collectionView: UICollectionView?
    private(set) var dataSource: Array<User> = Array<User>()
    private(set) var selected: Array<IndexPath> = Array<IndexPath>()
    
    // MARK: life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap()
        self.setupNavigation()
        self.setupDataSource()
        self.setupViews()
        
    }
    
    // MARK: private
    private func setupNavigation() {
        let rightBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(didClickRightBarItem(_sender:)));
        self.navigationItem.setRightBarButtonItems([rightBarItem], animated: true)
        
        let leftBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(didClickLeftBarItem(_sender:)));
        self.navigationItem.setLeftBarButtonItems([leftBarItem], animated: true)
    }
    
    private func setupViews() {
        
        self.setupCollectionView()
        titleTextField.delegate = self
        desTextField.delegate = self
        self.view.addSubview(titleTextField)
        self.view.addSubview(lineView)
        self.view.addSubview(avatarImageView)
        self.view.addSubview(desTextField)
        self.view.addSubview(self.collectionView!)
        
        avatarImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topbarHeight+20).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        titleTextField.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 10).isActive = true
        titleTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topbarHeight+20).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        lineView.leftAnchor.constraint(equalTo: titleTextField.leftAnchor, constant: -2).isActive = true
        lineView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: -10).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        desTextField.leftAnchor.constraint(equalTo: avatarImageView.leftAnchor, constant: 0).isActive = true
        desTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20).isActive = true
        desTextField.heightAnchor.constraint(equalToConstant: 150).isActive = true
        desTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-40).isActive = true
        
        self.collectionView?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.collectionView?.topAnchor.constraint(equalTo: desTextField.bottomAnchor, constant: 20).isActive = true
        self.collectionView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.collectionView?.widthAnchor.constraint(equalToConstant: self.view.frame.size.width).isActive = true
    }
    
    private func setupCollectionView() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: 50)
        
        var collectionViewFrame:CGRect = self.view.frame;
        let collectionView:UICollectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
        collectionView.alwaysBounceVertical = true
        collectionView.allowsMultipleSelection = true
        collectionView.allowsSelection = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView = collectionView
    }
    
    private func setupDataSource() {
        let users = DataManager.shared.allUser()
        self.dataSource = users
    }
    
    private func getMembers() -> Array<String> {
        var resutl:Array<String> = []
        for indexPath in self.selected {
            let user = self.dataSource[indexPath.item]
            resutl.append(user.tradableID!)
        }
        return resutl
    }
    
    // MARK: actions
    @objc func didClickRightBarItem(_sender:AnyObject) {
        let title = self.titleTextField.text
        let des = self.desTextField.text
        let members = self.getMembers()
        Dispatcher.shared.dispatchActionCreateGroup(_title: title!, _des: des!, _members: members)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didClickLeftBarItem(_sender:AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: @UICollectionViewDelegate, @UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath as IndexPath) as! UserCollectionViewCell
        cell.backgroundColor = UIColor.white
        cell.setItem(_item: self.dataSource[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selected.append(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.selected.removeAll { (index) -> Bool in
            index == indexPath
        }
    }
    
    // MARK: views
    let titleTextField: UITextField = {
        let placeholder = NSAttributedString(string: "Enter title here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let textField = UITextField()
        textField.attributedPlaceholder = placeholder
        textField.textColor = UIColor.black
        textField.borderStyle = UITextField.BorderStyle.none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let desTextField: UITextField = {
        let placeholder = NSAttributedString(string: "Enter description here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let textField = UITextField()
        textField.attributedPlaceholder = placeholder
        textField.textColor = UIColor.black
        textField.textAlignment = .left
        textField.contentVerticalAlignment = .top
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.red
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
//    func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        if (titleTextField.isEditing) {
//            titleTextField.endEditing(true)
//        }
//        if (desTextField.isEditing) {
//            desTextField.endEditing(true)
//        }
////        desTextField.resignFirstResponder()
//    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() //Hide the keyboard
        return true
    }
    
}
