//
//  PlaylistItemCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 12/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class PlaylistVideoCell: BaseCollectionViewCell {

    var video: STVideo? {
        didSet {
            if let v = video {
                thumbImageView.sd_setImage(with: URL(string: v.thumbnails.medium.url),
                                          placeholderImage: UIImage(named: "placeholder.png"))
                titleTextView.text = v.title
//                indexLabel.text = String(describing: v.position)
            }
        }
    }
    
    var isCurrentVideo: Bool? {
        didSet {
            if let current = isCurrentVideo {
                backgroundColor = current ? .mLightGray : .mDarkGray
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .mLightGray : .mDarkGray
        }
    }
    
//    let indexLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .gray
//        label.font = UIFont.systemFont(ofSize: 13)
//        label.textAlignment = .center
//        return label
//    }()
//    let currentVideoIndicator: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = #imageLiteral(resourceName: "ic_play_arrow").withRenderingMode(.alwaysTemplate)
//        imageView.contentMode = .scaleAspectFit
//        imageView.isHidden = true
//        imageView.tintColor = .gray
//        return imageView
//    }()
    let thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "thumbnail_dislike")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "PaySend — международные онлайн-переводы с карты на карту с фикс."
        tv.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .white
        tv.backgroundColor = .clear
        tv.isEditable = false
        tv.isSelectable = false
        tv.isScrollEnabled = false
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    override func setupViews() {
//        addSubview(indexLabel)
        addSubview(thumbImageView)
        addSubview(titleTextView)
//        addSubview(currentVideoIndicator)
        
//        addConstraintsWithFormat(format: "H:|[v0(25)]-8-[v1]-8-[v2]-8-|", views: indexLabel, thumbImageView, titleTextView)
        addConstraintsWithFormat(format: "H:|[v0]-8-[v1]-8-|", views: thumbImageView, titleTextView)
//        addConstraintsWithFormat(format: "V:|[v0]|", views: indexLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: thumbImageView)
        addConstraintsWithFormat(format: "V:|-8-[v0]-8-|", views: titleTextView)
        
        NSLayoutConstraint.activate([
            thumbImageView.widthAnchor.constraint(equalTo: thumbImageView.heightAnchor, multiplier: 16 / 9)
//            ,
//            currentVideoIndicator.widthAnchor.constraint(equalTo: indexLabel.widthAnchor),
//            currentVideoIndicator.heightAnchor.constraint(equalTo: indexLabel.heightAnchor),
//            currentVideoIndicator.centerXAnchor.constraint(equalTo: indexLabel.centerXAnchor),
//            currentVideoIndicator.centerYAnchor.constraint(equalTo: indexLabel.centerYAnchor)
            ])
    }
}
