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
        super.registerCells()
        
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kSectionHeaderId)
        collectionView.register(PlaylistCell.self, forCellWithReuseIdentifier: kPlaylistCellId)
    }
    
    override func heightForFooterIn(section: Int) -> CGFloat {
        if playLists.count > 0 && nextPageToken == nil { return 0 }
        return kFooterHeight
    }
    
    override func numberOfSections() -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playLists.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        shouldRequestNextPage(index: indexPath.row, count: playLists.count)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPlaylistCellId, for: indexPath) as! PlaylistCell
        cell.playList = playLists[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let isIpad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
        
        let width = (frame.width - kMargin * 3) / 2
        let ipadWidth = (frame.width - kMargin * 4) / 3
        let ratioIndex: CGFloat = 9 / 16
        let height = isIpad ? ipadWidth * ratioIndex : width * ratioIndex
        let supplementaryHeight: CGFloat = 60
        
        return CGSize(width: isIpad ? ipadWidth : width, height: height + supplementaryHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kMargin
    }
    
    override func titleForHeaderIn(section: Int) -> String {
        return "Official Playlists"
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        VideoLauncher.sharedInstance.showVideoPlayer()
        VideoLauncher.sharedInstance.loadPlayList(list: playLists[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin)
    }
}
