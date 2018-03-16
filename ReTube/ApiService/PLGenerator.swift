//
//  PLGenerator.swift
//  ReTube
//
//  Created by sergey.tereshkin on 15/03/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class PLGenerator: NSObject {

    enum ListType: Int {
        case yt = 5, related = 3
    }
    
    static let sharedInstance = PLGenerator()
    
    var type: ListType?
    var nextPageToken: String?
    var ytpl: YTPlayList? {
        didSet {
            if ytpl != nil {
                type = .yt
                nextPageToken = nil
            }
        }
    }
    var videoId: String? {
        didSet {
            if  videoId != nil {
                type = .related
                nextPageToken = nil
            }
        }
    }
    
    func nextPage(completion: @escaping (STPlayList) -> ()) {
        if let t = type {
            switch t {
            case .related:
                break;
            case .yt:
                if let pl = ytpl {
                    
                    ApiService.sharedInstance.playListItemsNextPage(id: pl.id, nextPageToken: nextPageToken, completion: { (resp) in
                        self.nextPageToken = resp.nextPageToken
                        let list = STPlayList(title: pl.snippet.title, items: resp.items)
                        completion(list)
                    })
                    
                }
                break;
            }
        } else {
            print("PLGenerator error type not set")
        }
    }
}
