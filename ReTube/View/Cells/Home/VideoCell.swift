//
//  VideoCVCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 09/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class VideoCell: BaseVideoCell {
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightBackground
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        setupSquareCellViews()
        
        addSubview(separatorView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: separatorView)
    }
}
