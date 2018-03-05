//
//  PlayerView.swift
//  ReTube
//
//  Created by sergey.tereshkin on 01/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit
import AVFoundation

class MainPlayerView: UIView, YTPlayerViewDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupPlayerView()
    }

    let player = YTPlayerView()
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    func setupPlayerView() {
        
//        let vars = ["playsinline": 1, "controls": 0]
        let lbl = UILabel()
        lbl.text = "I am the player :)"
        lbl.textAlignment = .center
        
        addSubview(player)
        addSubview(lbl)
        addSubview(controlsContainerView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: lbl)
        addConstraintsWithFormat(format: "V:|[v0]|", views: lbl)
        addConstraintsWithFormat(format: "H:|[v0]|", views: player)
        addConstraintsWithFormat(format: "V:|[v0]|", views: player)
        addConstraintsWithFormat(format: "H:|[v0]|", views: controlsContainerView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: controlsContainerView)
        
        controlsContainerView.alpha = 0
        controlsContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        player.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        
//        player.delegate = self
//        player.load(withVideoId: "LEcbagW4O-s", playerVars: vars)
       
    }
    
    var isControlsVisible = false
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.15, animations: {
            if self.isControlsVisible {
                self.controlsContainerView.alpha = 0
            } else {
                self.controlsContainerView.alpha = 1
            }
        }) { (_) in
            self.isControlsVisible = !self.isControlsVisible
        }
    }
    
    // MARK - YTPlayerViewDelegate
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
