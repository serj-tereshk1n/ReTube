//
//  LikedTabCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 19/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class LikedTabCell: BaseTabCell {
    
//    let kLikedSectionId = "kLikedSectionId"
//    let kWatchAgainSectionId = "kWatchAgainSectionId"
//    let kContinueWatchingSectionId = "kContinueWatchingSectionId"
    
    var sections = [STSection]()

    let kFeedCellID = "kFeedCellID"
    
    @objc override func fetchDataSource() {
        sections = [STSection]()
        
        let watchAgain = STDefaultsHelper.shared.allWatchAgainVideos()
        let continueWatching = STDefaultsHelper.shared.allContinueWatchingVideos()
        let liked = STDefaultsHelper.shared.allLikedVideos()
        
        if watchAgain.count > 0 {
            sections.append(STSection(headerTitle: "Watch again", scrollDirection: .horizontal, dataSource: watchAgain))
        }
        if continueWatching.count > 0 {
            sections.append(STSection(headerTitle: "Continue watching", scrollDirection: .horizontal, dataSource: continueWatching))
        }
        if liked.count > 0 {
            sections.append(STSection(headerTitle: "Liked videos", scrollDirection: .horizontal, dataSource: liked))
        }
        collectionView.reloadData()
        refresher.endRefreshing()
    }
    
    override func registerCells() {
        super.registerCells()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchDataSource),
            name: kReloadLikedTabNotification,
            object: nil)
        
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kSectionHeaderId)
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: kFeedCellID)
    }
    
    override func numberOfSections() -> Int {
        return sections.count
    }
    
    override func heightForFooterIn(section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kFeedCellID, for: indexPath) as! VideoCell
        cell.video = sections[indexPath.section].dataSource[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let isIpad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
        
        let width = (frame.width - kMargin * 3) / 2
        let ipadWidth = (frame.width - kMargin * 4) / 3
        let ratioIndex: CGFloat = 9 / 16
        let height = isIpad ? ipadWidth * ratioIndex : width * ratioIndex
        let supplementaryHeight: CGFloat = 86
        
        return CGSize(width: isIpad ? ipadWidth : width,
                      height: height + supplementaryHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vdo = sections[indexPath.section].dataSource[indexPath.row]
        VideoLauncher.sharedInstance.showVideoPlayer()
        VideoLauncher.sharedInstance.loadVideAndRelatedPlaylist(video: vdo)
    }
    
    override func titleForHeaderIn(section: Int) -> String {
        return sections[section].headerTitle
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
