//
//  MinimizedPlayerView.swift
//  ReTube
//
//  Created by sergey.tereshkin on 05/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class MinimizedPlayerView: UIView {

    let playerContainer = UIView()
    
    let pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ic_pause"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ic_close"), for: .normal)
        button.tintColor = .white
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
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(blurEffectView)
        addSubview(playerContainer)
        addSubview(closeButton)
        addSubview(pausePlayButton)
        
        addFullScreenConstraintsFor(views: blurEffectView, inside: self)
        
        playerContainer.addSubview(placeholderImageView)
        
        addFullScreenConstraintsFor(views: placeholderImageView, inside: playerContainer)
        
        addConstraintsWithFormat(format: "H:|[v0(128)]", views: playerContainer)
        addConstraintsWithFormat(format: "V:|[v0]|", views: playerContainer)
        addConstraintsWithFormat(format: "H:[v0(50)]-8-[v1(50)]-8-|", views: pausePlayButton, closeButton)
        addConstraintsWithFormat(format: "V:|[v0]|", views: pausePlayButton)
        addConstraintsWithFormat(format: "V:|[v0]|", views: closeButton)
        
        playerContainer.backgroundColor = .clear
    }
    
    func inFocusWith(player: UIView) {
        playerContainer.addSubview(player)
        addFullScreenConstraintsFor(views: player, inside: playerContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
