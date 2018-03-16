//
//  VideoCVCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 09/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class VideoCell: BaseCollectionViewCell {
    
    func timeAgoStringFromDate(dateStr: String) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: dateStr) {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            
            let now = Date()
            
            let calendar = NSCalendar.current
            let components1: Set<Calendar.Component> = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]
            let components = calendar.dateComponents(components1, from: date, to: now)
            
            if components.year ?? 0 > 0 {
                formatter.allowedUnits = .year
            } else if components.month ?? 0 > 0 {
                formatter.allowedUnits = .month
            } else if components.weekOfMonth ?? 0 > 0 {
                formatter.allowedUnits = .weekOfMonth
            } else if components.day ?? 0 > 0 {
                formatter.allowedUnits = .day
            } else if components.hour ?? 0 > 0 {
                formatter.allowedUnits = [.hour]
            } else if components.minute ?? 0 > 0 {
                formatter.allowedUnits = .minute
            } else {
                formatter.allowedUnits = .second
            }
            
            let formatString = NSLocalizedString("%@ ago", comment: "Used to say how much time has passed. e.g. '2 hours ago'")
            
            guard let timeString = formatter.string(for: components) else {
                return nil
            }
            return String(format: formatString, timeString)
        }
        return nil
    }
    
    var video: STVideo? {
        didSet {
            if let video = video {
                ApiService.sharedInstance.statisticsForVideo(id: video.id, completion: { (stats) in
                    
                    let intViews = Int64(stats.viewCount) ?? 666
                    let localizedViews = NumberFormatter.localizedString(from: NSNumber(value: intViews), number: NumberFormatter.Style.decimal)
                    
                    var subTitle = "\(localizedViews) views"
                    if let date = self.timeAgoStringFromDate(dateStr: video.publishedAt) {
                        subTitle.append(" • \(date)")
                    }
                    self.subtitleTextView.text = subTitle
                })
                thumbnailImageView.sd_setImage(with: URL(string: video.thumbnails.medium.url), placeholderImage: UIImage(named: "placeholder.png"))
                titleLabel.text = video.title
                
                //measure title text
                let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedRect = NSString(string: video.title).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], context: nil)
                
                if estimatedRect.size.height > 20 {
                    titleLabelHeightConstraint?.constant = 44
                } else {
                    titleLabelHeightConstraint?.constant = 20
                }
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
            addConstraintsWithFormat(format: "H:|[v0]|", views: view)
        }
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        
        // V constraints
        addConstraintsWithFormat(format: "V:|[v0]-8-[v1]", views: thumbnailImageView, titleLabel)
        addConstraintsWithFormat(format: "V:[v0]-4-[v1]-4-|", views: titleLabel, subtitleTextView)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: separatorView)
        
        titleLabelHeightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: 20)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 9 / 16),
            titleLabelHeightConstraint!
            ])
    }
}
