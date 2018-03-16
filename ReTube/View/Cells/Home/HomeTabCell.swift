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
    var popular = [STVideo]()
    
    let kMargin: CGFloat = 16
    
    let kSectionHeaderId = "kSectionHeaderId"
    let kFeedCellID = "kFeedCellID"
    let kPopularSectionCellID = "kPopularSectionCellID"
    
    override func fetchDataSource() {
        ApiService.sharedInstance.searchNextPage(nextPageToken: nextPageToken, order: .date) { (response) in
            self.feed.append(contentsOf: response.items)
            self.nextPageToken = response.nextPageToken
            ApiService.sharedInstance.searchNextPage(nextPageToken: nil, order: .viewCount, completion: { (response) in
                self.popular.append(contentsOf: response.items)
                self.collectionView.reloadData()
            })
        }
    }
    
    override func registerCells() {
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kSectionHeaderId)
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: kFeedCellID)
        collectionView.register(HSectionCell.self, forCellWithReuseIdentifier: kPopularSectionCellID)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return popular.count > 0 ? 1 : 0
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
            cell.videos = popular
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
        let supplementaryHeight: CGFloat = 100
        
        if indexPath.section == 0 {
            return CGSize(width: frame.width,
                          height: 170)
        }
        
        return CGSize(width: isIpad ? ipadWidth : width,
                      height: height + supplementaryHeight)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        VideoLauncher.sharedInstance.showVideoPlayer()
        VideoLauncher.sharedInstance.loadVideAndRelatedPlaylist(video: feed[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 35)
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
