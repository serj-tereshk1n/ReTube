//
//  ApiService.swift
//  ReTube
//
//  Created by sergey.tereshkin on 26/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

// YT URL Examples:

// PLayLists
// https://www.googleapis.com/youtube/v3/playlists?
// maxResults=1
// channelId=UC0lT9K8Wfuc1KPqm6YjRf1A
// part=snippet,CcontentDetails
// key=AIzaSyBizkOnS-AAX8rb5ZtqGUfav0afp7WKh0M

// PLayList Items
// https://www.googleapis.com/youtube/v3/playlistItems?
// maxResults=2
// playlistId=PLiCpP_44QZBwAebJGnNzH-gEHAqFL9et5
// part=snippet,CcontentDetails
// key=AIzaSyBizkOnS-AAX8rb5ZtqGUfav0afp7WKh0M

// Search Videos in Channel
// https://www.googleapis.com/youtube/v3/search?
// key=AIzaSyBizkOnS-AAX8rb5ZtqGUfav0afp7WKh0M
// channelId=UC0lT9K8Wfuc1KPqm6YjRf1A
// part=snippet,id
// order=date
// maxResults=20

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    // PLayLists
    let PLAYLISTS_BASE_URL = "https://www.googleapis.com/youtube/v3/playlists?"
    // PLayList Items
    let PLAYLIST_ITEMS_BASE_URL = "https://www.googleapis.com/youtube/v3/playlistItems?"
    // Search Videos in Channel
    let SEARCH_BASE_URL = "https://www.googleapis.com/youtube/v3/search?"
    
    // test url
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets/"
    
    func fetchVideos(completion: @escaping ([VideoTemp]) -> ()) {
        fetchFeedFor(url: "\(baseUrl)home.json", completion: completion)
    }
    
    func fetchTrending(completion: @escaping ([VideoTemp]) -> ()) {
        fetchFeedFor(url: "\(baseUrl)trending.json", completion: completion)
    }
    
    func fetchSubscriptions(completion: @escaping ([VideoTemp]) -> ()) {
        fetchFeedFor(url: "\(baseUrl)subscriptions.json", completion: completion)
    }
    
    func fetchFeedFor(url: String, completion: @escaping ([VideoTemp]) -> ()) {
        var videos = [VideoTemp]()
        let url = URL(string: url)
        let request : URLRequest = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            if (error != nil) {
                print("Ooops, errror hase occored")
                return
            } else if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    
                    for dic in json as! [[String: AnyObject]] {
                        print(dic["title"] ?? "[default value]")
                        
                        let channel = ChannelTemp()
                        channel.name = dic["channel"]!["name"] as? String
                        channel.profileImageName = dic["channel"]!["profile_image_name"] as? String
                        
                        let video = VideoTemp()
                        video.title = dic["title"] as? String
                        video.thumbnailImageName = dic["thumbnail_image_name"] as? String
                        video.numberOfViews = dic["number_of_views"] as? NSNumber
                        video.duration = dic["duration"] as? Int
                        video.channel = channel
                        
                        videos.append(video)
                    }
                    
                    DispatchQueue.main.async {
                        completion(videos)
                    }
                    //                    print(json)
                } catch let jsonError {
                    print(jsonError)
                }
            }
        }.resume()
    }
}
