//
//  ForWhomViewController.swift
//  deacount
//
//  Created by tamnt2692 on 3/25/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

protocol ForWhomViewControllerDelegate : AnyObject {
    func didChooseMembers(_controller:ForWhomViewController, _members: Array<ItemForWhomCell>)
}

class ForWhomViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    private(set) var collectionView: UICollectionView?
    weak var delegate:ForWhomViewControllerDelegate?
    var members: Array<User>?
    
    private(set) var dataSource: Array<ItemForWhomCell>?
    
    // MARK: life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.setupDataSource()
        self.setupCollectionView()
    }
    

    // MARK: private
    private func setupNavigation() {
        let leftBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(didClickCancelButton(_sender:)));
        self.navigationItem.setLeftBarButtonItems([leftBarItem], animated: true)
        
        let rightBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(didClickSaveButton(_sender:)));
        self.navigationItem.setRightBarButtonItems([rightBarItem], animated: true)
        
        self.title = "For whom?"
    }
    
    private func setupDataSource() {
        let items = self.members?.map({ (user) -> ItemForWhomCell in
            CommonUI.buildItemForWhomCell(_user: user)
        })
        self.dataSource = items
    }
    
    private func setupCollectionView() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: 60)
        
        var collectionViewFrame:CGRect = self.view.frame;
        collectionViewFrame.size.height -= topbarHeight
        collectionViewFrame.origin.y += topbarHeight
        
        let collectionView:UICollectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ForWhomCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
        collectionView.allowsSelection = true
        self.collectionView = collectionView
        self.view.addSubview(collectionView)
    }
    
    // MARK: actions
    @objc func didClickCancelButton(_sender:AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didClickSaveButton(_sender:AnyObject) {
        let items = self.dataSource?.filter({ (item) -> Bool in
            (item.checked ==  true && item.value! > 0)
        })
        self.delegate?.didChooseMembers(_controller: self, _members: items!)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: @UICollectionViewDelegate, @UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.dataSource?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath as IndexPath) as! ForWhomCollectionViewCell
        cell.backgroundColor = UIColor.white
        cell.indexPath = indexPath
        cell.tfDelegate = self
        cell.setItem(_item: self.dataSource![indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.dataSource![indexPath.item]
        item.checked = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let item = self.dataSource![indexPath.item]
        item.checked = false
    }

}
