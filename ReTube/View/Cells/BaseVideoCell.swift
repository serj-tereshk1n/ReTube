//
//  BaseVideoCell.swift
//  ReTube
//
//  Created by Ner√e D4mage on 18/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class BaseVideoCell: BaseCollectionViewCell {
    
    var video: STVideo? {
        didSet {
            if let video = video {
                
                ApiService.sharedInstance.statisticsForVideo(id: video.id, completion: { (statistics, contentDetails) in
                    
                    let intViews = Int32(statistics.viewCount) ?? 666
                    let localizedViews = ObjCHelper.abbreviateNumber(intViews)
                    let localizedViewsFallback = NumberFormatter.localizedString(from: NSNumber(value: intViews), number: NumberFormatter.Style.decimal)
                    let durationString = contentDetails.duration.getYoutubeFormattedDuration()
                    let estimatedRect = self.sizeFor(text: durationString,
                                                     font: self.durationLabel.font,
                                                     size: CGSize(width: 100000, height: 100))
                    self.durationLabel.text = durationString
                    self.durationLabelWidthConstraint?.constant = estimatedRect.width + 8
                    self.durationLabelHeightConstraint?.constant = estimatedRect.height + 4
                    
                    var subTitle = "\(localizedViews ?? localizedViewsFallback) views"
                    if let date = self.timeAgoStringFromDate(dateStr: video.publishedAt) {
                        subTitle.append(" • \(date)")
                    }
                    
                    self.subtitleTextView.text = subTitle
                })
                
                thumbnailImageView.sd_setImage(with: URL(string: video.thumbnailHigh), placeholderImage: nil)
                titleLabel.text = video.title
                
                let height = video.title.height(withConstrainedWidth: titleLabelWidth ?? frame.width, font: titleLabel.font)
                let lineHeight = ceil(titleLabel.font.lineHeight)
                if height > lineHeight {
                    titleLabelHeightConstraint?.constant = lineHeight * 2
                } else {
                    titleLabelHeightConstraint?.constant = lineHeight
                }
            }
        }
    }
    
    var durationLabelWidthConstraint: NSLayoutConstraint?
    var durationLabelHeightConstraint: NSLayoutConstraint?
    var titleLabelHeightConstraint: NSLayoutConstraint?
    var titleLabelWidth: CGFloat?
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 2
        imageView.image = #imageLiteral(resourceName: "academeg_plagiat_thumbnail")
        return imageView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = ""
        return label
    }()
    let durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = ""
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 2
        label.textColor = .subtitle
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return label
    }()
    let subtitleTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 13)
        tv.text = ""
        tv.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        tv.textColor = .subtitle
        tv.backgroundColor = .darkBackground
        tv.isEditable = false
        tv.isSelectable = false
        tv.isScrollEnabled = false
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    private func sizeFor(text: String, font: UIFont, size: CGSize) -> CGSize {
        //measure title text
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedRect = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: font], context: nil)
        return estimatedRect.size
    }
    
    func addCommonViews() {
        addSubview(thumbnailImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        thumbnailImageView.addSubview(durationLabel)
    }
    
    func addCommonConstraints() {
        thumbnailImageView.addConstraintsWithFormat(format: "H:[v0]-4-|", views: durationLabel)
        thumbnailImageView.addConstraintsWithFormat(format: "V:[v0]-4-|", views: durationLabel)
        titleLabelHeightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: 20)
        durationLabelWidthConstraint = durationLabel.widthAnchor.constraint(equalToConstant: 0)
        durationLabelHeightConstraint = durationLabel.heightAnchor.constraint(equalToConstant: 0)
        titleLabelHeightConstraint?.isActive = true
        durationLabelWidthConstraint?.isActive = true
        durationLabelHeightConstraint?.isActive = true
        thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 9 / 16).isActive = true

    }
    
    func setupSquareCellViews() {
        addCommonViews()
        addCommonConstraints()
        
        // H constraints
        for (_, view) in [thumbnailImageView, titleLabel, subtitleTextView].enumerated() {
            addConstraintsWithFormat(format: "H:|[v0]|", views: view)
        }
        // V constraints
        addConstraintsWithFormat(format: "V:|[v0]-8-[v1]", views: thumbnailImageView, titleLabel)
        addConstraintsWithFormat(format: "V:[v0]-4-[v1]-4-|", views: titleLabel, subtitleTextView)
    }
    
    func setupHorizontalCellView() {
        addCommonViews()
        addCommonConstraints()
        titleLabelWidth = frame.width - ((frame.height * (16 / 9)) + 16)
        addConstraintsWithFormat(format: "H:|[v0]-8-[v1]-8-|", views: thumbnailImageView, titleLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: thumbnailImageView)
        addConstraintsWithFormat(format: "V:|[v0]-4-[v1]|", views: titleLabel, subtitleTextView)
        subtitleTextView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        subtitleTextView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
    }
    
    // MARK Utils
    
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
}
