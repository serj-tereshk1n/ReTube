//
//  PlaylistItemCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 12/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class PlaylistItemCell: BaseCollectionViewCell {

    var video: YTPLVideo? {
        didSet {
            if let v = video {
                thumbImageView.sd_setImage(with: URL(string: v.snippet.thumbnails.medium.url),
                                          placeholderImage: UIImage(named: "placeholder.png"))
                titleTextView.text = v.snippet.title
                indexView.text = String(describing: v.snippet.position ?? 0)
            }
        }
    }
    
    let indexView: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
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
        addSubview(indexView)
        addSubview(thumbImageView)
        addSubview(titleTextView)
        
//        backgroundColor = UIColor.rgb(red: 35, green: 35, blue: 35)
        
        addConstraintsWithFormat(format: "H:|[v0(25)]-0-[v1]-8-[v2]-8-|", views: indexView, thumbImageView, titleTextView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: indexView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: thumbImageView)
        addConstraintsWithFormat(format: "V:|-8-[v0]-8-|", views: titleTextView)
        
        thumbImageView.widthAnchor.constraint(equalTo: thumbImageView.heightAnchor, multiplier: 16 / 9).isActive = true
        
    }

}
