//
//  FeedCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 27/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit
//import NVActivityIndicatorView

class BaseTabCell: BaseCollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var nextPageToken: String?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.alwaysBounceVertical = true
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = .mDarkGray
        refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refresher
    }()
    
//    lazy var activityIndicatorView: NVActivityIndicatorView = {
//        let frame = CGRect(x: 0, y: 0, width: 300, height: 300)
//        let indicator = NVActivityIndicatorView(frame: frame, type: .ballClipRotate, color: .red, padding: 0)
//        return indicator
//    }()
    
    func registerCells() {}
    func fetchDataSource() {}
    func startingRefresh() { nextPageToken = nil }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        collectionView.addSubview(refresher)
        
        registerCells()
        fetchDataSource()
    }
    
    @objc func refreshData() {
//        activityIndicatorView.startAnimating()
        startingRefresh()
        fetchDataSource()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
