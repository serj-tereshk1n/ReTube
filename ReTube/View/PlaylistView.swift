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
    @objc func videosCount(count: Int)
    @objc func currentVideoIndex(index: Int)
}

class PlaylistView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    weak var delegate: PlaylistViewDelegate?
    
    var videos = [STVideo]()
    var currentIndexPath: IndexPath?
    var nextPageToken: String?
    var fetchSelector: Selector? {
        didSet {
            if let selector = fetchSelector {
                performSelector(onMainThread: selector, with: nil, waitUntilDone: false)
            }
        }
    }
    var playlist: YTPlayList? {
        didSet {
            if  playlist != nil {
                video = nil
                clearDataSource()
                fetchSelector = #selector(fetchPlaylistVideos)
            }
        }
    }
    var video: STVideo? {
        didSet {
            if  let video = video {
                playlist = nil
                clearDataSource()
                videos.append(video)
                collectionView(self.collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
                fetchSelector = #selector(fetchRelatedVideos)
            }
        }
    }
    
    func clearDataSource() {
        nextPageToken = nil
        videos = [STVideo]()
    }
    
    @objc func fetchPlaylistVideos() {
        if let list = playlist {
            listName.text = list.snippet.title
            ApiService.sharedInstance.playListItemsNextPage(id: list.id, nextPageToken: nextPageToken, completion: { (response) in
                self.manageResponse(response: response)
                // if first page, start playing first video
                if (response.items.count > 0 && self.videos.count == response.items.count) {
                    self.collectionView(self.collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
                }
            })
        }
    }
    
    @objc func fetchRelatedVideos() {
        if let video = video {
            listName.text = "Related videos"
            ApiService.sharedInstance.relatedVideosTo(videoId: video.id, nextPageToken: nextPageToken, order: .rating, completion: { (response) in
                self.manageResponse(response: response)
            })
        }
    }
    
    func manageResponse(response: STResponse) {
        self.nextPageToken = response.nextPageToken
        self.videos.append(contentsOf: response.items)
        self.collectionView.reloadData()
        
        self.delegate?.videosCount(count: self.videos.count)
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
    
    func playNextVideo() {
        if let indexPath = currentIndexPath {
            let nextIndexPath = IndexPath(row: indexPath.row + 1, section: 0)
            if videos.count > nextIndexPath.row {
                collectionView.selectItem(at: nextIndexPath, animated: true, scrollPosition: .centeredVertically)
                collectionView(collectionView, didSelectItemAt: nextIndexPath)
            }
        }
    }
    
    func setupCollectionView() {
        collectionView.register(PlaylistVideoCell.self, forCellWithReuseIdentifier: kPlayListItemCellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    var currentVideo: STVideo?
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPlayListItemCellId, for: indexPath) as! PlaylistVideoCell
        cell.video = videos[indexPath.row]
        
        if let currentId = currentVideo?.id {
            cell.isCurrentVideo = currentId == videos[indexPath.row].id
        } else {
            cell.isCurrentVideo = false
        }
        
        if indexPath.row == videos.count - 3 && nextPageToken != nil {
            // request next page
            if let selector = fetchSelector {
                performSelector(onMainThread: selector, with: nil, waitUntilDone: false)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width - kMargins, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vdo = videos[indexPath.row]
        currentVideo = vdo
        title.text = vdo.title
        delegate?.didSelectVideoWith(id: vdo.id)
        delegate?.currentVideoIndex(index: indexPath.row)
        currentIndexPath = indexPath
//        collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
