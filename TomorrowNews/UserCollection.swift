//
//  UserCollection.swift
//  TomorrowNews
//
//  Created by Ruslan D on 14.05.17.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import Foundation

class UserCollection {
    let id: Int
    let name: String
    let logo: String
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let logo = json["logo"] as? String
            else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.logo = logo
    }
}
