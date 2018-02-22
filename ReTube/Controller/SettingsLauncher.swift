//
//  SettingsLauncher.swift
//  ReTube
//
//  Created by Ner√e D4mage on 23/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

class SettingsLauncher: NSObject {
    
    override init() {
        super.init()
        // uuuuu start doing something here maby
    }
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .white
        return cv
    }()
    
    @objc func showSettings() {
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            let height: CGFloat = 200
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissMoreAction)))
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: window.frame.width, height: height)
            }, completion: nil)
        }
    }
    
    @objc private func handleDismissMoreAction() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            self.collectionView.frame = CGRect(x: 0, y: self.collectionView.frame.height + self.collectionView.frame.minY, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        }) { (_) in
            self.blackView.removeFromSuperview()
        }
        
//        UIView.animate(withDuration: 0.5, animations: {
//            self.blackView.alpha = 0
//            self.collectionView.frame = CGRect(x: 0, y: self.collectionView.frame.height + self.collectionView.frame.minY, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
//        }) { (_) in
//            self.blackView.removeFromSuperview()
//        }
    }
    
    
}
