//
//  MenuBar.swift
//  ReTube
//
//  Created by sergey.tereshkin on 21/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let kCellId = "menuCellId"
    let menuButtons: [UIImage] = [#imageLiteral(resourceName: "ic_videos"), #imageLiteral(resourceName: "ic_playlist"), #imageLiteral(resourceName: "ic_favorite_border"), #imageLiteral(resourceName: "ic_profile")]
    var homeController: HomeController?
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .ytRed
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: kCellId)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: .bottom)
        
        setupHorizontalBar()
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = .white
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        let widthMultiplier: CGFloat = CGFloat(1.0) / CGFloat(menuButtons.count)
        
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor);
        horizontalBarLeftAnchorConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: widthMultiplier),
            horizontalBarView.heightAnchor.constraint(equalToConstant: 4)
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeController?.scrollToMenuAt(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuButtons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! MenuCell
        cell.imageView.image = menuButtons[indexPath.row].withRenderingMode(.alwaysTemplate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / CGFloat(menuButtons.count), height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
