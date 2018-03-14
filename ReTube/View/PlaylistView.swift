//
//  PlaylistView.swift
//  ReTube
//
//  Created by sergey.tereshkin on 12/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

@objc protocol PlaylistViewDelegate: class {
    @objc func didSelectVideoWith(id: String)
    
}

class PlaylistView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    weak var delegate: PlaylistViewDelegate?
    
    var videos = [YTPLVideo]()
    var nextPageToken: String?
    var currentVideo: YTPLVideo?
    var playlist: YTPlayList? {
        didSet {
            videos = [YTPLVideo]()
            fetchVideos()
        }
    }
    func fetchVideos() {
        if let list = playlist {
            ApiService.sharedInstance.fetchPlayListItems(id: list.id, nextPageToken: nextPageToken) { (response) in
                self.nextPageToken = nil
                self.nextPageToken = response.nextPageToken
                self.videos.append(contentsOf: response.items)
                self.collectionView.reloadData()
                
                if response.items.count > 0 && self.videos.count == response.items.count {
                    self.collectionView(self.collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
                }
            }
        }
    }
    let kPlayListItemCellId = "kPlayListItemCellId"
    let kMargins: CGFloat = 8
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .mDarkGray
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    let currentVideoInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .mLightGray
        return view
    }()
    let title: UILabel = {
        let label = UILabel()
        label.text = "Temporary video title, (remember to replace)"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    let listName: UILabel = {
        let label = UILabel()
        label.text = "Playlist name here"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
//    func playNext
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupCollectionView()
    }
    
    func setupViews() {
        addSubview(currentVideoInfoView)
        addSubview(collectionView)
        currentVideoInfoView.addSubview(title)
        currentVideoInfoView.addSubview(listName)
        currentVideoInfoView.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: title)
        currentVideoInfoView.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: listName)
        currentVideoInfoView.addConstraintsWithFormat(format: "V:|-16-[v0(20)]-4-[v1(20)]", views: title, listName)
        addConstraintsWithFormat(format: "H:|[v0]|", views: currentVideoInfoView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0(70)]-0-[v1]|", views: currentVideoInfoView, collectionView)
    }
    
    func setupCollectionView() {
        collectionView.register(PlaylistItemCell.self, forCellWithReuseIdentifier: kPlayListItemCellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPlayListItemCellId, for: indexPath) as! PlaylistItemCell
        let video = videos[indexPath.row]
//        if let v = currentVideo {
//            if v.snippet.resourceId?.videoId == video.snippet.resourceId?.videoId {
//                cell.
//            }
//        }
        cell.video = video
        
        if indexPath.row == videos.count - 3 && nextPageToken != nil {
            // request next page
            fetchVideos()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width - kMargins * 2, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentVideo = videos[indexPath.row]
        if let video = currentVideo {
            if let id = video.snippet.resourceId?.videoId {
                title.text = video.snippet.title
                delegate?.didSelectVideoWith(id: id)
                collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kMargins
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: kMargins, left: 0, bottom: kMargins, right: kMargins)
    }
    
}
