//
//  PlaylistCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 09/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class PlaylistCell: BaseCollectionViewCell {
    
    var playList: YTPlayList? {
        didSet {
            if let thumbUrl = playList?.snippet.thumbnails.medium.url {
                thumbnailImage.sd_setImage(with: URL(string: thumbUrl),
                                           placeholderImage: UIImage(named: "placeholder.png"))
            }
            titleTextView.text = playList?.snippet.title
            counterLabel.text = "\(playList?.contentDetails?.itemCount ?? 0)"
        }
    }
    
    let thumbnailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "zil_thumbnail")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 2
        return imageView
    }()
    
    let titleTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.text = "Зачем покупать корейца, если есть Geely Atlas ??"
        tv.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        tv.textColor = .white
        tv.backgroundColor = .darkBackground
        tv.isEditable = false
        tv.isSelectable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    let counterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkBackground.withAlphaComponent(0.8)
        return view
    }()
    
    let counterIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "ic_playlist_play")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let counterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let counterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(thumbnailImage)
        addSubview(titleTextView)
        thumbnailImage.addSubview(counterView)
        counterView.addSubview(counterStackView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: thumbnailImage)
        addConstraintsWithFormat(format: "H:|[v0]|", views: titleTextView)
        
        thumbnailImage.addConstraintsWithFormat(format: "V:|[v0]|", views: counterView)
        thumbnailImage.addConstraintsWithFormat(format: "H:[v0]|", views: counterView)
        
        addConstraintsWithFormat(format: "V:|[v0]-4-[v1]|", views: thumbnailImage, titleTextView)
        
        counterStackView.addArrangedSubview(counterLabel)
        counterStackView.addArrangedSubview(counterIcon)
        
        NSLayoutConstraint.activate([
            
            counterView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 2.2),
            thumbnailImage.heightAnchor.constraint(equalTo: thumbnailImage.widthAnchor, multiplier: 9 / 16),
            counterStackView.centerXAnchor.constraint(equalTo: counterView.centerXAnchor),
            counterStackView.centerYAnchor.constraint(equalTo: counterView.centerYAnchor),
            counterStackView.widthAnchor.constraint(equalTo: counterView.widthAnchor, multiplier: 1),
            counterStackView.heightAnchor.constraint(equalTo: counterView.heightAnchor, multiplier: 0.5)
            
            ])

    }
}
