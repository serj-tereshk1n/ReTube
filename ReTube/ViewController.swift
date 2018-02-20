//
//  ViewController.swift
//  ReTube
//
//  Created by sergey.tereshkin on 19/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    struct YTPageInfo: Decodable {
        let resultsPerPage: Int
        let totalResults: Int
    }
    
    struct YTPLResponse: Decodable {
        let etag: String
        let kind: String
        let pageInfo: YTPageInfo
        let nextPageToken: String?
        let items: [YTPlayList]
    }
    
    struct YTChannel: Decodable {
        
    }
    
    struct YTPlayList: Decodable {
        let kind: String
        let etag: String
        let id: String
        let snippet: YTSnippet
        let contentDetails: YTContentDetails
    }
    
    struct YTSnippet: Decodable {
        let publishedAt: String
        let channelId: String
        let playlistId: String?
        let title: String
        let description: String
        let channelTitle: String
        let thumbnails: YTThumbnails
        let resourceId: YTResourceId?
        let position: Int?
    }
    
    struct YTThumbnails: Decodable {
        let medium: YTThumbnail
        let high: YTThumbnail
        let standard: YTThumbnail
        let maxres: YTThumbnail?
    }
    
    struct YTThumbnail: Decodable {
        let url: String
        let width: Int
        let height: Int
    }
    
    struct YTVideo: Decodable {
        
    }
    
    struct YTResourceId: Decodable {
        let kind: String
        let videoId: String
    }
    
    struct YTContentDetails: Decodable {
        let itemCount: Int?
        let videoId: String?
        let videoPublishedAt: String?
    }
    
    var mDataSource = [AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://www.googleapis.com/youtube/v3/playlists?maxResults=17&channelId=UC0lT9K8Wfuc1KPqm6YjRf1A&part=snippet%2CcontentDetails&key=\(YT_API_KEY)")

        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let error = error {
                print("Error:", error)
            }
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(YTPLResponse.self, from: data)
                print(response.etag)
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            
//            let json = try! JSONSerialization.jsonObject(with: data, options: [])
//            print(json)

        }
        
        task.resume()
        
    }
}

