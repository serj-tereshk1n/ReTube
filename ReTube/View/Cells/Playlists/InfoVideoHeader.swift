//
//  InfoVideoCell.swift
//  ReTube
//
//  Created by sergey.tereshkin on 19/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit


enum ActionType: Int {
    case shuffle; case repeet; case share; case like;
}

protocol InfoVideoHeaderDelegate: class {
    func didPressButtonWithAction(type: ActionType)

}

class InfoVideoHeader: UICollectionReusableView {
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "Temporary video title, (remember to replace)"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    let listName: UILabel = {
        let label = UILabel()
        label.text = "Playlist name here"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    let viewsCounter: UILabel = {
        let label = UILabel()
        label.text = "1M Views"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    let shuffleBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "ic_shuffle"), for: .normal)
        btn.tintColor = .white
        btn.alpha = 0.5
        btn.addTarget(self, action: #selector(handleAction(sender:)), for: .touchUpInside)
        return btn
    }()
    let repeatBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "ic_repeat"), for: .normal)
        btn.tintColor = .white
        btn.alpha = 0.5
        btn.addTarget(self, action: #selector(handleAction(sender:)), for: .touchUpInside)
        return btn
    }()
    let likeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "ic_like"), for: .normal)
        btn.tintColor = .white
        btn.alpha = 0.5
        btn.addTarget(self, action: #selector(handleAction(sender:)), for: .touchUpInside)
        return btn
    }()
    let shareBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "ic_share"), for: .normal)
        btn.tintColor = .white
        btn.alpha = 0.5
        btn.addTarget(self, action: #selector(handleAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    var mDelegate: InfoVideoHeaderDelegate?
    
    @objc func handleAction(sender: UIButton) {

        if sender.isEqual(shareBtn) {
            mDelegate?.didPressButtonWithAction(type: .share)
        } else if sender.isEqual(likeBtn) {
            mDelegate?.didPressButtonWithAction(type: .like)
        } else if sender.isEqual(repeatBtn) {
            mDelegate?.didPressButtonWithAction(type: .repeet)
        } else if sender.isEqual(shuffleBtn) {
            mDelegate?.didPressButtonWithAction(type: .shuffle)
        }
        
        if sender.alpha < 1 {
            sender.alpha = 1
        } else {
            sender.alpha = 0.5
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightBackground
        
        let buttonsContainer = UIStackView()
        
        buttonsContainer.axis = .horizontal
        buttonsContainer.distribution = .fillEqually
        
        addSubview(title)
        addSubview(viewsCounter)
        addSubview(buttonsContainer)

        buttonsContainer.addArrangedSubview(repeatBtn)
        buttonsContainer.addArrangedSubview(shuffleBtn)
        buttonsContainer.addArrangedSubview(likeBtn)
        buttonsContainer.addArrangedSubview(shareBtn)
        
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: title)
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: viewsCounter)
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: buttonsContainer)
        addConstraintsWithFormat(format: "V:|-8-[v0]-4-[v1]-4-[v2(40)]-8-|", views: title, viewsCounter, buttonsContainer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
