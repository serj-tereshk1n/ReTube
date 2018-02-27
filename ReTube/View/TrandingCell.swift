//
//  TrandingCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 27/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class TrandingCell: FeedCell {
    
    override func fetchVideos() {
        ApiService.sharedInstance.fetchTrending { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
