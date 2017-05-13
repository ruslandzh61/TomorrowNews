//
//  Article.swift
//  iOSPractice1
//
//  Created by Ruslan D on 20/03/2017.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import Foundation

struct Article: Hashable {
    let id: Int
    let url: String
    let top_image: String?
    let title: String
    let date: Date?
    let text: String
    let summary: String
    let feed: Int
    let publisherName: String
    let publisherLogo: String?
    
    var description: String { return "Article: \(url) \(title)" }
    
    var hashValue: Int {
        return self.id
    }
    
    static func ==(lhs: Article, rhs: Article) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Article {
    init?(json: [String: Any]) {
        let dateFor: DateFormatter = DateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let id = json["id"] as? Int,
            let url = json["url"] as? String,
            let top_image = json["top_image"] as? String?,
            let title = json["title"] as? String,
            let text = json["text"] as? String,
            let dateStr = json["date"] as? String?,
            let summary = json["summary"] as? String,
            let feed = json["feed_id"] as? Int,
            let publisherLogo = json["publisher_logo"] as? String?,
            let publisherName = json["publisher_name"] as? String
        else {
            return nil
        }
        if dateStr != nil {
            let date = dateFor.date(from: dateStr!)
            self.date = date
        } else {
            self.date = nil
        }
        
        self.id = id
        self.url = url
        self.top_image = top_image
        self.title = title
        self.text = text
        self.summary = summary
        self.feed = feed
        self.publisherLogo = publisherLogo
        self.publisherName = publisherName
    }
}
