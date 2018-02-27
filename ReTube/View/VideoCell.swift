//
//  VideoCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 21/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import SDWebImage

class VideoCell: BaseCollectionViewCell {
    
    var video: VideoTemp? {
        didSet {
        
            titleLabel.text = video?.title
            
            if let channelName = video?.channel?.name, let numberOfViews = video?.numberOfViews {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                let strViews = numberFormatter.string(from: numberOfViews) ?? "0"
                let subtitleText = "\(channelName) • \(strViews) • 2 years ago"
                
                subtitleTextView.text = subtitleText
            }

            // measure title text
            if let title = video?.title {
                let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [.font: UIFont.systemFont(ofSize: 14)], context: nil)
                
                if estimatedRect.size.height > 20 {
                    titleLabelHeightConstraint?.constant = 44
                } else {
                    titleLabelHeightConstraint?.constant = 20
                }
            }
            
            if let videoThumbnail = video?.thumbnailImageName {
                thumbnailImageView.sd_setImage(with: URL(string: videoThumbnail),
                                               placeholderImage: UIImage(named: "placeholder.png"))
            }
        
            if let channelThumbnail = video?.channel?.profileImageName {
                userProfileImageView.sd_setImage(with: URL(string: channelThumbnail),
                                               placeholderImage: UIImage(named: "placeholder.png"))
            }
            
        }
    }

    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "academeg_plagiat_thumbnail")
        return imageView
    }()
    
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 22
        imageView.image = #imageLiteral(resourceName: "academeg_image")
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.text = "Плагиат против ВАЗ 375 сил и выезд из 5 секунд."
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "PaySend — международные онлайн-переводы с карты на карту с фикс."
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
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        // Horizontal constraints
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstraintsWithFormat(format: "H:|-16-[v0(44)]", views: userProfileImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        
        // Vertical constraints
        addConstraintsWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", views: thumbnailImageView, userProfileImageView, separatorView)
        
        // title label view constraints
        // top costraints
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        
        // left constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        
        // right constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        
        // height constraint
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20)
        addConstraint(titleLabelHeightConstraint!)
        
        // subtitle label view constraints
        // top costraints
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        
        // left constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        
        // right constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        
        // height constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
    }
}
