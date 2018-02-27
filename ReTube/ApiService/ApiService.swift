//
//  ApiService.swift
//  ReTube
//
//  Created by sergey.tereshkin on 26/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
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
