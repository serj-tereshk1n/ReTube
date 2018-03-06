//
//  MinimizedPlayerView.swift
//  ReTube
//
//  Created by sergey.tereshkin on 05/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class MinimizedPlayerView: UIView, YTPlayerViewDelegate {

    let player = YTPlayerView()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayerView()
    }
    
    func setupPlayerView() {
        
        addSubview(player)
        addSubview(closeButton)
        addSubview(pausePlayButton)
        
        addConstraintsWithFormat(format: "H:|[v0(128)]", views: player)
        addConstraintsWithFormat(format: "V:|[v0]|", views: player)
        addConstraintsWithFormat(format: "H:[v0(50)]-8-[v1(50)]-8-|", views: pausePlayButton, closeButton)
        addConstraintsWithFormat(format: "V:|[v0]|", views: pausePlayButton)
        addConstraintsWithFormat(format: "V:|[v0]|", views: closeButton)
        
        player.backgroundColor = .green
        
        player.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
