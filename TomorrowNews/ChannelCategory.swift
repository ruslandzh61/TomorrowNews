//
//  ChannelCategory.swift
//  iOSPractice1
//
//  Created by Ruslan D on 13.05.17.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import Foundation

protocol ChannelSource {
    var id: Int {get set}
    var name: String {get set}
    var logo: String {get set}
    var channel: Int {get set}
}

class ChannelCategory: ChannelSource {
    var id = 0
    var name = ""
    var logo = ""
    var channel = 0
    let category: Int
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let name = json["category_name"] as? String,
            let logo = json["category_image"] as? String,
            let channel = json["following_channel"] as? Int,
            let category = json["category"] as? Int
            else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.logo = logo
        self.category = category
        self.channel = channel
    }
}
