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
                currentVideoIndicator.backgroundColor = current ? .selected : .darkBackground
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            currentVideoIndicator.backgroundColor = isSelected ? .selected : .darkBackground
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
        
        backgroundColor = .darkBackground
//        titleLabel.textColor = .white
        durationLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.font = UIFont.systemFont(ofSize: 14)
//        titleLabel.backgroundColor = .mDarkGray
//        subtitleTextView.backgroundColor = .mDarkGray
    }
}
