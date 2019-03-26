//
//  ViewController.swift
//  deacount
//
//  Created by tamnt5 on 3/23/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, DataManagerDelegate {
    
    private(set) var dataSource: Array<Group>? = Array<Group>()
    private(set) var collectionView: UICollectionView?
    private(set) var receiptDataManager: String?
    
    // MARK: init
    deinit {
        DataManager.shared.unregister(_receipt: self.receiptDataManager!)
    }
    
    // MARK: life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.receiptDataManager = DataManager.shared.register(_delegate: self)
        self.setupNavigation()
        self.setupDataSource()
        self.setupCollectionView()
    }
    
    // MARK: private
    private func setupNavigation() {
        let barItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(didClickAddGroup(_sender:)));
        self.navigationItem.setRightBarButtonItems([barItem], animated: true)
        self.title = "deacount"
    }
    
    private func setupDataSource() {
        let allgroup = DataManager.shared.allGroup()
        self.dataSource = allgroup
    }
    
    private func setupCollectionView() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: 73)
        
        var collectionViewFrame:CGRect = self.view.frame;
        
        let collectionView:UICollectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GroupCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        self.collectionView = collectionView
        self.view.addSubview(collectionView)
    }
    
    // MARK: actions
    @objc func didClickAddGroup(_sender:AnyObject) {
        let addGroupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddGroupViewController") as! AddGroupViewController
        let navigationVC = UINavigationController(rootViewController: addGroupVC)
        self.navigationController?.present(navigationVC, animated: true, completion:nil)
    }
    
    // MARK: @UICollectionViewDelegate, @UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.dataSource?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath as IndexPath) as! GroupCollectionViewCell
        cell.backgroundColor = UIColor.white
        cell.setItem(_item: self.dataSource![indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedGroup = self.dataSource![indexPath.item]
        let groupDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GroupDetailViewController") as! GroupDetailViewController
        groupDetailVC.groupID = selectedGroup.tradableID
        self.navigationController?.pushViewController(groupDetailVC, animated: true)
        
    }
    
    // MARK: @DataManger
    func dataManagerDidChange(_manager: DataManager, _type: DataChange, _data: Any) {
        DispatchQueue.main.async {
            self.setupDataSource()
            self.collectionView?.reloadData()
        }
    }

}

