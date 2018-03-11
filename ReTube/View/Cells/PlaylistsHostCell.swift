//
//  TrandingCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 27/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class PlaylistsHostCell: FeedCell {
    
    var playLists = [YTPlayList]()
    
    let kPlaylistCellId = "kPlaylistCellId"
    
    override func fetchVideos() {

        ApiService.sharedInstance.searchPlayListsNextPage(nextPageToken: nextPageToken) { (ytPlayListsResponse) in
            self.playLists.append(contentsOf: ytPlayListsResponse.items)
            self.nextPageToken = nil
            self.nextPageToken = ytPlayListsResponse.nextPageToken
            self.collectionView.reloadData()
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        collectionView.register(PlaylistCell.self, forCellWithReuseIdentifier: kPlaylistCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playLists.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPlaylistCellId, for: indexPath) as! PlaylistCell
        cell.playList = playLists[indexPath.row]
        if indexPath.row == ytvideos.count - 3 && nextPageToken != nil {
            // request next page
            fetchVideos()
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size.width - 32 - 16
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        VideoLauncher.sharedInstance.showVideoPlayer()
        VideoLauncher.sharedInstance.loadPlayList(list: playLists[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
