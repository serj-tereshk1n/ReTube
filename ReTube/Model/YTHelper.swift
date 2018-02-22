//
//  YTHelper.swift
//  ReTube
//
//  Created by sergey.tereshkin on 21/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import Foundation

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

class YTHelper: NSObject {
    
    //        let url = URL(string: "https://www.googleapis.com/youtube/v3/playlists?maxResults=17&channelId=UC0lT9K8Wfuc1KPqm6YjRf1A&part=snippet%2CcontentDetails&key=\(YT_API_KEY)")
    //
    //        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
    //
    //            if let error = error {
    //                print("Error:", error)
    //            }
    //            guard let data = data else { return }
    //
    //            do {
    //                let response = try JSONDecoder().decode(YTPLResponse.self, from: data)
    //                print(response.etag)
    //            } catch let jsonErr {
    //                print("Error serializing json:", jsonErr)
    //            }
    //
    ////            let json = try! JSONSerialization.jsonObject(with: data, options: [])
    ////            print(json)
    //
    //        }
    //
    //        task.resume()
    
}
