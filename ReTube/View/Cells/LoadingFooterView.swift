//
//  LoadingCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 20/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class LoadingFooterView: UICollectionReusableView {

    let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.color = .selected
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkBackground
        addSubview(activityIndicatorView)
        addFullScreenConstraintsFor(views: activityIndicatorView, inside: self)
    }

    func startAnimating() {
        activityIndicatorView.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
