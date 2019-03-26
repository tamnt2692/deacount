//
//  GroupDetailViewController.swift
//  deacount
//
//  Created by tamnt2692 on 3/24/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

class GroupDetailViewController: UIViewController, LoginViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, DataManagerDelegate {
    
    var groupID:String?
    private(set) var group:Group?
    private(set) var members:Array<User>?
    var needCheckLoginUser:Bool = true
    var needPopController:Bool = false
    var type:GroupDetail?
    
    private(set) var collectionView: UICollectionView?
    private(set) var dataSource: Array<ItemTransactionCell>? = Array<ItemTransactionCell>()
    
    private(set) var collectionViewBalances: UICollectionView?
    private(set) var dataSourceBalances: Array<ItemDebtCell>? = Array<ItemDebtCell>()
    
    private(set) var receiptDataManager:String?
    
    // MARK: init
    deinit {
        DataManager.shared.unregister(_receipt: self.receiptDataManager!)
    }
    
    // MARK: life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.receiptDataManager = DataManager.shared.register(_delegate: self)
        let group = DataManager.shared.getGroup(_groupID: self.groupID!)
        self.group = group
        self.members = DataManager.shared.allUser().filter({ (u) -> Bool in
            return (group.members?.contains(u.tradableID!))!
        })
        self.setupNavigationBar()
        if (CommonUI.loginUser != nil) {
            self.needCheckLoginUser = false
            self.showCollectionView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (self.needPopController) {
            self.navigationController?.popViewController(animated: true)
            return;
        }
        
        if (self.needCheckLoginUser) {
            self.needCheckLoginUser = false
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            loginVC.delegate = self
            let navigationVC = UINavigationController(rootViewController: loginVC)
            self.navigationController?.present(navigationVC, animated: true, completion: nil)
            return
        }
        
    }
    
    // MARK: private
    private func setupNavigationBar() {
        let label = UILabel(frame: CGRect(x:0, y:0, width:self.view.frame.size.width/2.0, height:50))
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .black
        let membersName = self.members?.map({ (user) -> String in
            user.name!
        })
        let groupTitle = (self.group?.title)!
        label.text = CommonUI.buildGroupDetailTitleNavigationBar(_title: groupTitle, _members: membersName!)
        self.navigationItem.titleView = label
    }
    
    func didChooseUser(_loginController: LoginViewController, _user: User?) {
        if (_user == nil) {
            self.needPopController = true
            return
        }
        self.showCollectionView()
    }
    
    
    private func showCollectionView() {
        self.setupCollectionView()
        self.setupCollectionViewBalances()
        self.setupBottomBar()
        self.setupTopBar()
        self.didClickTopBarButton(_sender: topbarButtonE)
    }
    
    private func setupBottomBar() {
        self.view.addSubview(bottombarView)
        self.view.addSubview(bottombarButton)
        self.view.addSubview(myTotal1)
        self.view.addSubview(myTotal2)
        self.view.addSubview(myBalance1)
        self.view.addSubview(myBalance2)
        
        bottombarView.leftAnchor.constraint(equalTo:self.view.leftAnchor).isActive = true
        bottombarView.rightAnchor.constraint(equalTo:self.view.rightAnchor).isActive = true
        bottombarView.bottomAnchor.constraint(equalTo:self.view.bottomAnchor).isActive = true
        bottombarView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bottombarButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bottombarButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        bottombarButton.centerXAnchor.constraint(equalTo: bottombarView.centerXAnchor).isActive = true
        bottombarButton.centerYAnchor.constraint(equalTo: bottombarView.centerYAnchor).isActive = true
        
        myTotal1.centerXAnchor.constraint(equalTo: bottombarView.centerXAnchor, constant: -100).isActive = true
        myTotal1.centerYAnchor.constraint(equalTo: bottombarView.centerYAnchor, constant: -10).isActive = true
        
        myTotal2.centerXAnchor.constraint(equalTo: bottombarView.centerXAnchor, constant: -100).isActive = true
        myTotal2.centerYAnchor.constraint(equalTo: bottombarView.centerYAnchor, constant: 10).isActive = true
        
        myBalance1.centerXAnchor.constraint(equalTo: bottombarView.centerXAnchor, constant: 100).isActive = true
        myBalance1.centerYAnchor.constraint(equalTo: bottombarView.centerYAnchor, constant: -10).isActive = true
        
        myBalance2.centerXAnchor.constraint(equalTo: bottombarView.centerXAnchor, constant: 100).isActive = true
        myBalance2.centerYAnchor.constraint(equalTo: bottombarView.centerYAnchor, constant: 10).isActive = true

    }
    
