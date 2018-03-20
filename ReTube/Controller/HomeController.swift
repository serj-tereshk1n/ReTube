//
//  ViewController.swift
//  ReTube
//
//  Created by sergey.tereshkin on 19/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // tab page ids
    let kHomeTabId = "kHomeTabId"
    let kPlayListsTabId = "kPlayListsTabId"
    let kLikedTabId = "kLikedTabId"
    let kProfileTabId = "kProfileTabId"
    
    let settingsLauncher = SettingsLauncher()
    
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
        
        becomeFirstResponder()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(event?.subtype == .motionShake) {
            NotificationCenter.default.post(name: kPlayRandomVideoNotification, object: nil)
        }
    }
    
    private func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        let topInsest: CGFloat = isIphoneX() ? 84 : 50
        
        collectionView?.backgroundColor = .darkBackground
        collectionView?.register(HomeTabCell.self, forCellWithReuseIdentifier: kHomeTabId)
        collectionView?.register(PlaylistsTabCell.self, forCellWithReuseIdentifier: kPlayListsTabId)
        collectionView?.register(LikedTabCell.self, forCellWithReuseIdentifier: kLikedTabId)
        collectionView?.register(SubscriptionFeed.self, forCellWithReuseIdentifier: kProfileTabId)
        collectionView?.contentInset = UIEdgeInsets(top: topInsest, left: 0, bottom: 0, right: 0) // 84 for ihone X
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: topInsest, left: 0, bottom: 0, right: 0)
        collectionView?.isPagingEnabled = true
//        collectionView?.alwaysBounceVertical = false
        collectionView?.bounces = false
    }

    private func setupMenuBar() {
        
        let redView = UIView()
        redView.backgroundColor = .darkBackground
        
        view.addSubview(redView)
        view.addSubview(menuBar)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    private func setupNavBarButtons() {
        let searchImage = UIImage(named: "ic_search")?.withRenderingMode(.alwaysTemplate)
        let moreVerticalImage = UIImage(named: "ic_more_vertical")?.withRenderingMode(.alwaysTemplate)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let moreBarButtonItem = UIBarButtonItem(image: moreVerticalImage, style: .plain, target: self, action: #selector(handleMore))
        searchBarButtonItem.tintColor = .selected
        moreBarButtonItem.tintColor = .selected
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
    }
    
    @objc private func handleMore() {
        //show settings
        settingsLauncher.showSettings()
    }
    
    @objc private func handleSearch() {
        /// TO DO
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
        
        switch indexPath.item {
        case 0:
            return collectionView.dequeueReusableCell(withReuseIdentifier: kHomeTabId, for: indexPath)
        case 1:
            return collectionView.dequeueReusableCell(withReuseIdentifier: kPlayListsTabId, for: indexPath)
        case 2:
            return collectionView.dequeueReusableCell(withReuseIdentifier: kLikedTabId, for: indexPath)
        case 3:
            return collectionView.dequeueReusableCell(withReuseIdentifier: kProfileTabId, for: indexPath)
        default:
            print("Something went very wrong with tab cellls")
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    let titles = ["Feed", "Playlists", "Liked", "Profile"]
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(titles[Int(index)])"
        }
    }
    
    func isIphoneX() -> Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                break;
            case 1334:
                print("iPhone 6/6S/7/8")
                break;
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                break;
            case 2436:
                print("iPhone X")
                return true
            default:
                print("unknown")
            }
        }
        return false
    }
}


