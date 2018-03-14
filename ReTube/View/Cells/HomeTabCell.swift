//
//  HomeTabCell.swift
//  ReTube
//
//  Created by Ner√e D4mage on 13/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class HomeTabCell: BaseTabCell {
    
    var videos = [STVideo]()
    
    let kFeedCellID = "kFeedCellID"
    
    override func fetchDataSource() {
        ApiService.sharedInstance.searchNextPage(nextPageToken: nextPageToken) { (response) in
            self.videos.append(contentsOf: response.items)
            self.nextPageToken = response.nextPageToken
            self.collectionView.reloadData()
        }
    }
    
    override func registerCells() {
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: kFeedCellID)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kFeedCellID, for: indexPath) as! VideoCell
        cell.video = videos[indexPath.row]
        
        if indexPath.row == videos.count - 3 && nextPageToken != nil {
            // request next page
            fetchDataSource()
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.width
        let height = (width - 32) * 9 / 16
        return CGSize(width: width, height: height + 112)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        VideoLauncher.sharedInstance.showVideoPlayer()
        VideoLauncher.sharedInstance.loadVideo(id: videos[indexPath.row].id)
    }
    
//    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
}
