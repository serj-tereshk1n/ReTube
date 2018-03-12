//
//  FeedCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 27/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class FeedCell: BaseCollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var videos = [YTVideo]()
    
    let kFeedCellID = "kFeedCellID"
    var nextPageToken: String?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    func fetchVideos() {

        ApiService.sharedInstance.searchVideosNextPage(nextPageToken: nextPageToken) { (ytSearchResponse) in
            self.videos.append(contentsOf: ytSearchResponse.items)
            self.nextPageToken = nil
            self.nextPageToken = ytSearchResponse.nextPageToken
            self.collectionView.reloadData()
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: kFeedCellID)
        collectionView.alwaysBounceVertical = false
        fetchVideos()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kFeedCellID, for: indexPath) as! VideoCell
        cell.video = videos[indexPath.row]

        if indexPath.row == videos.count - 3 && nextPageToken != nil {
            // request next page
            fetchVideos()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.width
        let height = (width - 32) * 9 / 16
        return CGSize(width: width, height: height + 112)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        VideoLauncher.sharedInstance.showVideoPlayer()
        VideoLauncher.sharedInstance.loadVideo(id: videos[indexPath.row].id.videoId ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
