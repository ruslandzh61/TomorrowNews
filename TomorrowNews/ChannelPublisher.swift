//
//  ChannelPublisher.swift
//  TomorrowNews
//
//  Created by Ruslan D on 14.05.17.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import Foundation

class ChannelPublisher: ChannelSource {
    var id = 0
    var name = ""
    var logo = ""
    var channel = 0
    let publisher: Int
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let name = json["publisher_name"] as? String,
            let logo = json["publisher_logo"] as? String,
            let channel = json["following_channel"] as? Int,
            let publisher = json["publisher"] as? Int
            else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.logo = logo
        self.publisher = publisher
        self.channel = channel
    }
}
