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

// https://www.googleapis.com/youtube/v3/playlists?maxResults=20&channelId=UC0lT9K8Wfuc1KPqm6YjRf1A&part=snippet,CcontentDetails&key=AIzaSyBizkOnS-AAX8rb5ZtqGUfav0afp7WKh0M

// PLayList Items
// https://www.googleapis.com/youtube/v3/playlistItems?
// maxResults=2
// playlistId=PLiCpP_44QZBwAebJGnNzH-gEHAqFL9et5
// part=snippet,ContentDetails
// key=AIzaSyBizkOnS-AAX8rb5ZtqGUfav0afp7WKh0M

// Search Videos in Channel
// https://www.googleapis.com/youtube/v3/search?
// key=AIzaSyBizkOnS-AAX8rb5ZtqGUfav0afp7WKh0M
// channelId=UC0lT9K8Wfuc1KPqm6YjRf1A
// part=snippet,id
// order=date
// maxResults=20

// https://www.googleapis.com/youtube/v3/search?key=AIzaSyBizkOnS-AAX8rb5ZtqGUfav0afp7WKh0M&channelId=UC0lT9K8Wfuc1KPqm6YjRf1A&part=snippet,id&order=date&maxResults=20

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    let CURRENT_CHANNEL_ID = YT_CHANNEL_ID_ACADEMEG
    
    // PLayLists
    let PLAYLISTS_BASE_URL = "https://www.googleapis.com/youtube/v3/playlists"
    // PLayList Items
    let PLAYLIST_ITEMS_BASE_URL = "https://www.googleapis.com/youtube/v3/playlistItems"
    // Search Videos in Channel
    let SEARCH_BASE_URL = "https://www.googleapis.com/youtube/v3/search"
    
    // test url
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets/"
    
    func dataWith(strUrl: String, completion: @escaping (Data) -> ()) {
        let url = URL(string: strUrl)
        let request : URLRequest = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error != nil {
                
            } else if let data = data {
                completion(data)
            }
        }.resume()
    }
    
    func searchVideosNextPage(nextPageToken: String?, completion: @escaping (YTSearchResponse) -> ()) {
        
        var url = "\(SEARCH_BASE_URL)?key=\(YT_API_KEY)&channelId=\(CURRENT_CHANNEL_ID)&part=snippet&order=date&type=video&maxResults=20"
        if let nextPageToken = nextPageToken {
            url.append("&pageToken=\(nextPageToken)")
        }
        dataWith(strUrl: url) { (data) in
            do {
                let ytSearchResponse = try  JSONDecoder().decode(YTSearchResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(ytSearchResponse)
                }
            } catch let err {
                print("Error parsing data:",err)
            }
        }
    }
    
    func searchPlayListsNextPage(nextPageToken: String?, completion: @escaping (YTPLResponse) -> ()) {
        var url = "\(PLAYLISTS_BASE_URL)?key=\(YT_API_KEY)&channelId=\(CURRENT_CHANNEL_ID)&part=snippet,contentDetails,id&order=date&maxResults=10"
        if let nextPageToken = nextPageToken {
            url.append("&pageToken=\(nextPageToken)")
        }
        dataWith(strUrl: url) { (data) in
            do {
                let ytPlResponse = try JSONDecoder().decode(YTPLResponse.self, from: data)
                //                    print(ytSearchResponse)
                DispatchQueue.main.async {
                    completion(ytPlResponse)
                }
            } catch let err {
                print("Error parsing data:",err)
            }
        }
    }
    
    func fetchPlayListItems(id: String, nextPageToken: String?, completion: @escaping (YTPLItemsResponse) -> ()) {
        var url = "\(PLAYLIST_ITEMS_BASE_URL)?key=\(YT_API_KEY)&playlistId=\(id)&channelId=\(CURRENT_CHANNEL_ID)&type=video&part=snippet,contentDetails&order=date&maxResults=10"
        if let nextPageToken = nextPageToken {
            url.append("&pageToken=\(nextPageToken)")
        }
        dataWith(strUrl: url) { (data) in
            do {
                let ytPlResponse = try JSONDecoder().decode(YTPLItemsResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(ytPlResponse)
                }
            } catch let err {
                print("Error parsing data:",err)
            }
        }
    }
    
    func download() {
//        let videoURL = "http://www.youtube.com/watch?v=KMU0tzLwhbE"
//        let url = NSURL(string: "http://www.youtubeinmp3.com/fetch/?format=JSON&video=\(videoURL)")
//        let sessionConfig = URLSessionConfiguration.default
//        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
//        let request = NSMutableURLRequest(url: url! as URL)
//        request.httpMethod = "GET"
//        
//        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
//            if (error == nil) {
//                if let response = response as? HTTPURLResponse {
//                    print("response=\(response)")
//                    if response.statusCode == 200 {
//                        if data != nil {
//                            do {
//                                let responseJSON =  try  JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary;
//                                let urlString = responseJSON["link"] as! String
//                                let directDownloadURL = NSURL(string: urlString)
//                                
//                            
//                                // Call your method loadFileAsync
////                                YourClass.loadFileAsync(directDownloadURL!, completion: { (path, error) -> Void in
////                                    print(path)
//                            } catch let err {
//                                print("unknown error in JSON Parsing", err);
//                            }
//                        }
//                    }
//                }
//            } else {
//                print("Failure: \(error!.localizedDescription)");
//            }
//        }
//        task.resume()
    }
//    func fetchVideos(completion: @escaping ([VideoTemp]) -> ()) {
//        fetchFeedFor(url: "\(baseUrl)home.json", completion: completion)
//    }
//
//    func fetchTrending(completion: @escaping ([VideoTemp]) -> ()) {
//        fetchFeedFor(url: "\(baseUrl)trending.json", completion: completion)
//    }
//
//    func fetchSubscriptions(completion: @escaping ([VideoTemp]) -> ()) {
//        fetchFeedFor(url: "\(baseUrl)subscriptions.json", completion: completion)
//    }
//    
//    func fetchFeedFor(url: String, completion: @escaping ([VideoTemp]) -> ()) {
//        var videos = [VideoTemp]()
//        let url = URL(string: url)
//        let request : URLRequest = URLRequest(url: url!)
//        URLSession.shared.dataTask(with: request) {
//            (data, response, error) in
//
//            if (error != nil) {
//                print("Ooops, errror hase occored")
//                return
//            } else if let data = data {
//
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//
//                    for dic in json as! [[String: AnyObject]] {
//                        print(dic["title"] ?? "[default value]")
//
//                        let channel = ChannelTemp()
//                        channel.name = dic["channel"]!["name"] as? String
//                        channel.profileImageName = dic["channel"]!["profile_image_name"] as? String
//
//                        let video = VideoTemp()
//                        video.title = dic["title"] as? String
//                        video.thumbnailImageName = dic["thumbnail_image_name"] as? String
//                        video.numberOfViews = dic["number_of_views"] as? NSNumber
//                        video.duration = dic["duration"] as? Int
//                        video.channel = channel
//
//                        videos.append(video)
//                    }
//
//                    DispatchQueue.main.async {
//                        completion(videos)
//                    }
//                    //                    print(json)
//                } catch let jsonError {
//                    print(jsonError)
//                }
//            }
//        }.resume()
//    }
}
