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
    
    let kMinimizedPlayerHeight: CGFloat = 72
    let kMinimizedPlayerMargin: CGFloat = 16
    
    // variable memebers
    var lastTouch: CGPoint?
    
    // views
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let minimizedPlayerView: MinimizedPlayerView = {
        let mplayer = MinimizedPlayerView()
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
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let keyWindow: UIWindow = {
        return UIApplication.shared.keyWindow ?? UIWindow()
    }()
    
    var playerOriginalFrame: CGRect?
    
    // initialization
    override init() {
        super.init()
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            let minimizedPlayerOffset = kMinimizedPlayerHeight + kMinimizedPlayerMargin
            
            mainView.frame = CGRect(x: 0,
                                    y: keyWindow.frame.height + minimizedPlayerOffset,
                                    width: keyWindow.frame.width,
                                    height: keyWindow.frame.height + minimizedPlayerOffset)
            
            let playerHeight = keyWindow.frame.width * 9 / 16
            playerView.frame = CGRect(x: 0,
                                      y: minimizedPlayerOffset + statusBarHeight,
                                      width: keyWindow.frame.width,
                                      height: playerHeight)
            
            playerOriginalFrame = playerView.frame
            
            minimizedPlayerView.frame = CGRect(x: kMinimizedPlayerMargin,
                                                y: 0,
                                                width: mainView.frame.width - (kMinimizedPlayerMargin * 2),
                                                height: kMinimizedPlayerHeight)
            
            bottomView.frame = CGRect(x: 0, y: playerHeight + minimizedPlayerOffset + statusBarHeight, width: keyWindow.frame.width, height: keyWindow.frame.height - playerHeight - statusBarHeight)
            
            let fakePlayerView = UIView()
            fakePlayerView.frame = playerView.frame
            fakePlayerView.backgroundColor = .white
            
            mainView.addSubview(bottomView)
            mainView.addSubview(minimizedPlayerView)
            mainView.addSubview(fakePlayerView)
            mainView.addSubview(playerView)
            keyWindow.addSubview(mainView)
            
            let mainViewGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            let minimizedPlayerGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            
            playerView.addGestureRecognizer(mainViewGestureRecognizer)
            minimizedPlayerView.addGestureRecognizer(minimizedPlayerGestureRecognizer)
            minimizedPlayerView.addGestureRecognizer(tapGesture)
            
            playerView.launcher = self
            minimizedPlayerView.launcher = self
        }
    }
    
    // show, hide minimize helper functions
    func showVideoPlayer() {
        let minimizedPlayerOffset = kMinimizedPlayerHeight + kMinimizedPlayerMargin
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.mainView.frame = CGRect(x: 0,
                                         y: -minimizedPlayerOffset,
                                         width: self.mainView.frame.width,
                                         height: self.mainView.frame.height)
            self.minimizedPlayerView.alpha = 0
        }, completion: { (_) in
//            if self.wasMinimized {
                self.playerView.didMaximized()
//            }
            // maybe I will do something later here
        })
    }
    
    func minimizeVideoPlayer() {
        let minimizedPlayerOffset = kMinimizedPlayerHeight + kMinimizedPlayerMargin
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.mainView.frame = CGRect(x: 0,
                                         y: self.keyWindow.frame.height - minimizedPlayerOffset,
                                         width: self.mainView.frame.width,
                                         height: self.mainView.frame.height)
            self.minimizedPlayerView.alpha = 1
        }, completion: { (_) in
//            self.wasMinimized = true
            self.playerView.didMinimized()
        })
    }
    
//    var wasMinimized = false
    
    func closeVideoPlayer() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.mainView.frame = CGRect(x: 0,
                                         y: self.keyWindow.frame.height,
                                         width: self.mainView.frame.width,
                                         height: self.mainView.frame.height)
            self.minimizedPlayerView.alpha = 0
        }, completion: { (_) in
            // maybe I will do something later here
        })
    }
    
    // MARK - Gesture recognizerz
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if UIDevice.current.orientation != .portrait {
            return
        }
        
        switch gestureRecognizer.state {
        case .began, .changed:
            // move player view
            lastTouch = gestureRecognizer.location(in: keyWindow)
            
            if  let view = gestureRecognizer.view {
                let translation = gestureRecognizer.translation(in: mainView)
                let newCenterPoint = CGPoint(x: mainView.frame.size.width / 2, y: mainView.center.y + translation.y)
                
                if let superview = view.superview {
                    superview.center = newCenterPoint
                    gestureRecognizer.setTranslation(CGPoint.zero, in: mainView.superview)
                }
            }
            
            break;
        case .ended:
            // minimize or show full open player
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
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        showVideoPlayer()
    }
    
    // MARK - Device orientation callback
    @objc func orientationDidChange() {
        
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            let y = kMinimizedPlayerHeight + kMinimizedPlayerMargin
            UIView.animate(withDuration: 0.3, animations: {
                UIApplication.shared.isStatusBarHidden = true
                self.playerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
                self.playerView.frame = CGRect(x: 0, y: y, width: self.keyWindow.frame.width, height: self.keyWindow.frame.height)
            })
            
            break;
        case .landscapeRight:
            let y = kMinimizedPlayerHeight + kMinimizedPlayerMargin
            UIView.animate(withDuration: 0.3, animations: {
                UIApplication.shared.isStatusBarHidden = true
                self.playerView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
                self.playerView.frame = CGRect(x: 0, y: y, width: self.keyWindow.frame.width, height: self.keyWindow.frame.height)
            })
            break;
        case .portrait:
            UIView.animate(withDuration: 0.3, animations: {
                UIApplication.shared.isStatusBarHidden = false
                self.playerView.transform = CGAffineTransform(rotationAngle: 0)
                self.playerView.frame = self.playerOriginalFrame ?? CGRect.zero
            })
            
            break;
        default:
            print("Unknown orientation")
            break;
        }
    }
}

