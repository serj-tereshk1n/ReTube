//
//  PlaylistItemCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 12/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class PlaylistVideoCell: BaseVideoCell {

    var isCurrentVideo: Bool? {
        didSet {
            if let current = isCurrentVideo {
                currentVideoIndicator.backgroundColor = current ? .ytRed : .mDarkGray
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            currentVideoIndicator.backgroundColor = isSelected ? .ytRed : .mDarkGray
        }
    }
    
    let currentVideoIndicator: UIView = {
        let view = UIView()
        return view
    }()

    override func setupViews() {
        setupHorizontalCellView()
        
        addSubview(currentVideoIndicator)
        
        addConstraintsWithFormat(format: "H:[v0(4)]|", views: currentVideoIndicator)
        addConstraintsWithFormat(format: "V:|[v0]|", views: currentVideoIndicator)
        
        backgroundColor = .mDarkGray
        titleLabel.textColor = .white
        durationLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.backgroundColor = .mDarkGray
        subtitleTextView.backgroundColor = .mDarkGray
    }
}
