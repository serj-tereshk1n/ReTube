//
//  PopularCell.swift
//  CollectionViewSections
//
//  Created by sergey.tereshkin on 15/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class PopularCell: BaseCollectionViewCell {
    
    var video: STVideo? {
        didSet {
            if let video = video {
                thumb.sd_setImage(with: URL(string: video.thumbnails.medium.url),
                                  placeholderImage: UIImage(named: "placeholder.png"))
                titleTextView.text = video.title
            }
        }
    }
    
    let thumb: UIImageView = {
        let th = UIImageView()
        th.image = #imageLiteral(resourceName: "academeg_plagiat_thumbnail")
        th.contentMode = .scaleAspectFill
        th.clipsToBounds = true
        return th
    }()
    
    let titleTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "PaySend — международные онлайн-переводы с карты на карту с фикс."
        tv.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textColor = .white
        tv.backgroundColor = .clear
        tv.isEditable = false
        tv.isSelectable = false
        tv.isScrollEnabled = false
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(thumb)
        addSubview(titleTextView)
        
        backgroundColor = .mDarkGray
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: thumb)
        addConstraintsWithFormat(format: "H:|[v0]|", views: titleTextView)
        addConstraintsWithFormat(format: "V:|[v0]-4-[v1]|", views: thumb, titleTextView)
        
        thumb.heightAnchor.constraint(equalTo: thumb.widthAnchor, multiplier: 9 / 16).isActive = true
        
    }
}
