//
//  HomeTabCell.swift
//  ReTube
//
//  Created by Ner√e D4mage on 13/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class HomeTabCell: BaseTabCell {
    
    var feed = [STVideo]()
    
    let kPopularSectionHeight: CGFloat = 200
    let kFeedCellID = "kFeedCellID"
    let kPopularSectionCellID = "kPopularSectionCellID"
    
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
        super.registerCells()
        
        collectionView.register(HSectionCell.self, forCellWithReuseIdentifier: kPopularSectionCellID)
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: kFeedCellID)
        
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
    
    override func numberOfSections() -> Int {
        return 2
    }
    
    override func heightForFooterIn(section: Int) -> CGFloat {
        if feed.count > 0 && nextPageToken == nil { return 0 }
        return section == 1 ? kFooterHeight /* collectionView.frame.height - kPopularSectionHeight - kMargin - kMargin - kHeaderHeight - kHeaderHeight */ : 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        shouldRequestNextPage(index: indexPath.row, count: feed.count)

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
        
        if indexPath.section == 0 {
            return CGSize(width: frame.width,
                          height: kPopularSectionHeight)
        }
        
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
        VideoLauncher.sharedInstance.loadVideAndRelatedPlaylist(video: feed[indexPath.row])
    }
    
    override func titleForHeaderIn(section: Int) -> String {
        var headerTitle = "Header"
        switch section {
        case 0:
            headerTitle = "Popular videos"
            break;
        case 1:
            headerTitle = "Channel feed"
            break;
        default:
            print("Unknown header for section:", section)
            break;
        }
        return headerTitle
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
