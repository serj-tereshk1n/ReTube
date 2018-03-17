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
        
        let buttonSize = 35
        
        addConstraintsWithFormat(format: "H:|[v0]", views: playerContainer)
        addConstraintsWithFormat(format: "V:|[v0]|", views: playerContainer)
        addConstraintsWithFormat(format: "H:[v0(\(buttonSize))]-16-[v1(\(buttonSize))]-16-|", views: pausePlayButton, closeButton)
        addConstraintsWithFormat(format: "V:[v0(\(buttonSize))]", views: pausePlayButton)
        addConstraintsWithFormat(format: "V:[v0(\(buttonSize))]", views: closeButton)
        
        NSLayoutConstraint.activate([
            pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            closeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playerContainer.widthAnchor.constraint(equalTo: playerContainer.heightAnchor, multiplier: 16 / 9)
            ])
        
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
