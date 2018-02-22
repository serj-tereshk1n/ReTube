//
//  ViewController.swift
//  ReTube
//
//  Created by sergey.tereshkin on 19/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var videos: [VideoTemp] = {
        var channel = ChannelTemp()
        channel.name = "AcademeG"
        channel.profileImageName = "academeg_image"
        
        var plagiatVideo = VideoTemp()
        plagiatVideo.thumbnailImageName = "academeg_plagiat_thumbnail"
        plagiatVideo.title = "Плагиат против ВАЗ 375 сил и выезд из 5 секунд."
        plagiatVideo.channel = channel
        plagiatVideo.numberOfViews = 12341344
        
        var zilVideo = VideoTemp()
        zilVideo.thumbnailImageName = "zil_thumbnail"
        zilVideo.title = "ВАЛЯЩИЙ ЗИЛ 130"
        zilVideo.channel = channel
        zilVideo.numberOfViews = 234243434
        
        var dislikeVideo = VideoTemp()
        dislikeVideo.thumbnailImageName = "thumbnail_dislike"
        dislikeVideo.title = "Дизлайк"
        dislikeVideo.channel = channel
        dislikeVideo.numberOfViews = 345352344
        
        return [plagiatVideo, zilVideo, dislikeVideo]
    }()

    let kCellId = "homeCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        collectionView?.backgroundColor = .white
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: kCellId)
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        setupMenuBar()
        setupNavBarButtons()
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]", views: menuBar)
    }
    
    private func setupNavBarButtons() {
        let searchImage = UIImage(named: "ic_search")?.withRenderingMode(.alwaysOriginal)
        let moreVerticalImage = UIImage(named: "ic_more_vertical")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let moreBarButtonItem = UIBarButtonItem(image: moreVerticalImage, style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
    }
    
    @objc private func handleSearch() {
        
    }
    
    @objc private func handleMore() {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! VideoCell
        cell.video = videos[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = (width - 32) * 9 / 16
        return CGSize(width: width, height: height + 104)
    }
}


