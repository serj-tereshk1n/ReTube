//
//  SettingCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 23/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class SettingCell: BaseCollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet{
            backgroundColor = isHighlighted ? .lightBackground : .darkBackground
            nameLabel.textColor = isHighlighted ? .selected : .deselected
            iconImageView.tintColor = isHighlighted ? .selected : .deselected
        }
    }
    
    var setting: Setting? {
        didSet {
            nameLabel.text = setting?.name
            iconImageView.image = UIImage(named: setting?.imageName ?? "")?.withRenderingMode(.alwaysTemplate)
            iconImageView.tintColor = .deselected
        }
    }
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_settings")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.textColor = .deselected
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(iconImageView)
        addSubview(nameLabel)
        
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]-8-[v1]|", views:iconImageView, nameLabel)
        
        addConstraintsWithFormat(format: "V:[v0(30)]", views: iconImageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
