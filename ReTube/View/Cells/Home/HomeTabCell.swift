//
//  HomeTabCell.swift
//  ReTube
//
//  Created by Ner√e D4mage on 13/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class HomeTabCell: BaseTabCell {
    
    var numberOfSections = 2
    var feed = [STVideo]()
    
    let kMargin: CGFloat = 16
    let kSectionHeaderId = "kSectionHeaderId"
    let kFeedCellID = "kFeedCellID"
    let kPopularSectionCellID = "kPopularSectionCellID"
    let kSectionFooterId = "kSectionFooterId"
    
    override func startingRefresh() {
        super.startingRefresh()
        feed = [STVideo]()
        collectionView.reloadData()
    }
    
    override func fetchDataSource() {
        ApiService.sharedInstance.searchNextPage(nextPageToken: nextPageToken, order: .date) { (response) in
            self.feed.append(contentsOf: response.items)
            self.nextPageToken = response.nextPageToken
            self.collectionView.reloadData()
            self.refresher.endRefreshing()
        }
    }
    
    override func registerCells() {
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kSectionHeaderId)
        collectionView.register(HSectionCell.self, forCellWithReuseIdentifier: kPopularSectionCellID)
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: kFeedCellID)
        collectionView.register(LoadingCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: kSectionFooterId)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playRandomVideo),
            name: kPlayRandomVideoNotification,
            object: nil)
    }
    
    @objc func playRandomVideo() {
        let index = arc4random_uniform(UInt32(feed.count - 1))
        VideoLauncher.sharedInstance.showVideoPlayer()
        VideoLauncher.sharedInstance.loadVideAndRelatedPlaylist(video: feed[Int(index)])
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return feed.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == feed.count - 3 && nextPageToken != nil {
            // request next page
            fetchDataSource()
        }
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPopularSectionCellID, for: indexPath) as! HSectionCell
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kFeedCellID, for: indexPath) as! VideoCell
            cell.video = feed[indexPath.row]
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let isIpad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
        
        let width = frame.width - kMargin * 2
        let ipadWidth = (frame.width - kMargin * 4) / 3
        let ratioIndex: CGFloat = 9 / 16
        let height = isIpad ? ipadWidth * ratioIndex : width * ratioIndex
        let supplementaryHeight: CGFloat = 86
        
        if indexPath.section == 0 {
            return CGSize(width: frame.width,
                          height: 175)
        }
        
        return CGSize(width: isIpad ? ipadWidth : width,
                      height: height + supplementaryHeight)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        VideoLauncher.sharedInstance.showVideoPlayer()
        VideoLauncher.sharedInstance.loadVideAndRelatedPlaylist(video: feed[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: kSectionFooterId, for: indexPath) as! LoadingCell
            
            return footer
            
        } else {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kSectionHeaderId, for: indexPath) as! SectionHeaderView
            
            var headerTitle = "Header"
            
            switch indexPath.section {
            case 0:
                headerTitle = "Popular videos"
                break;
            case 1:
                headerTitle = "Channel feed"
                break;
            default:
                print("Unknown header for section:", indexPath.section)
                break;
            }
            
            header.titleLabel.text = headerTitle
            
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 1 {
            if feed.count == 0 {
                return CGSize(width: collectionView.frame.size.width - kMargin - kMargin, height: collectionView.frame.size.height - 175 - 70 - kMargin - kMargin)
            } else {
                return CGSize(width: collectionView.frame.size.width, height: 50)
            }
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 1 {
            return UIEdgeInsets(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin)
        }
    
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
     
        return kMargin
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return kMargin
    }
}
