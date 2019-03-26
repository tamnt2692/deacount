//
//  WhoPayViewController.swift
//  deacount
//
//  Created by tamnt2692 on 3/25/19.
//  Copyright © 2019 tamnt. All rights reserved.
//

import UIKit

protocol WhoPayViewControllerDelegate: AnyObject {
    func didChooseUser(_controller: WhoPayViewController, _user: User?)
}

class WhoPayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    weak var delegate:WhoPayViewControllerDelegate?
    private(set) var collectionView: UICollectionView?
    var dataSource: Array<User>? = Array<User>()
    
    // MARK: life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.setupDataSource()
        self.setupCollectionView()
    }
    
    
    // MARK: private
    private func setupNavigation() {
        let barItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(didClickCancelButton(_sender:)));
        self.navigationItem.setLeftBarButtonItems([barItem], animated: true)
        self.title = "Who pay?"
    }
    
    
    private func setupDataSource() {
        
    }
    
    private func setupCollectionView() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: 45)
        
        var collectionViewFrame:CGRect = self.view.frame;
        
        let collectionView:UICollectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        self.collectionView = collectionView
        self.view.addSubview(collectionView)
    }
    
    private func didChooseUser(_user: User?) {
        self.delegate?.didChooseUser(_controller: self, _user: _user)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: actions
    @objc func didClickCancelButton(_sender:AnyObject) {
        self.didChooseUser(_user: nil)
    }
    
    // MARK: @UICollectionViewDelegate, @UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.dataSource?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath as IndexPath) as! UserCollectionViewCell
        cell.backgroundColor = UIColor.white
        cell.setItem(_item: self.dataSource![indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let userDidSelect = self.dataSource![indexPath.item] as User
        self.didChooseUser(_user: userDidSelect)
    }
}
