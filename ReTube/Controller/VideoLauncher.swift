//
//  VideoLauncher.swift
//  ReTube
//
//  Created by sergey.tereshkin on 28/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class VideoLauncher: NSObject {
    
    // constant and static members
    static let sharedInstance = VideoLauncher()
    
    // variable memebers
    var lastTouch: CGPoint?
    
    // views
    var playerCtrlView: PlayerViewCtrl = {
        let view = PlayerViewCtrl()
        view.backgroundColor = .clear
        return view
    }()
    
    let keyWindow: UIWindow = {
        return UIApplication.shared.keyWindow ?? UIWindow()
    }()
    
    var playerOriginalFrame: CGRect?
    
    // initialization
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(closeVideoPlayer),
            name: K.kCloseVideoPlayerNotification,
            object: nil)
        
        let minimizedPlayerOffset = playerCtrlView.kMinimizedPlayerHeight + playerCtrlView.kMinimizedPlayerMargin
        
        playerCtrlView.frame = CGRect(x: 0,
                                y: keyWindow.frame.height + minimizedPlayerOffset,
                                width: keyWindow.frame.width,
                                height: keyWindow.frame.height + minimizedPlayerOffset)
        
        keyWindow.addSubview(playerCtrlView)
        
        let mainViewGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        let minimizedPlayerGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        playerCtrlView.playerViewContainer.addGestureRecognizer(mainViewGestureRecognizer)
        playerCtrlView.minimizedPlayerContainerView.addGestureRecognizer(minimizedPlayerGestureRecognizer)
        playerCtrlView.minimizedPlayerContainerView.addGestureRecognizer(tapGesture)
        playerCtrlView.launcher = self
    }
    
    // show, hide minimize helper functions
    func showVideoPlayer() {
        let minimizedPlayerOffset = playerCtrlView.kMinimizedPlayerHeight + playerCtrlView.kMinimizedPlayerMargin
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.playerCtrlView.frame = CGRect(x: 0,
                                         y: -minimizedPlayerOffset,
                                         width: self.playerCtrlView.frame.width,
                                         height: self.playerCtrlView.frame.height)
            self.playerCtrlView.minimizedPlayerContainerView.alpha = 0
        }, completion: { (_) in
              self.playerCtrlView.didMaximized()
        })
    }
    
    func minimizeVideoPlayer() {
        let minimizedPlayerOffset = playerCtrlView.kMinimizedPlayerHeight + playerCtrlView.kMinimizedPlayerMargin
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.playerCtrlView.frame = CGRect(x: 0,
                                         y: self.keyWindow.frame.height - minimizedPlayerOffset,
                                         width: self.playerCtrlView.frame.width,
                                         height: self.playerCtrlView.frame.height)
            self.playerCtrlView.minimizedPlayerContainerView.alpha = 1
        }, completion: { (_) in
            self.playerCtrlView.didMinimized()
        })
    }
    
    @objc func closeVideoPlayer() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.playerCtrlView.frame = CGRect(x: 0,
                                         y: self.keyWindow.frame.height,
                                         width: self.playerCtrlView.frame.width,
                                         height: self.playerCtrlView.frame.height)
            self.playerCtrlView.minimizedPlayerContainerView.alpha = 0
        }, completion: { (_) in
            self.playerCtrlView.didClose()
        })
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        showVideoPlayer()
    }
    
    // MARK - Gesture recognizerz
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        switch gestureRecognizer.state {
        case .began, .changed:
            // move player view
            lastTouch = gestureRecognizer.location(in: keyWindow)
            
            if  let view = gestureRecognizer.view {
                let translation = gestureRecognizer.translation(in: playerCtrlView)
                let newCenterPoint = CGPoint(x: playerCtrlView.frame.size.width / 2, y: playerCtrlView.center.y + translation.y)
                
                if let superview = view.superview {
                    superview.center = newCenterPoint
                    gestureRecognizer.setTranslation(CGPoint.zero, in: playerCtrlView.superview)
                }
            }
            
            break;
        case .ended:
            // minimize or show full player
            if let lastTouch = lastTouch {
                if lastTouch.y > keyWindow.center.y {
                    minimizeVideoPlayer()
                } else {
                    showVideoPlayer()
                }
            }
            break;
            
        default:
            // there's nothing I can do here
            print("Print statement to make compiler happy")
        }
    }
}

