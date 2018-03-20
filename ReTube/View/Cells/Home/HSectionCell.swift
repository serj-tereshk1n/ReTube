//
//  HScrollableCell.swift
//  CollectionViewSections
//
//  Created by sergey.tereshkin on 15/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class HSectionCell: BaseCollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let kSpacing: CGFloat = 16
    var videos = [STVideo]()
    
    var nextPageToken: String?
    let kCellId = "kCellId"
    let kSectionFooterId = "kSectionFooterId"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .darkBackground
        cv.delegate = self
        cv.dataSource = self
        return cv;
    }()
    
    func fetchDataSource() {
        ApiService.sharedInstance.searchNextPage(nextPageToken: nextPageToken, order: .viewCount, completion: { (response) in
            self.nextPageToken = response.nextPageToken
            self.videos.append(contentsOf: response.items)
            self.collectionView.reloadData()
        })
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(collectionView)
        
        addFullScreenConstraintsFor(views: collectionView, inside: self)
        
        collectionView.register(PopularCell.self, forCellWithReuseIdentifier: kCellId)
        collectionView.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: kSectionFooterId)
        
        fetchDataSource()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! PopularCell
        cell.video = videos[indexPath.row]
        
        if indexPath.row == videos.count - 3 && nextPageToken != nil {
            // request next page
            fetchDataSource()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size.height - kSpacing * 2
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: kSectionFooterId, for: indexPath) as! LoadingFooterView
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if videos.count > 0 && nextPageToken == nil { return .zero }
        return CGSize(width: collectionView.frame.size.width - kSpacing * 2,
                      height: collectionView.frame.size.height - kSpacing * 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: kSpacing, left: kSpacing, bottom: kSpacing, right: kSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        VideoLauncher.sharedInstance.showVideoPlayer()
        VideoLauncher.sharedInstance.loadVideAndRelatedPlaylist(video: videos[indexPath.row])
    }
    
}
