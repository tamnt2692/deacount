//
//  AddTransactionViewController.swift
//  deacount
//
//  Created by tamnt2692 on 3/25/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

class AddTransactionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, ForWhomViewControllerDelegate, WhoPayViewControllerDelegate {
    
    var deacount:String?
    var members:Array<User>?
    private(set) var dataSource: Array<ItemForWhomCell>?
    private(set) var whopay:User?
    
    private(set) var collectionView: UICollectionView?
    
    // MARK: life-cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setWhoPayForTransaction(_user: (self.members?.first)!)
        self.setupNavigation()
        self.setupDataSource()
        self.setupViews()
    }
    
    // MARK: private
    private func setWhoPayForTransaction(_user: User) {
        self.whopay = _user
        self.payTextView.text = self.whopay?.name!
    }
    
    private func createTransactionData() -> TransactionData {
        let data:TransactionData = TransactionData()
        let groupID = self.deacount
        let des:String = self.titleTextField.text!
        let date = Date()
        let value:Double = Double(self.totalTextField.text!)!
        
        let ownerCrID = self.whopay?.tradableID
        let restaurantID = "restaurant"
        
        data.groupID = groupID
        data.deacount = data.groupID
        data.des = des
        data.date = date
        
        data.groupDrRecordData = RecordData.init(_source: groupID!, _target: restaurantID, _type: .dr, _value: value, _date: date, _des: des)
        data.ownerCrRecordData = RecordData.transferDrRecordDataToCrRecordData(_drRecordData: data.groupDrRecordData!)
        data.ownerCrRecordData?.source = ownerCrID
        data.ownerCrRecordData?.target = groupID
        
        for item in self.dataSource! {
            if (item.memberID! != ownerCrID) {
                let recordData = RecordData.init(_source: item.memberID!, _target: ownerCrID!, _type: .dr, _value: item.value!, _date: date, _des: des)
                data.memberDrRecordDatas?.append(recordData)
            }
        }
        
        return data
    }
    
    private func setupNavigation() {
        let leftBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(didClickCancelButton(_sender:)));
        self.navigationItem.setLeftBarButtonItems([leftBarItem], animated: true)
        
        let rightBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(didClickSaveButton(_sender:)));
        self.navigationItem.setRightBarButtonItems([rightBarItem], animated: true)
        
        self.title = "New expense"
    }
    
    @objc func onDidChangeDate(_sender: UIDatePicker) {
        
    }
    
    private func setupDataSource() {
        let items = self.members?.map({ (user) -> ItemForWhomCell in
            CommonUI.buildItemForWhomCell(_user: user)
        })
        self.dataSource = items
    }
    
    private func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 1
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: 60)
        let collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ForWhomInfoCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView = collectionView
    }
    
    // MARK: @UICollectionViewDelegate, @UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.dataSource?.count) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath as IndexPath) as! ForWhomInfoCollectionViewCell
        cell.backgroundColor = UIColor.white
        cell.setItem(_item: self.dataSource![indexPath.item])
        return cell
    }
    
    private func setupViews() {
        
        self.setupHideKeyboardOnTap()
        self.setupCollectionView()
        totalTextField.isEnabled = false
        self.view.addSubview(collectionView!)
        self.view.addSubview(titleTextField)
        self.view.addSubview(totalTextField)
        self.view.addSubview(dateTextView)
        self.view.addSubview(datePicker)
        self.view.addSubview(dateLabel)
        self.view.addSubview(payTextView)
        self.view.addSubview(payLabel)
        self.view.addSubview(forLabel)
        self.view.addSubview(forButton)
        self.view.addSubview(simpleButton)
        self.view.addSubview(toolBar)
        self.view.addSubview(lineView1)
        self.view.addSubview(lineView2)
        self.view.addSubview(lineView3)
        self.view.addSubview(lineView4)
        
        datePicker.isHidden = true
        toolBar.isHidden = true
        
        datePicker.date = Date()
        dateTextView.text = CommonUI.dateFormatter?.string(from: datePicker.date)
        payTextView.text = self.members?.first!.name
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        
        titleTextField.topAnchor.constraint(equalTo:self.view.topAnchor, constant: topbarHeight+30).isActive = true
        titleTextField.leftAnchor.constraint(equalTo:self.view.leftAnchor, constant: 20).isActive = true
        titleTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-40).isActive = true
        
        lineView1.topAnchor.constraint(equalTo:titleTextField.bottomAnchor, constant: 10).isActive = true
        lineView1.leftAnchor.constraint(equalTo:titleTextField.leftAnchor).isActive = true
        lineView1.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-40).isActive = true
        lineView1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        totalTextField.topAnchor.constraint(equalTo:titleTextField.bottomAnchor, constant: 40).isActive = true
        totalTextField.leftAnchor.constraint(equalTo:self.view.leftAnchor, constant: 20).isActive = true
        totalTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-40).isActive = true
        
        lineView2.topAnchor.constraint(equalTo:totalTextField.bottomAnchor, constant: 10).isActive = true
        lineView2.leftAnchor.constraint(equalTo:totalTextField.leftAnchor).isActive = true
        lineView2.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-40).isActive = true
        lineView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo:totalTextField.bottomAnchor, constant: 40).isActive = true
        dateLabel.leftAnchor.constraint(equalTo:self.view.leftAnchor, constant: 20).isActive = true
        
        dateTextView.topAnchor.constraint(equalTo:dateLabel.bottomAnchor, constant: -5).isActive = true
        dateTextView.leftAnchor.constraint(equalTo:self.view.leftAnchor, constant: 16).isActive = true
        dateTextView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-40).isActive = true
        dateTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        lineView3.topAnchor.constraint(equalTo:dateTextView.bottomAnchor, constant: 10).isActive = true
        lineView3.leftAnchor.constraint(equalTo:totalTextField.leftAnchor).isActive = true
        lineView3.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-40).isActive = true
        lineView3.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        payLabel.topAnchor.constraint(equalTo:dateTextView.bottomAnchor, constant: 40).isActive = true
        payLabel.leftAnchor.constraint(equalTo:self.view.leftAnchor, constant: 20).isActive = true
        
        payTextView.topAnchor.constraint(equalTo:payLabel.bottomAnchor, constant: -5).isActive = true
        payTextView.leftAnchor.constraint(equalTo:self.view.leftAnchor, constant: 16).isActive = true
        payTextView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-40).isActive = true
        payTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        simpleButton.topAnchor.constraint(equalTo:payLabel.topAnchor).isActive = true
        simpleButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        simpleButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        simpleButton.widthAnchor.constraint(equalToConstant: 400).isActive = true
        simpleButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        lineView4.topAnchor.constraint(equalTo:payTextView.bottomAnchor, constant: 10).isActive = true
        lineView4.leftAnchor.constraint(equalTo:payTextView.leftAnchor).isActive = true
        lineView4.widthAnchor.constraint(equalToConstant: self.view.frame.size.width-40).isActive = true
        lineView4.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        forButton.topAnchor.constraint(equalTo:payTextView.bottomAnchor, constant: 40).isActive = true
        forButton.leftAnchor.constraint(equalTo:self.view.leftAnchor, constant: 20).isActive = true
        forButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        forButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        forLabel.leftAnchor.constraint(equalTo:forButton.rightAnchor, constant: 10).isActive = true
        forLabel.centerYAnchor.constraint(equalTo: forButton.centerYAnchor).isActive = true
        
        datePicker.bottomAnchor.constraint(equalTo:self.view.bottomAnchor, constant: 0).isActive = true
        datePicker.leftAnchor.constraint(equalTo:self.view.leftAnchor, constant: 0).isActive = true
        datePicker.widthAnchor.constraint(equalToConstant: self.view.frame.size.width).isActive = true
        
        toolBar.bottomAnchor.constraint(equalTo:datePicker.topAnchor, constant: 0).isActive = true
        toolBar.leftAnchor.constraint(equalTo:datePicker.leftAnchor, constant: 0).isActive = true
        toolBar.widthAnchor.constraint(equalToConstant: self.view.frame.size.width).isActive = true
        
        collectionView!.topAnchor.constraint(equalTo:forLabel.bottomAnchor, constant: 30).isActive = true
        collectionView!.bottomAnchor.constraint(equalTo:self.view.bottomAnchor, constant: 0).isActive = true
        collectionView!.leftAnchor.constraint(equalTo:self.view.leftAnchor, constant: 0).isActive = true
        collectionView!.rightAnchor.constraint(equalTo:self.view.rightAnchor, constant: 0).isActive = true
        
        
    }
    
    // MARK: actions
    
    @objc func didClickCancelButton(_sender:AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didClickSaveButton(_sender:AnyObject) {
        let data = self.createTransactionData()
        Dispatcher.shared.dispatchActionCreateTransaction(_transData: data)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        self.datePicker.resignFirstResponder()
        datePicker.isHidden = true
        self.toolBar.isHidden = true
        
        
    }
    
    @objc func cancelClick() {
        self.datePicker.resignFirstResponder()
        datePicker.isHidden = true
        self.toolBar.isHidden = true
        
    }
    
    @objc func didCLickForButton(_sender: UIButton) {
        let forwhomVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForWhomViewController") as! ForWhomViewController
        forwhomVC.members = self.members
        forwhomVC.delegate = self
        let navigationVC = UINavigationController(rootViewController: forwhomVC)
        self.navigationController?.present(navigationVC, animated: true, completion: nil)
    }
    
    @objc func didCLickSimpleButton(_sender: UIButton) {
        let whopayVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WhoPayViewController") as! WhoPayViewController
        whopayVC.dataSource = members
        whopayVC.delegate = self
        let navigationVC = UINavigationController(rootViewController: whopayVC)
        self.navigationController?.present(navigationVC, animated: true, completion: nil)
    }
    
    // MARK: @WhoPayViewControllerDelegate
    func didChooseUser(_controller: WhoPayViewController, _user: User?) {
        if (_user == nil) {
            return
        }
        DispatchQueue.main.async {
            self.setWhoPayForTransaction(_user: _user!)
        }
    }
    
    // MARK: @ForWhomViewControllerDelegate
    func didChooseMembers(_controller: ForWhomViewController, _members: Array<ItemForWhomCell>) {
        DispatchQueue.main.async {
            var total:Double = 0
            for item in _members {
                total += item.value!
            }
            self.totalTextField.text = String(format: "%.2f", total)
            self.dataSource = _members
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: views
    let forButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.orange
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didCLickForButton(_sender:)), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let simpleButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didCLickSimpleButton(_sender:)), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.timeZone = NSTimeZone.local
        picker.backgroundColor = UIColor.white
        picker.layer.cornerRadius = 5.0
        picker.layer.shadowOpacity = 0.5
        picker.addTarget(self, action: #selector(onDidChangeDate(_sender:)), for: .valueChanged)
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Date"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let payLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Paid by"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lineView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lineView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lineView3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lineView4: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let toolBar: UIToolbar = {
        let tool = UIToolbar()
        tool.translatesAutoresizingMaskIntoConstraints = false
        return tool
    }()
    
    let titleTextField: UITextField = {
        let placeholder = NSAttributedString(string: "Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let textField = UITextField()
        textField.attributedPlaceholder = placeholder
        textField.textColor = UIColor.black
        textField.borderStyle = UITextField.BorderStyle.none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let totalTextField: UITextField = {
        let placeholder = NSAttributedString(string: "Amount", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let textField = UITextField()
        textField.attributedPlaceholder = placeholder
        textField.textColor = UIColor.black
        textField.borderStyle = UITextField.BorderStyle.none
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let dateTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.black
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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
    
    
    let forLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkText
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "For whom"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
}