    private func setupTopBar() {
        self.view.addSubview(topbarView)
        self.view.addSubview(topbarButtonE)
        self.view.addSubview(topbarButtonB)
        topbarView.leftAnchor.constraint(equalTo:self.view.leftAnchor).isActive = true
        topbarView.rightAnchor.constraint(equalTo:self.view.rightAnchor).isActive = true
        topbarView.topAnchor.constraint(equalTo:self.view.topAnchor, constant:topbarHeight).isActive = true
        topbarView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        topbarButtonE.leftAnchor.constraint(equalTo:self.view.leftAnchor, constant: 30).isActive = true
        topbarButtonE.topAnchor.constraint(equalTo:self.view.topAnchor, constant:topbarHeight).isActive = true
        topbarButtonE.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        topbarButtonB.rightAnchor.constraint(equalTo:self.view.rightAnchor, constant: -30).isActive = true
        topbarButtonB.topAnchor.constraint(equalTo:self.view.topAnchor, constant:topbarHeight).isActive = true
        topbarButtonB.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    private func setupCollectionView() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 55, left: 0, bottom: 50, right: 0)
        layout.minimumLineSpacing = 2
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: 75)
        
        let collectionViewFrame:CGRect = self.view.frame;
        let collectionView:UICollectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TransactionCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        self.collectionView = collectionView
        self.view.addSubview(collectionView)
    }
    
    private func setupCollectionViewBalances() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 55, left: 0, bottom: 50, right: 0)
        layout.minimumLineSpacing = 2
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: 125)
        
        let collectionViewFrame:CGRect = self.view.frame;
        let collectionView:UICollectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DebtCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        self.collectionViewBalances = collectionView
        self.view.addSubview(collectionView)
    }
    
    private func reloadDataSource() {
        
        let transactions = DataManager.shared.getTransactions(_transactionIDs: (self.group?.transactions!)!)
        let items = transactions.map { (trans) -> ItemTransactionCell in
            CommonUI.buildItemTransactionCell(_trans: trans)
        }
        var total:Double = 0
        var balance:Double = 0
        for item in items {
            total += item.vspent!
            balance += item.vbalance!
        }
        self.myTotal2.text = CommonUI.buildValueString(_value: total)
        self.myBalance2.text = CommonUI.buildValueString(_value: balance)
        self.dataSource = items
        
        let records = DataManager.shared.getRecordsOfDeacount(_deacount: self.groupID!)
        var result:Array<DebtData> = Array<DebtData>()
        
        for (index, element) in (self.members?.enumerated())! {
            let arraySlice = self.members?.suffix(from: index+1)
            let newArray = Array(arraySlice!)
            if (newArray.count > 0) {
                for (_, jelement) in newArray.enumerated() {
                    let recordsR = records.filter { (key, value) -> Bool in
                        (value.source == element.tradableID! && value.target == jelement.tradableID)
                    }
                    if (recordsR.count > 0) {
                        let a = GroupDetailViewController.findDrOrCr(_records: Array(recordsR.values))
                        if (a != 0.0) {
                            let debt = DebtData()
                            debt.left = element.name
                            debt.leftID = element.tradableID
                            debt.right = jelement.name
                            debt.rightID = jelement.tradableID
                            debt.value = a
                            
                            result.append(debt)
                        }
                    }
                }
            }
        }
        let itemsBlance = result.map { (debt) -> ItemDebtCell in
            CommonUI.buildItemDebtCell(_debt: debt)
        }
        self.dataSourceBalances = itemsBlance
    }
    
    static func findDrOrCr(_records: Array<Record>) -> Double {
        var result:Double = 0
        for record in _records {
            if (record.type == .dr) {
                result -= record.value!
            } else if (record.type == .cr) {
                result += record.value!
            }
        }
        return result
    }
    
    // MARK: @UICollectionViewDelegate, @UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.collectionView) {
            return (self.dataSource?.count)!
        } else if (collectionView == self.collectionViewBalances) {
            return (self.dataSourceBalances?.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == self.collectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath as IndexPath) as! TransactionCollectionViewCell
            cell.backgroundColor = UIColor.white
            cell.setItem(_item: self.dataSource![indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath as IndexPath) as! DebtCollectionViewCell
            cell.backgroundColor = UIColor.white
            cell.setItem(_item: self.dataSourceBalances![indexPath.item])
            return cell
        }
    }
    
    // MARK: @DataManagerDelegate
    func dataManagerDidChange(_manager: DataManager, _type: DataChange, _data: Any) {
        if (_type == .addtransactions) {
            DispatchQueue.main.async {
                var activeCollectionView:UICollectionView?
                if (self.type == GroupDetail.expenses) {
                    activeCollectionView = self.collectionView
                } else if (self.type == GroupDetail.banlances) {
                    activeCollectionView = self.collectionViewBalances
                }
                self.reloadDataSource()
                activeCollectionView?.alpha = 1.0
                activeCollectionView?.reloadData()
            }
        }
    }
    
    // MARK: actions
    @objc private func didClickBottomBarButton(_sender: UIButton) {
        
        let addTransactionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTransactionViewController") as! AddTransactionViewController
        addTransactionVC.deacount = self.groupID
        addTransactionVC.members = self.members
        let navigationVC = UINavigationController(rootViewController: addTransactionVC)
        self.navigationController?.present(navigationVC, animated: true, completion: nil)
    }
    
    @objc private func didClickTopBarButton(_sender: UIButton) {
        topbarButtonE.alpha = 0.5
        topbarButtonB.alpha = 0.5
        collectionView?.alpha = 0.0
        collectionViewBalances?.alpha = 0.0
        _sender.alpha = 1.0
        
        var activeCollectionView:UICollectionView?
        if (_sender == topbarButtonE) {
            type = GroupDetail.expenses
            activeCollectionView = collectionView
            collectionView?.alpha = 1.0
        } else if (_sender == topbarButtonB) {
            type = GroupDetail.banlances
            activeCollectionView = collectionViewBalances
        }
        self.reloadDataSource()
        activeCollectionView?.alpha = 1.0
        activeCollectionView?.reloadData()
    }
    
    // MARK: views
    let bottombarView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottombarButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didClickBottomBarButton(_sender:)), for: UIControl.Event.touchUpInside)
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.backgroundColor = .white
        button.setTitle("+", for: UIControl.State.normal)
        button.setTitleColor(UIColor.init(red: 51/255.0, green: 204/255.0, blue: 255/255.0, alpha: 1), for: UIControl.State.normal)
        button.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 30)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let topbarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let topbarButtonE: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didClickTopBarButton(_sender:)), for: UIControl.Event.touchUpInside)
        button.setTitle("EXPENSES", for: UIControl.State.normal)
        button.setTitleColor(UIColor.init(red: 51/255.0, green: 204/255.0, blue: 255/255.0, alpha: 1), for: UIControl.State.normal)
        button.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let topbarButtonB: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didClickTopBarButton(_sender:)), for: UIControl.Event.touchUpInside)
        button.setTitle("BALANCES", for: UIControl.State.normal)
        button.setTitleColor(UIColor.init(red: 51/255.0, green: 204/255.0, blue: 255/255.0, alpha: 1), for: UIControl.State.normal)
        button.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let myTotal1: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.lightGray
        label.text = "MY TOTAL"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let myTotal2: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let myBalance1: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.text = "MY BALANCE"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let myBalance2: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


}
