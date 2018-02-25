//
//  ViewController.swift
//  ReTube
//
//  Created by sergey.tereshkin on 19/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var videos = [VideoTemp]()
    
    let kCellId = "homeCell"
    
    private func fetchVideos() {
        let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
        let request : URLRequest = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            if (error != nil) {
                print("Ooops, errror hase occored")
                return
            } else if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    
                    for dic in json as! [[String: AnyObject]] {
                        print(dic["title"] ?? "[default value]")
                        
                        let channel = ChannelTemp()
                        channel.name = dic["channel"]!["name"] as? String
                        channel.profileImageName = dic["channel"]!["profile_image_name"] as? String
                        
                        let video = VideoTemp()
                        video.title = dic["title"] as? String
                        video.thumbnailImageName = dic["thumbnail_image_name"] as? String
                        video.numberOfViews = dic["number_of_views"] as? NSNumber
                        video.duration = dic["duration"] as? Int
                        video.channel = channel
                        
                        self.videos.append(video)
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                    
                    print(json)
                } catch let jsonError {
                    print(jsonError)
                }
                
            }
            
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchVideos()
        
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
        
        navigationController?.hidesBarsOnSwipe = true
        
        let redView = UIView()
        redView.backgroundColor = .ytRed
        
        view.addSubview(redView)
        view.addSubview(menuBar)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    private func setupNavBarButtons() {
        let searchImage = UIImage(named: "ic_search")?.withRenderingMode(.alwaysOriginal)
        let moreVerticalImage = UIImage(named: "ic_more_vertical")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let moreBarButtonItem = UIBarButtonItem(image: moreVerticalImage, style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
    }
    
    let settingsLauncher = SettingsLauncher()
    
    @objc private func handleMore() {
        //show settings
        settingsLauncher.showSettings()
//        showControllerForSettings()
    }
    
//    private func showControllerForSettings() {
//        let dummySettingsController = UIViewController()
//        navigationController?.pushViewController(dummySettingsController, animated: true)
//    }
    
    @objc private func handleSearch() {
        
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


