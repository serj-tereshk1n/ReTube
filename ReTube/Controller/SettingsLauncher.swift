//
//  SettingsLauncher.swift
//  ReTube
//
//  Created by Ner√e D4mage on 23/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

class Setting: NSObject {
    let name: String
    let imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

class SettingsLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .darkBackground
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: kMenuCellId)
    }
    
    let rowHeight: CGFloat = 50
    
    let kMenuCellId = "kMenuCellId"
    
    let settings: [Setting] = {
        return [Setting(name: "Settings", imageName: "ic_settings"),
                Setting(name: "Switch account", imageName: "ic_account"),
                Setting(name: "Help", imageName: "ic_help"),
                Setting(name: "Feedback", imageName: "ic_feedback"),
                Setting(name: "Cancel", imageName: "ic_cancel")]
    }()
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .white
        return cv
    }()
    
    @objc func showSettings() {
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.7)
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            let height: CGFloat = CGFloat(settings.count) * rowHeight
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
    }
    
    // MARK -- UIColleciton View Delegate, DataSource and FlowLayout
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kMenuCellId, for: indexPath) as! SettingCell
        cell.setting = settings[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: rowHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleDismissMoreAction()
    }
}
