//
//  VideoLauncher.swift
//  ReTube
//
//  Created by sergey.tereshkin on 28/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ic_pause"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        return button
    }()
    
    var isPlaying = false
    
    @objc func handlePlayPause() {
        
        if isPlaying {
            player?.pause()
            pausePlayButton.setImage(#imageLiteral(resourceName: "ic_play_arrow"), for: .normal)
        } else {
            player?.play()
            pausePlayButton.setImage(#imageLiteral(resourceName: "ic_pause"), for: .normal)
        }
        
        isPlaying = !isPlaying
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        controlsContainerView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addSubview(controlsContainerView)
        controlsContainerView.addSubview(activityIndicatorView)
        controlsContainerView.addSubview(pausePlayButton)
        
        setupPlayerView()
        
        NSLayoutConstraint.activate([
            controlsContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            controlsContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor),
            pausePlayButton.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor),
            pausePlayButton.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor),
            pausePlayButton.widthAnchor.constraint(equalToConstant: 70),
            pausePlayButton.heightAnchor.constraint(equalToConstant: 70)
            ])
    }
    
    var player: AVPlayer?
    
    func setupPlayerView() {
        
        let urlString = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"
        
        backgroundColor = .black
        if let url = NSURL(string: urlString) {
            player = AVPlayer(url: url as URL)
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = controlsContainerView.frame
            player?.play()
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            isPlaying = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoLauncher: NSObject {
    
    static let sharedInstance = VideoLauncher()
    
    let kMinimizedPlayerHeight: CGFloat = 75
    let kMinimizedPlayerMargin: CGFloat = 20
    
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return view
    }()
    
    let minimizedVideoPlayer: UIView = {
        let mplayer = UIView()
        mplayer.backgroundColor = .green
        //        mplayer.isHidden = true
        mplayer.isUserInteractionEnabled = true
        return mplayer
    }()
    
    let keyWindow: UIWindow = {
        return UIApplication.shared.keyWindow ?? UIWindow()
    }()
    
    let isVisible: Bool = false
    
    override init() {
        super.init()
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            let minimizedPlayerOffset = kMinimizedPlayerHeight + kMinimizedPlayerMargin
            
            mainView.frame = CGRect(x: 0,
                                    y: keyWindow.frame.height + minimizedPlayerOffset,
                                    width: keyWindow.frame.width,
                                    height: keyWindow.frame.height + minimizedPlayerOffset)
            
            let playerHeight = keyWindow.frame.width * 9 / 16
            let videoPlayerView = VideoPlayerView(frame: CGRect(x: 0,
                                                                y: minimizedPlayerOffset,
                                                                width: keyWindow.frame.width,
                                                                height: playerHeight))
            
            minimizedVideoPlayer.frame = CGRect(x: kMinimizedPlayerMargin,
                                                y: 0,
                                                width: mainView.frame.width - (kMinimizedPlayerMargin * 2),
                                                height: kMinimizedPlayerHeight)
            
            mainView.addSubview(videoPlayerView)
            mainView.addSubview(minimizedVideoPlayer)
            keyWindow.addSubview(mainView)
            
            let mainViewGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            let minimizedPlayerGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            
            videoPlayerView.addGestureRecognizer(mainViewGestureRecognizer)
            minimizedVideoPlayer.addGestureRecognizer(minimizedPlayerGestureRecognizer)
        }
    }
    
    func showVideoPlayer() {
        
        let minimizedPlayerOffset = kMinimizedPlayerHeight + kMinimizedPlayerMargin
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.mainView.frame = CGRect(x: 0,
                                         y: -minimizedPlayerOffset,
                                         width: self.mainView.frame.width,
                                         height: self.mainView.frame.height)
        }, completion: { (_) in
            //                UIApplication.shared.isStatusBarHidden = true
        })
    }
    
    func minimizeVideoPlayer() {
        let minimizedPlayerOffset = kMinimizedPlayerHeight + kMinimizedPlayerMargin
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.mainView.frame = CGRect(x: 0,
                                         y: self.keyWindow.frame.height - minimizedPlayerOffset,
                                         width: self.mainView.frame.width,
                                         height: self.mainView.frame.height)
        }, completion: { (_) in
            
        })
    }
    
    func hideVideoPlayer() {
        // to do
    }
    
    var globalTouchLocatino: CGPoint?
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            globalTouchLocatino = gestureRecognizer.location(in: keyWindow)
            
            let translation = gestureRecognizer.translation(in: mainView)
            
            let point = CGPoint(x: mainView.frame.size.width / 2, y: mainView.center.y + translation.y)
            
            gestureRecognizer.view!.superview!.center = point
            gestureRecognizer.setTranslation(CGPoint.zero, in: mainView.superview)
            
        } else if gestureRecognizer.state == .ended {
            
            if let touch = globalTouchLocatino {
                if touch.y > keyWindow.center.y {
                    minimizeVideoPlayer()
                } else if !UIApplication.shared.isStatusBarHidden {
                    showVideoPlayer()
                }
            }
        }
    }
}

