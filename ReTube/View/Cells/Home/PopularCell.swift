//
//  PopularCell.swift
//  CollectionViewSections
//
//  Created by sergey.tereshkin on 15/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class PopularCell: BaseVideoCell {
    
    override func setupViews() {
        super.setupViews()
        
        setupSquareCellViews()
        
        backgroundColor = .mDarkGray
        titleLabel.textColor = .white
        durationLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.backgroundColor = .mDarkGray
        subtitleTextView.backgroundColor = .mDarkGray
    }
}
