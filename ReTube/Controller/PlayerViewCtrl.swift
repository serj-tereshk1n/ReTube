//
//  PlayerView.swift
//  ReTube
//
//  Created by sergey.tereshkin on 08/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class PlayerViewCtrl: UIView {

    let kMinimizedPlayerHeight: CGFloat = 72
    let kMinimizedPlayerMargin: CGFloat = 16
    
    let minimizedPlayerContainerView: UIView = {
        let mplayer = UIView()
        mplayer.backgroundColor = .black
        mplayer.isUserInteractionEnabled = true
        mplayer.alpha = 0
        return mplayer
    }()
    
    let playerView: MainPlayerView = {
        let player = MainPlayerView()
        player.isUserInteractionEnabled = true
        return player
    }()
    
    let playerViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var playerOriginalFrame: CGRect?
    
    var launcher: VideoLauncher?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bottomView)
        addSubview(minimizedPlayerContainerView)
        addSubview(playerViewContainer)
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        addConstraintsWithFormat(format: "V:|[v0(\( Int(kMinimizedPlayerHeight) ))]-\( Int(kMinimizedPlayerMargin + statusBarHeight) )-[v1]-0-[v2]|", views: minimizedPlayerContainerView, playerViewContainer, bottomView)
        addConstraintsWithFormat(format: "H:|-\( Int(kMinimizedPlayerMargin) )-[v0]-\( Int(kMinimizedPlayerMargin) )-|", views: minimizedPlayerContainerView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: playerViewContainer)
        addConstraintsWithFormat(format: "H:|[v0]|", views: bottomView)
        
        playerViewContainer.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 9 / 16).isActive = true
        
        playerView.minimizedContainer = minimizedPlayerContainerView
        
        portraintPlayerConstraints()
    }
    
    func loadVideo(id: String) {
        playerView.loadVideo(id: id)
    }
    
    func portraintPlayerConstraints() {
        playerViewContainer.addSubview(playerView)
        addFullScreenConstraintsFor(views: playerView, inside: playerViewContainer)
    }

    func didMinimized() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        playerView.didMinimized()
    }
    
    func didMaximized() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        playerView.didMaximized()
    }
    
    func didClose() {
        playerView.didClose()
    }
    
    // MARK - Device orientation callback
    @objc func orientationDidChange() {
        
        let keyWindow = UIApplication.shared.keyWindow
        
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            
            // rotate right
            var div: CGFloat = -2.0
            
            // rotate left
            if UIDevice.current.orientation == .landscapeLeft {
                div = 2.0
            }
            
            if let kw = keyWindow {
                kw.addSubview(playerView)
                
                playerView.translatesAutoresizingMaskIntoConstraints = true
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.layoutIfNeeded()
                    UIApplication.shared.isStatusBarHidden = true
                    self.playerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / div)
                    self.playerView.frame = CGRect(x: 0, y: 0, width: kw.frame.width, height: kw.frame.height)
                })
            }
            
            break;
        case .portrait:
       
            portraintPlayerConstraints()

            UIView.animate(withDuration: 0.3, animations: {
                self.layoutIfNeeded()
                UIApplication.shared.isStatusBarHidden = false
                self.playerView.transform = CGAffineTransform(rotationAngle: 0)
            })
            
            break;
        default:
            print("Unknown orientation")
            break;
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
