//
//  STLikedHelper.swift
//  ReTube
//
//  Created by sergey.tereshkin on 19/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class STDefaultsHelper: NSObject {

    static let shared = STDefaultsHelper()
    
    let kUserDefaults = UserDefaults.standard
    
    // MARK - Liked videos interaction methods
    
    func addLiked(video: STVideo) {
        addToDefaults(video: video, key: NSDefaultsLikedVideosKey)
        NotificationCenter.default.post(name: kReloadLikedTabNotification, object: nil)
    }
    func removeLiked(video: STVideo) {
        removeFromDefaults(video: video, key: NSDefaultsLikedVideosKey)
        NotificationCenter.default.post(name: kReloadLikedTabNotification, object: nil)
    }
    func isLiked(video: STVideo) -> Bool {
        return isPresent(video: video, under: NSDefaultsLikedVideosKey)
    }
    func allLikedVideos() -> [STVideo] {
        return allVideosFor(key: NSDefaultsLikedVideosKey)
    }
    
    // MARK - Watched/Continue Watching videos methods
    
    func addWatchAgain(video: STVideo) {
        addToDefaults(video: video, key: NSDefaultsWatchAgainVideosKey)
    }
    func removeWatchAgain(video: STVideo) {
        removeFromDefaults(video: video, key: NSDefaultsWatchAgainVideosKey)
    }
    func allWatchAgainVideos() -> [STVideo] {
        return allVideosFor(key: NSDefaultsWatchAgainVideosKey)
    }
    
    // Continue Watching
    func addContinueWatching(video: STVideo) {
        addToDefaults(video: video, key: NSDefaultsContinueWatchingVideosKey)
    }
    func removeContinueWatching(video: STVideo) {
        removeFromDefaults(video: video, key: NSDefaultsContinueWatchingVideosKey)
    }
    func allContinueWatchingVideos() -> [STVideo] {
        return allVideosFor(key: NSDefaultsContinueWatchingVideosKey)
    }
    
    // MARK - Watched video percentage methods
    
    func updatePercentageForVideo(id: String, percentage: Float) {
        kUserDefaults.set(percentage, forKey: id)
        kUserDefaults.synchronize()
    }
    func percentageForVideo(id: String) -> Float {
        return kUserDefaults.float(forKey: id)
    }
    
    // MARK fileprivate methods, can't touch this, to to do do, do do...  can't touch this
    
    fileprivate func addToDefaults(video: STVideo, key: String) {
        if let data = kUserDefaults.value(forKey: key) as? Data {
            if var videos = try? PropertyListDecoder().decode(Dictionary<String, STVideo>.self, from: data) {
                videos[video.id] = video
                kUserDefaults.set(try? PropertyListEncoder().encode(videos), forKey: key)
            }
        } else {
            let videos: Dictionary<String, STVideo> = [video.id: video]
            kUserDefaults.set(try? PropertyListEncoder().encode(videos), forKey: key)
        }
    }
    fileprivate func removeFromDefaults(video: STVideo, key: String) {
        if let data = kUserDefaults.value(forKey: key) as? Data {
            if var videos = try? PropertyListDecoder().decode(Dictionary<String, STVideo>.self, from: data) {
                videos.removeValue(forKey: video.id)
                kUserDefaults.set(try? PropertyListEncoder().encode(videos), forKey: key)
            }
        }
    }
    fileprivate func isPresent(video: STVideo, under key: String) -> Bool{
        if let data = kUserDefaults.value(forKey: key) as? Data {
            if var videos = try? PropertyListDecoder().decode(Dictionary<String, STVideo>.self, from: data) {
                if videos[video.id] != nil {
                    return true
                }
            }
        }
        return false
    }
    fileprivate func allVideosFor(key: String) -> [STVideo]  {
        if let data = kUserDefaults.value(forKey: key) as? Data {
            if let videos = try? PropertyListDecoder().decode(Dictionary<String, STVideo>.self, from: data) {
                let arr = Array(videos.values)
                return arr
            }
        }
        return [STVideo]()
    }
    
}
