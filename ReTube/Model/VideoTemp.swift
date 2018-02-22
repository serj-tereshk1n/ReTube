//
//  VideoTemp.swift
//  ReTube
//
//  Created by sergey.tereshkin on 22/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

// https://s3-us-west-2.amazonaws.com/youtubeassets/home.json

class VideoTemp: NSObject {
    
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: NSNumber?
    var uploadedDate: NSDate?
    var duration: Int?
    
    var channel: ChannelTemp?
}

class ChannelTemp: NSObject {
    
    var name: String?
    var profileImageName: String?
}
