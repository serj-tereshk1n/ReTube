//
//  VideoTemp.swift
//  ReTube
//
//  Created by sergey.tereshkin on 22/02/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

class VideoTemp: NSObject {
    
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: NSNumber?
    var uploadedDate: NSDate?
    
    var channel: ChannelTemp?
    
}

class ChannelTemp: NSObject {
    
    var name: String?
    var profileImageName: String?
}
