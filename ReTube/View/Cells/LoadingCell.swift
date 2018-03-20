//
//  LoadingCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 20/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class LoadingCell: UICollectionReusableView {

    let activityIndicatorView: UIView = {
        let container = UIView()
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.color = .selected
        container.backgroundColor = .lightBackground
        container.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        indicator.startAnimating()
        return container
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkBackground
        addSubview(activityIndicatorView)
        addFullScreenConstraintsFor(views: activityIndicatorView, inside: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
