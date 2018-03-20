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

// https://www.googleapis.com/youtube/v3/playlistItems?maxResults=20&playlistId=PLiCpP_44QZBwAebJGnNzH-gEHAqFL9et5&part=snippet&key=AIzaSyBizkOnS-AAX8rb5ZtqGUfav0afp7WKh0M

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

// related videos search (type=video & relatedToVideoId= )
// https://www.googleapis.com/youtube/v3/search?maxResults=10&relatedToVideoId=xyVdZrL3Sbo&channelId=UCtinbF-Q-fVthA0qrFQTgXQ&part=snippet&key=AIzaSyBizkOnS-AAX8rb5ZtqGUfav0afp7WKh0M&type=video

// video statistics
// https://www.googleapis.com/youtube/v3/videos?key=AIzaSyBizkOnS-AAX8rb5ZtqGUfav0afp7WKh0M&id=xyVdZrL3Sbo&part=statistics,contentDetails

class ApiService: NSObject {
    
    enum DecodableType: Int {
        case playlistItems = 2, searchItems = 3
    }
    
    enum Order: String {
        case date = "order", rating = "rating", viewCount = "viewCount"
    }
    
    static let sharedInstance = ApiService()
    
    let CURRENT_CHANNEL_ID = YT_CHANNEL_ID_ACADEMEG
//    let kQueryLimit = 50 // should be maximum acceptable for api in use
    let kQueryLimit = 10
    // PLayLists
    let PLAYLISTS_BASE_URL = "https://www.googleapis.com/youtube/v3/playlists"
    // PLayList Items
    let PLAYLIST_ITEMS_BASE_URL = "https://www.googleapis.com/youtube/v3/playlistItems"
    // Search Videos in Channel
    let SEARCH_BASE_URL = "https://www.googleapis.com/youtube/v3/search"
    
    func playListItemsNextPage(id: String, nextPageToken: String?, completion: @escaping (STResponse) -> ()) {
        var url = "\(PLAYLIST_ITEMS_BASE_URL)?key=\(YT_API_KEY)&playlistId=\(id)&channelId=\(CURRENT_CHANNEL_ID)&type=video&part=snippet,contentDetails&order=date&maxResults=\(kQueryLimit)"
        if let nextPageToken = nextPageToken {
            url.append("&pageToken=\(nextPageToken)")
        }
        fetchLinkWith(strUrl: url, type: .playlistItems, completion: completion)
    }
    
    func searchNextPage(nextPageToken: String?, order: Order, completion: @escaping (STResponse) -> ()) {
        var url = "\(SEARCH_BASE_URL)?key=\(YT_API_KEY)&channelId=\(CURRENT_CHANNEL_ID)&part=snippet&order=\(order)&type=video&maxResults=\(kQueryLimit)"
        if let nextPageToken = nextPageToken {
            url.append("&pageToken=\(nextPageToken)")
        }
        fetchLinkWith(strUrl: url, type: .searchItems, completion: completion)
    }
    
    func relatedVideosTo(videoId: String, nextPageToken: String?, order: Order, completion: @escaping (STResponse) -> ()) {
        var url = "\(SEARCH_BASE_URL)?key=\(YT_API_KEY)&videoSyndicated=true&channelId=\(CURRENT_CHANNEL_ID)&part=snippet&order=\(order)&type=video&maxResults=\(kQueryLimit)&relatedToVideoId=\(videoId)"

        if let nextPageToken = nextPageToken {
            url.append("&pageToken=\(nextPageToken)")
        }
        fetchLinkWith(strUrl: url, type: .searchItems, completion: completion)
    }
    
    func searchPublishedBefore(before: String, nextPageToken: String?, order: Order, completion: @escaping (STResponse) -> ()) {
        var url = "\(SEARCH_BASE_URL)?publishedBefore=\(before)&key=\(YT_API_KEY)&channelId=\(CURRENT_CHANNEL_ID)&part=snippet&order=\(order)&type=video&maxResults=\(kQueryLimit)"
        if let nextPageToken = nextPageToken {
            url.append("&pageToken=\(nextPageToken)")
        }
        fetchLinkWith(strUrl: url, type: .searchItems, completion: completion)
    }
    
    func statisticsForVideo(id: String, completion: @escaping (STStatistics, STContentDetails) -> ()) {
        
        let url = "https://www.googleapis.com/youtube/v3/videos?id=\(id)&key=\(YT_API_KEY)&part=statistics,contentDetails"
        
        dataWith(strUrl: url) { (data) in
            
            do {
                let ytresp = try JSONDecoder().decode(YTStatsResponse.self, from: data)
                if  ytresp.items.count > 0 {
                    DispatchQueue.main.async {
                        completion(ytresp.items[0].statistics, ytresp.items[0].contentDetails)
                    }
                }
            } catch let err {
                print("Errro while decoding statistics:", err)
            }
        }
    }
    
    func fetchLinkWith(strUrl: String, type: DecodableType, completion: @escaping (STResponse) -> ()) {
        
        dataWith(strUrl: strUrl) { (data) in
            do {

                var formatted: STResponse?
                
                switch(type) {
                case .playlistItems:
                    let ytResp = try JSONDecoder().decode(YTPLItemsResponse.self, from: data)
                    formatted = STResponse(resp: ytResp)
                    break;
                case .searchItems:
                    let ytResp = try JSONDecoder().decode(YTSearchResponse.self, from: data)
                    formatted = STResponse(resp: ytResp)
                    break;
                }
                
                if let resp = formatted {
                    DispatchQueue.main.async {
                        completion(resp)
                    }
                }

            } catch let err {
                print("Error parsing data:",err)
            }
        }
    }
    
    func dataWith(strUrl: String, completion: @escaping (Data) -> ()) {
        let url = URL(string: strUrl)
        let request : URLRequest = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error != nil {
                // todo manage errror
                print("Function fail (dataWith:)", error ?? "default error")
            } else if let data = data {
                completion(data)
            }
            print("Function fail (dataWith:)", response ?? "nil response")
        }.resume()
    }
    
    func searchPlayListsNextPage(nextPageToken: String?, completion: @escaping (YTPLResponse) -> ()) {
        var url = "\(PLAYLISTS_BASE_URL)?key=\(YT_API_KEY)&channelId=\(CURRENT_CHANNEL_ID)&part=snippet,contentDetails,id&order=date&maxResults=\(kQueryLimit)"
        if let nextPageToken = nextPageToken {
            url.append("&pageToken=\(nextPageToken)")
        }
        dataWith(strUrl: url) { (data) in
            do {
                let ytPlResponse = try JSONDecoder().decode(YTPLResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(ytPlResponse)
                    
                }
            } catch let err {
                print("Error parsing data:",err)
            }
        }
    }
}
