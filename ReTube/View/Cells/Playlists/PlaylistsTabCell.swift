//
//  TrandingCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 27/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class PlaylistsTabCell: BaseTabCell {
    
    var playLists = [YTPlayList]()
    let kMargin: CGFloat = 16
    
    let kSectionHeaderId = "kSectionHeaderId"
    let kPlaylistCellId = "kPlaylistCellId"
    
    override func startingRefresh() {
        super.startingRefresh()
        playLists = [YTPlayList]()
        collectionView.reloadData()
    }
    
    override func fetchDataSource() {

        ApiService.sharedInstance.searchPlayListsNextPage(nextPageToken: nextPageToken) { (ytPlayListsResponse) in
            self.playLists.append(contentsOf: ytPlayListsResponse.items)
            self.nextPageToken = ytPlayListsResponse.nextPageToken
            self.collectionView.reloadData()
            self.refresher.endRefreshing()
        }
    }

    override func registerCells() {
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kSectionHeaderId)
        collectionView.register(PlaylistCell.self, forCellWithReuseIdentifier: kPlaylistCellId)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playLists.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPlaylistCellId, for: indexPath) as! PlaylistCell
        cell.playList = playLists[indexPath.row]
        if indexPath.row == playLists.count - 3 && nextPageToken != nil {
            // request next page
            fetchDataSource()
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let collectionViewSize = collectionView.frame.size.width - 32 - 16
        
        let isIpad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
        
        let width = frame.width / 2 - kMargin * 2
        let ipadWidth = (frame.width - kMargin * 4) / 3
        let ratioIndex: CGFloat = 9 / 16
        let height = isIpad ? ipadWidth * ratioIndex : width * ratioIndex
        let supplementaryHeight: CGFloat = 60
        
        return CGSize(width: isIpad ? ipadWidth : width, height: height + supplementaryHeight)
        
//        return CGSize(width: collectionViewSize/2, height: (collectionViewSize/2) * 0.85)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kSectionHeaderId, for: indexPath) as! SectionHeaderView
        
        header.titleLabel.text = "Official Playlists"
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 35)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        VideoLauncher.sharedInstance.showVideoPlayer()
        VideoLauncher.sharedInstance.loadPlayList(list: playLists[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin)
    }
}
