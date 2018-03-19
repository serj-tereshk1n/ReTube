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

class PlaylistView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, InfoVideoHeaderDelegate {
    
    func didPressButtonWithAction(type: ActionType) {
        switch type {
        case .share:
            break;
        case .shuffle:
            break;
        case .like:
            if let liked = currentVideo {
                if STLikedHelper.shared.isLiked(video: liked) {
                    STLikedHelper.shared.remove(video: liked)
                } else {
                    STLikedHelper.shared.add(video: liked)
                }
            }
            print("Like button pressed")
            break;
        case .repeet:
            break;
        }
    }
    
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
            if  /* let video = */ video != nil {
                playlist = nil
                clearDataSource()
//                videos.append(video)
//                collectionView(self.collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
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
//            listName.text = list.snippet.title
            ApiService.sharedInstance.playListItemsNextPage(id: list.id, nextPageToken: nextPageToken, completion: { (response) in
                self.manageResponse(response: response)
            })
        }
    }
    
    @objc func fetchRelatedVideos() {
        
//        if let video = video {
//            listName.text = "Related videos"
//            ApiService.sharedInstance.relatedVideosTo(videoId: video.id, nextPageToken: nextPageToken, order: .rating, completion: { (response) in
//                self.manageResponse(response: response)
//            })
//        }
        
        if let video = video {
//            listName.text = "Next videos"
            ApiService.sharedInstance.searchPublishedBefore(before: video.publishedAt, nextPageToken: nextPageToken, order: .date, completion: { (response) in
                self.manageResponse(response: response)
            })
        }
    }
    
    func manageResponse(response: STResponse) {
        self.nextPageToken = response.nextPageToken
        self.videos.append(contentsOf: response.items)
        self.collectionView.reloadData()
        
        self.delegate?.videosCount(count: self.videos.count)
        
        // if first page, start playing first video
        if (response.items.count > 0 && self.videos.count == response.items.count) {
            self.collectionView(self.collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
            self.collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
        }
    }
    
    let kInfoVideoHeaderId = "kInfoVideoHeaderId"
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupCollectionView()
    }
    
    func setupViews() {

        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
    }
    
    func playNextVideo() {
        
        if let indexPath = currentIndexPath {
            
//            if shuffleBtn.alpha == 1 {
//                // todo random indexPath
//            }
//
//            if repeatBtn.alpha == 1 {
//                // todo repeat after finished playing
//            }
            
            let nextIndexPath = IndexPath(row: indexPath.row + 1, section: 0)
            if videos.count > nextIndexPath.row {
                collectionView.selectItem(at: nextIndexPath, animated: true, scrollPosition: .centeredVertically)
                collectionView(collectionView, didSelectItemAt: nextIndexPath)
            }
        }
    }
    
    func setupCollectionView() {
        collectionView.register(InfoVideoHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kInfoVideoHeaderId)
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
        return CGSize(width: frame.width - kMargins * 2, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vdo = videos[indexPath.row]
        
        let cell = collectionView.cellForItem(at: indexPath) as? PlaylistVideoCell ?? PlaylistVideoCell()
        headerView?.title.text = cell.titleLabel.text
        headerView?.viewsCounter.text = cell.subtitleTextView.text
        headerView?.likeBtn.alpha = STLikedHelper.shared.isLiked(video: vdo) ? 1 : 0.5
        
        currentVideo = vdo
        delegate?.didSelectVideoWith(id: vdo.id)
        delegate?.currentVideoIndex(index: indexPath.row)
        currentIndexPath = indexPath
    }
    
    var headerView: InfoVideoHeader?
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kInfoVideoHeaderId, for: indexPath) as? InfoVideoHeader ?? InfoVideoHeader()
        headerView?.mDelegate = self
        return headerView!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kMargins
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: kMargins, left: kMargins, bottom: kMargins, right: kMargins)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
