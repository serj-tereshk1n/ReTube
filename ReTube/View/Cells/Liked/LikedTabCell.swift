//
//  LikedTabCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 19/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class LikedTabCell: BaseTabCell {
    
    var liked = [STVideo]()
    
    let kMargin: CGFloat = 16
    let kSectionHeaderId = "kSectionHeaderId"
    let kFeedCellID = "kFeedCellID"
    
    @objc override func fetchDataSource() {
        liked = STLikedHelper.shared.allVideos()
        collectionView.reloadData()
        refresher.endRefreshing()
    }
    
    override func registerCells() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchDataSource),
            name: kReloadLikedTabNotification,
            object: nil)
        
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kSectionHeaderId)
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: kFeedCellID)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liked.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kFeedCellID, for: indexPath) as! VideoCell
        cell.video = liked[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let isIpad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
        
        let width = frame.width - kMargin * 2
        let ipadWidth = (frame.width - kMargin * 4) / 3
        let ratioIndex: CGFloat = 9 / 16
        let height = isIpad ? ipadWidth * ratioIndex : width * ratioIndex
        let supplementaryHeight: CGFloat = 86
        
        return CGSize(width: isIpad ? ipadWidth : width,
                      height: height + supplementaryHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        VideoLauncher.sharedInstance.showVideoPlayer()
        VideoLauncher.sharedInstance.loadVideAndRelatedPlaylist(video: liked[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kSectionHeaderId, for: indexPath) as! SectionHeaderView
        header.titleLabel.text = "Liked videos"
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return kMargin
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return kMargin
    }
}
