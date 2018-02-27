//
//  ViewController.swift
//  ReTube
//
//  Created by sergey.tereshkin on 19/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let kSectionCellId = "kSectionCellId"
    let kFeedCellId = "kFeedCellId"
    let kTrandingCellId = "kTrandingCellId"
    let kSubscriptionsCellId = "kSubscriptionsCellId"
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  Home"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        setupCollectionView()
        setupMenuBar()
        setupNavBarButtons()
    }
    
    private func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView?.backgroundColor = .white
//        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: kCellId)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: kSectionCellId)
        collectionView?.register(TrandingCell.self, forCellWithReuseIdentifier: kTrandingCellId)
        collectionView?.register(SubscriptionFeed.self, forCellWithReuseIdentifier: kSubscriptionsCellId)
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.isPagingEnabled = true
    }
    
    private func setupMenuBar() {
        
        navigationController?.hidesBarsOnSwipe = true
        
        let redView = UIView()
        redView.backgroundColor = .ytRed
        
        view.addSubview(redView)
        view.addSubview(menuBar)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    private func setupNavBarButtons() {
        let searchImage = UIImage(named: "ic_search")?.withRenderingMode(.alwaysOriginal)
        let moreVerticalImage = UIImage(named: "ic_more_vertical")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let moreBarButtonItem = UIBarButtonItem(image: moreVerticalImage, style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
    }
    
    let settingsLauncher = SettingsLauncher()
    
    @objc private func handleMore() {
        //show settings
        settingsLauncher.showSettings()
    }
    
    @objc private func handleSearch() {
        
    }
    
    func scrollToMenuAt(indexPath: IndexPath) {
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(titles[Int(indexPath.row)])"
        }
    }
    
    // MARK - CollectionView delegate/dataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 1 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: kTrandingCellId, for: indexPath) as! TrandingCell
        } else if indexPath.item == 2 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: kSubscriptionsCellId, for: indexPath) as! SubscriptionFeed
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: kSectionCellId, for: indexPath) as! FeedCell
        }
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kSectionCellId, for: indexPath) as! FeedCell
//        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    let titles = ["Home", "Trending", "Playlists", "Profile"]
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(titles[Int(index)])"
        }
    }
}


