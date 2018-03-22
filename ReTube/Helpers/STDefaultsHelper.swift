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
    
    func updatePercentageForVideo(id: String, percentage: Float) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(percentage, forKey: id)
        userDefaults.synchronize()
    }
    
    func percentageForVideo(id: String) -> Float {
        return UserDefaults.standard.float(forKey: id)
    }
    
    func add(video: STVideo) {
        if let data = UserDefaults.standard.value(forKey: NSDefaultsLikedVideosKey) as? Data {
            if var videos = try? PropertyListDecoder().decode(Dictionary<String, STVideo>.self, from: data) {
                videos[video.id] = video
                UserDefaults.standard.set(try? PropertyListEncoder().encode(videos), forKey: NSDefaultsLikedVideosKey)
                print("STLikedHelper: Saved!")
            }
        } else {
            let videos: Dictionary<String, STVideo> = [video.id: video]
            UserDefaults.standard.set(try? PropertyListEncoder().encode(videos), forKey: NSDefaultsLikedVideosKey)
            print("STLikedHelper: Saved!")
        }
        
        NotificationCenter.default.post(name: kReloadLikedTabNotification, object: nil)
    }
    
    func remove(video: STVideo) {
        if let data = UserDefaults.standard.value(forKey: NSDefaultsLikedVideosKey) as? Data {
            if var videos = try? PropertyListDecoder().decode(Dictionary<String, STVideo>.self, from: data) {
                videos.removeValue(forKey: video.id)
                UserDefaults.standard.set(try? PropertyListEncoder().encode(videos), forKey: NSDefaultsLikedVideosKey)
                print("STLikedHelper: Removed!")
            }
        }
        
        NotificationCenter.default.post(name: kReloadLikedTabNotification, object: nil)
    }
    
    func isLiked(video: STVideo) -> Bool {
        if let data = UserDefaults.standard.value(forKey: NSDefaultsLikedVideosKey) as? Data {
            if var videos = try? PropertyListDecoder().decode(Dictionary<String, STVideo>.self, from: data) {
                if videos[video.id] != nil {
                    return true
                }
            }
        }
        return false
    }
    
    func allVideos() -> [STVideo] {
        if let data = UserDefaults.standard.value(forKey: NSDefaultsLikedVideosKey) as? Data {
            if let videos = try? PropertyListDecoder().decode(Dictionary<String, STVideo>.self, from: data) {
                let arr = Array(videos.values)
                return arr
            }
        }
        return [STVideo]()
    }
}
