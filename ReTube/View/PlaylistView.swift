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
    
    weak var delegate: PlaylistViewDelegate?
    
    let kPlayListItemCellId = "kPlayListItemCellId"
    let kMargins: CGFloat = 8
    let kHeaderViewHeight: CGFloat = 110
    
    var shuffledVideos = [STVideo]()
    var videos = [STVideo]()
    var currentVideo: STVideo?
    var shuffle: Bool = false
    var repeet: Bool = false
    var currentIndexPath: IndexPath?
    var nextPageToken: String?
    var lastContentOffset: CGFloat?
    var headerTopAncorConstraint: NSLayoutConstraint?
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
                infoVideoHeader.repeatBtn.isEnabled = true
                clearDataSource()
                fetchSelector = #selector(fetchPlaylistVideos)
            }
        }
    }
    var video: STVideo? {
        didSet {
            if  /* let video = */ video != nil {
                playlist = nil
                infoVideoHeader.repeatBtn.isEnabled = false
                clearDataSource()
                fetchSelector = #selector(fetchRelatedVideos)
            }
        }
    }
    
    func clearDataSource() {
        infoVideoHeader.shuffleBtn.alpha = 0.5
        shuffle = false
        
        infoVideoHeader.repeatBtn.alpha = 0.5
        repeet = false
        
        nextPageToken = nil
        shuffledVideos = [STVideo]()
        videos = [STVideo]()
    }
    
    @objc func fetchPlaylistVideos() {
        if let list = playlist {
            infoVideoHeader.viewsCounter.text = list.snippet.title
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
            infoVideoHeader.viewsCounter.text = "Next videos"
            ApiService.sharedInstance.searchPublishedBefore(before: video.publishedAt, nextPageToken: nextPageToken, order: .date, completion: { (response) in
                self.manageResponse(response: response)
            })
        }
    }
    
    func didPressButtonWithAction(type: ActionType, isOn: Bool) {
        switch type {
        case .share:
            // todo
            //
            break;
        case .shuffle:
            shuffle = isOn
            shuffledVideos.shuffle()
            collectionView.reloadData()
            selectItemAt(indexPath: IndexPath(row: 0, section: 0))
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
            repeet = isOn
            break;
        }
    }
    
    func selectItemAt(indexPath: IndexPath) {
        if videos.count > indexPath.row && shuffledVideos.count > indexPath.row {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
            collectionView(collectionView, didSelectItemAt: indexPath)
        }
    }
    
    func manageResponse(response: STResponse) {
        self.nextPageToken = response.nextPageToken
        self.videos.append(contentsOf: response.items)
        self.shuffledVideos.append(contentsOf: response.items.shuffled())
        self.collectionView.reloadData()
        
        self.delegate?.videosCount(count: self.videos.count)
        
        // if first page, start playing first video
        if (response.items.count > 0 && self.videos.count == response.items.count) {
            self.selectItemAt(indexPath: IndexPath(row: 0, section: 0))
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .darkBackground
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    lazy var infoVideoHeader: InfoVideoHeader = {
        let header = InfoVideoHeader()
        header.mDelegate = self
        return header
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupCollectionView()
    }
    
    func setupViews() {

        addSubview(collectionView)
        addSubview(infoVideoHeader)
        addConstraintsWithFormat(format: "H:|[v0]|", views: infoVideoHeader)
        addConstraintsWithFormat(format: "V:[v0(\(Int(kHeaderViewHeight)))]", views: infoVideoHeader)
        headerTopAncorConstraint = infoVideoHeader.topAnchor.constraint(equalTo: self.topAnchor)
        headerTopAncorConstraint?.isActive = true
        addFullScreenConstraintsFor(views: collectionView, inside: self)
        collectionView.contentInset = UIEdgeInsets(top: kHeaderViewHeight, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: kHeaderViewHeight, left: 0, bottom: 0, right: 0)
        collectionView.bounces = false
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let headerTopAncorConstraint = headerTopAncorConstraint {
            let yOffset = scrollView.contentOffset.y
            if let lastContentOffset = lastContentOffset {
                var value = headerTopAncorConstraint.constant - (yOffset - lastContentOffset)
                if lastContentOffset > yOffset {
                    if value > 0 {
                        value = 0
                    }
                } else if lastContentOffset < yOffset {
                    if value < kHeaderViewHeight * -1 {
                        value = kHeaderViewHeight * -1
                    }
                }
                headerTopAncorConstraint.constant = value
            }
            lastContentOffset = yOffset
        }
    }
    
    func playNextVideo() {
        if let indexPath = currentIndexPath {
            let nextIndexPath = IndexPath(row: indexPath.row + 1, section: 0)
            if videos.count > nextIndexPath.row {
                selectItemAt(indexPath: nextIndexPath)
            } else if (repeet) {
                selectItemAt(indexPath: IndexPath(row: 0, section: 0))
            }
        }
    }
    
    func setupCollectionView() {
        collectionView.register(PlaylistVideoCell.self, forCellWithReuseIdentifier: kPlayListItemCellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shuffle ? shuffledVideos.count : videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPlayListItemCellId, for: indexPath) as! PlaylistVideoCell
        
        cell.video = shuffle ? shuffledVideos[indexPath.row] : videos[indexPath.row]
        
        if let currentId = currentVideo?.id {
            cell.isCurrentVideo = currentId == videos[indexPath.row].id
        } else {
            cell.isCurrentVideo = false
        }
        
        if indexPath.row == (shuffle ? shuffledVideos.count - 3 : videos.count - 3) && nextPageToken != nil {
            // request next page
            if let selector = fetchSelector {
                performSelector(onMainThread: selector, with: nil, waitUntilDone: false)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            // three columns for ipad ui
            return CGSize(width: (collectionView.frame.size.width - kMargins * 3) / 2, height: 100)
        } else {
            return CGSize(width: frame.width - kMargins * 2, height: 70)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vdo = shuffle ? shuffledVideos[indexPath.row] : videos[indexPath.row]
        
        // update header info
        infoVideoHeader.title.text = vdo.title
        infoVideoHeader.likeBtn.alpha = STLikedHelper.shared.isLiked(video: vdo) ? 1 : 0.5
        
        // save current player state
        currentVideo = vdo
        currentIndexPath = indexPath
        
        // inform delegate of the state
        delegate?.didSelectVideoWith(id: vdo.id)
        delegate?.currentVideoIndex(index: indexPath.row)
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
