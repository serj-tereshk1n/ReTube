//
//  MinimizedPlayerView.swift
//  ReTube
//
//  Created by sergey.tereshkin on 05/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class MinimizedPlayerView: UIView, YTPlayerViewDelegate {

//    let player = YTPlayerView()
    let player = UIView()
    
    var launcher: VideoLauncher?
    
    let pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ic_pause"), for: .normal)
        button.tintColor = .white
//        button.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ic_close"), for: .normal)
        button.tintColor = .white
        //        button.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        return button
    }()
    
    let placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayerView()
    }
    
    func setupPlayerView() {
        
        addSubview(player)
        addSubview(closeButton)
        addSubview(pausePlayButton)
        
        player.addSubview(placeholderImageView)
        
        addFullScreenConstraintsFor(views: placeholderImageView, inside: player)
        
        addConstraintsWithFormat(format: "H:|[v0(128)]", views: player)
        addConstraintsWithFormat(format: "V:|[v0]|", views: player)
        addConstraintsWithFormat(format: "H:[v0(50)]-8-[v1(50)]-8-|", views: pausePlayButton, closeButton)
        addConstraintsWithFormat(format: "V:|[v0]|", views: pausePlayButton)
        addConstraintsWithFormat(format: "V:|[v0]|", views: closeButton)
        
        player.backgroundColor = .green
    }
    
    func addPlayerView(playerView: UIView) {
        player.addSubview(playerView)
        addFullScreenConstraintsFor(views: playerView, inside: player)
    }
    
    // MARK - YTPlayerViewDelegate
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        print("minimized did become active")
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .playing:
            pausePlayButton.setImage(#imageLiteral(resourceName: "ic_pause"), for: .normal)
            break;
        case .paused:
            pausePlayButton.setImage(#imageLiteral(resourceName: "ic_play_arrow"), for: .normal)
            break;
        case .unstarted:
            // todo
            break;
        case .ended:
            pausePlayButton.setImage(#imageLiteral(resourceName: "ic_replay"), for: .normal)
            break;
        default:
            print("default")
        }
    }
    
//    func playerViewPreferredInitialLoading(_ playerView: YTPlayerView) -> UIView? {
//        return activityIndicatorView
//    }
    
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return .black
    }
    
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
//        videoCurrentTimeLabel.text = timeStringFromSeconds(seconds: Int(playTime))
//        seekSlider.setValue(playTime, animated: true)
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        // todo
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
