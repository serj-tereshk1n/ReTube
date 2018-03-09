//
//  TrandingCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 27/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class PlaylistsHostCell: FeedCell {
    
    var playLists: [YTPlayList]?
    
    let kPlaylistCellId = "kPlaylistCellId"
    
    override func fetchVideos() {
//        ApiService.sharedInstance.fetchTrending { (videos) in
//            self.videos = videos
//            self.collectionView.reloadData()
//        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        collectionView.register(PlaylistCell.self, forCellWithReuseIdentifier: kPlaylistCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playLists?.count ?? 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPlaylistCellId, for: indexPath) as! PlaylistCell
//        cell.backgroundColor = UIColor.random()

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size.width
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        VideoLauncher.sharedInstance.showVideoPlayer()
    }
}
