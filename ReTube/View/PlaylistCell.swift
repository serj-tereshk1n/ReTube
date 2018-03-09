//
//  PlaylistCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 09/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class PlaylistCell: BaseCollectionViewCell {
    
    let thumbnailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "zil_thumbnail")
        return imageView
    }()
    
    let titleTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.text = "Зачем покупать корейца, если есть Geely Atlas ??"
        tv.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        tv.textColor = .black
        tv.backgroundColor = .clear
        tv.isEditable = false
        tv.isSelectable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    let counterBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
//        backgroundColor = UIColor.rgb(red: 25, green: 25, blue: 25)
        
        addSubview(thumbnailImage)
        addSubview(titleTextView)
        thumbnailImage.addSubview(counterBackgroundView)
        
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: thumbnailImage)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: titleTextView)
        
        thumbnailImage.addConstraintsWithFormat(format: "V:|[v0]|", views: counterBackgroundView)
        thumbnailImage.addConstraintsWithFormat(format: "H:[v0]|", views: counterBackgroundView)
        
        addConstraintsWithFormat(format: "V:|-4-[v0]-4-[v1]-4-|", views: thumbnailImage, titleTextView)
        
        NSLayoutConstraint.activate([
            
            counterBackgroundView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 2.2),
            thumbnailImage.heightAnchor.constraint(equalTo: thumbnailImage.widthAnchor, multiplier: 9 / 16)
            
            ])

    }
}
