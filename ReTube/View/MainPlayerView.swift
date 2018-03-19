//
//  PlayerView.swift
//  ReTube
//
//  Created by sergey.tereshkin on 01/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit
import AVFoundation

class MainPlayerView: UIView, YTPlayerViewDelegate, PlaylistViewDelegate {
    
    // MARK - PlaylistViewDelegate
    func didSelectVideoWith(id: String) {
        loadVideo(id: id)
    }
    
    func videosCount(count: Int) {
        // todo
    }
    
    func currentVideoIndex(index: Int) {
        // todo
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayerView()
    }

    let player = YTPlayerView()
    let kTimerInterval: Double = 3.5
    var controlsTimer: Timer?
    let playerOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    let controlsPanelView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.alpha = 0
        return view
    }()
    let activityIndicatorView: UIView = {
        let container = UIView()
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.tintColor = .selected
        container.backgroundColor = .black
        container.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        indicator.startAnimating()
        return container
    }()
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ic_pause"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        return button
    }()
    let placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let videoCurrentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .subtitle
        label.textAlignment = .center
        return label
    }()
    lazy var seekSlider: UISlider = {
        let slider = UISlider()
        slider.setThumbImage(#imageLiteral(resourceName: "ic_thumb"), for: .normal)
        slider.minimumTrackTintColor = .selected
        slider.maximumTrackTintColor = .deselected
        slider.addTarget(self, action: #selector(seekSliderDidChange(slider:)), for: .valueChanged)
        return slider
    }()
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .subtitle
        label.textAlignment = .center
        return label
    }()
    let minimizeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_minimize"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleMinimizePlayer), for: .touchUpInside)
        return button
    }()
    let minimizedPlayer: MinimizedPlayerView = {
        let mplayer = MinimizedPlayerView()
        mplayer.backgroundColor = .clear
        return mplayer
    }()
    let playlistView: PlaylistView = {
        let view = PlaylistView()
        view.backgroundColor = .white
        return view
    }()
    var minimizedContainer: UIView? {
        didSet {
            if let mc = minimizedContainer {
                mc.addSubview(minimizedPlayer)
                addFullScreenConstraintsFor(views: minimizedPlayer, inside: mc)
                minimizedPlayer.pausePlayButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
                minimizedPlayer.closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
            }
        }
    }
    var listContainer: UIView? {
        didSet {
            if let container =  listContainer{
                container.addSubview(playlistView)
                addFullScreenConstraintsFor(views: playlistView, inside: container)
            }
        }
    }

    func setupPlayerView() {

        addSubview(placeholderImageView)
        addSubview(player)
        addSubview(playerOverlayView)
        playerOverlayView.addSubview(controlsPanelView)
        addFullScreenConstraintsFor(views: player, playerOverlayView, placeholderImageView, inside: self)
        addFullScreenConstraintsFor(views: controlsPanelView, inside: playerOverlayView)
        controlsPanelView.addSubview(pausePlayButton)
        controlsPanelView.addSubview(seekSlider)
        controlsPanelView.addSubview(minimizeButton)
        let seekBarContainerView = UIView()
        controlsPanelView.addSubview(seekBarContainerView)
        seekBarContainerView.addSubview(videoCurrentTimeLabel)
        seekBarContainerView.addSubview(seekSlider)
        seekBarContainerView.addSubview(videoLengthLabel)
        controlsPanelView.addConstraintsWithFormat(format: "H:|-4-[v0(28)]", views: minimizeButton)
        controlsPanelView.addConstraintsWithFormat(format: "V:|-4-[v0(28)]", views: minimizeButton)
        controlsPanelView.addConstraintsWithFormat(format: "H:|[v0]|", views: seekBarContainerView)
        controlsPanelView.addConstraintsWithFormat(format: "V:[v0(30)]-8-|", views: seekBarContainerView)
        seekBarContainerView.addConstraintsWithFormat(format: "H:|-4-[v0(50)]-4-[v1]-4-[v2(50)]-4-|", views: videoCurrentTimeLabel, seekSlider, videoLengthLabel)
        seekBarContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: videoCurrentTimeLabel)
        seekBarContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: seekSlider)
        seekBarContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: videoLengthLabel)
        NSLayoutConstraint.activate([
            pausePlayButton.centerXAnchor.constraint(equalTo: controlsPanelView.centerXAnchor),
            pausePlayButton.centerYAnchor.constraint(equalTo: controlsPanelView.centerYAnchor)
            ])
        
        playlistView.delegate = self
        
        playerOverlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showControls(_:))))
        controlsPanelView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideControls(_:))))
    }
    
    private func loadVideo(id: String) {
        
        let vars = ["playsinline": 1,
                    "controls": 0,
                    "rel": 0,
                    "showinfo": 0]
        
        player.delegate = self
        player.load(withVideoId: id, playerVars: vars)
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setActive(true)
        } catch let err {
            print("Error:", err)
        }
        
        player.webView?.mediaPlaybackRequiresUserAction = false
    }
    
    func loadVideAndRelatedPlaylist(video: STVideo) {
        playlistView.video = video
    }

    func loadPlayList(list: YTPlayList) {
        playlistView.playlist = list
    }
    
    @objc func showControls(_ gestureRecognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.15, animations: {
            self.controlsPanelView.alpha = 1
        }) { (_) in
            self.resetHideControlsTimer()
        }
    }
    
    @objc func hideControls(_ gestureRecognizer: UITapGestureRecognizer) {
        controlsTimer?.invalidate()
        UIView.animate(withDuration: 0.15, animations: {
            self.controlsPanelView.alpha = 0
        })
    }

    func didMinimized() {
        placeholderImageView.image = player.asImage()
        minimizedPlayer.inFocusWith(player: player)
    }
    
    func didMaximized() {
        minimizedPlayer.placeholderImageView.image = player.asImage()
        insertSubview(player, belowSubview: playerOverlayView)
        addFullScreenConstraintsFor(views: player, inside: self)
    }
    
    func didClose() {
        player.stopVideo()
    }
    
    // MARK - Handle player controls events
    @objc func handlePlayPause() {
        
        resetHideControlsTimer()
        
        switch player.playerState() {
        case .playing:
            player.pauseVideo()
            break;
        case .paused:
            player.playVideo()
            break;
        case .ended:
            player.seek(toSeconds: 0, allowSeekAhead: true)
            break;
        default:
            print("Oooppps!")
        }
    }
    
    @objc func handleClose() {
        NotificationCenter.default.post(name: kCloseVideoPlayerNotification, object: nil)
    }
    
    @objc func handleMinimizePlayer() {
//        launcher?.minimizeVideoPlayer()
    }
    
    // MARK slider
    @objc func seekSliderDidChange(slider: UISlider) {
        player.seek(toSeconds: slider.value, allowSeekAhead: true)
        resetHideControlsTimer()
    }
    
    func resetHideControlsTimer() {
        controlsTimer?.invalidate()
        controlsTimer = Timer.scheduledTimer(timeInterval: kTimerInterval, target: self, selector: #selector(hideControls), userInfo: nil, repeats: true)
    }
    
    // MARK - YTPlayerViewDelegate
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        let duration: TimeInterval = playerView.duration()

        seekSlider.maximumValue = Float(duration)
        seekSlider.minimumValue = 0
        
        videoLengthLabel.text = timeStringFromSeconds(seconds: Int(duration))
        
        playerView.playVideo()
    }

    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        
        var image = UIImage()
        
        switch state {
        case .playing:
            image = #imageLiteral(resourceName: "ic_pause")
            break;
        case .paused:
            image = #imageLiteral(resourceName: "ic_play_arrow")
            break;
        case .unstarted:
                ///
            break;
        case .ended:
            playlistView.playNextVideo()
            image = #imageLiteral(resourceName: "ic_replay")
            break;
        case .buffering:
            print("Player buffering video")
            break;
        case .queued:
            print("Player queued")
            break;
        case .unknown:
            print("Player unknown state")
            break;
        }
        
        pausePlayButton.setImage(image, for: .normal)
        minimizedPlayer.pausePlayButton.setImage(image, for: .normal)
    }
    
    func playerViewPreferredInitialLoading(_ playerView: YTPlayerView) -> UIView? {
        return activityIndicatorView
    }
    
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return .black
    }
    
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        videoCurrentTimeLabel.text = timeStringFromSeconds(seconds: Int(playTime))
        seekSlider.setValue(playTime, animated: true)
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        print("YTPlayerView receivedError:", error)
    }
    
    // what?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
