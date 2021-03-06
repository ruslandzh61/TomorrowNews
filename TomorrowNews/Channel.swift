//
//  Channel.swift
//  iOSPractice1
//
//  Created by Ruslan D on 13.05.17.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

class Channel {
    let id: Int
    let user: Int
    let name: String
    let logo: String
    let isSystemChannel: Bool
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let user = json["user"] as? Int,
            let name = json["name"] as? String,
            let isSystemChannel = json["is_system_channel"] as? Bool,
            let logo = json["logo"] as? String
            else {
                return nil
        }
        
        self.id = id
        self.user = user
        self.name = name
        self.isSystemChannel = isSystemChannel
        self.logo = logo
    }
}
