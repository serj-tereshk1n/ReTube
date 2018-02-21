//
//  YTAPI.swift
//  ReTube
//
//  Created by sergey.tereshkin on 21/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import Foundation

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
