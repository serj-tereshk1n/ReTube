//
//  VideoCVCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 09/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class VideoCell: BaseCollectionViewCell {
    
    var video: YTVideo? {
        didSet {
            if let thumbUrl = video?.snippet.thumbnails.medium.url {
                thumbnailImageView.sd_setImage(with: URL(string: thumbUrl),
                                               placeholderImage: UIImage(named: "placeholder.png"))
            }
            titleLabel.text = video?.snippet.title
        }
    }
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "academeg_plagiat_thumbnail")
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.text = "Зачем покупать корейца, если есть Geely Atlas ??"
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 13)
        tv.text = "988.228 visualizzazioni • 2 giorni fa"
        tv.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        tv.textColor = .lightGray
        tv.isEditable = false
        tv.isSelectable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .ytLightGray
        return view
    }()
    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(thumbnailImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        addSubview(separatorView)
        
        // H constraints
        for (_, view) in [thumbnailImageView, titleLabel, subtitleTextView].enumerated() {
            addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: view)
        }
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        
        // V constraints
        addConstraintsWithFormat(format: "V:|-16-[v0]-8-[v1]-4-[v2]-8-[v3(1)]|", views: thumbnailImageView, titleLabel, subtitleTextView,separatorView)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: separatorView)

        // thumbnail height constraint
        thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 9 / 16).isActive = true
    }
}
