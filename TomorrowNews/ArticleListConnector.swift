//
//  FeedAPI.swift
//  iOSPractice1
//
//  Created by Ruslan D on 18.04.17.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import UIKit
import Alamofire

class ArticleListConnector {
    
    func loadArticlesByFeed(params: [String: String], isPersonalized: Bool,
                completionHandler: @escaping (_ articles: [Article]) -> ()) {
        var articlesArray = [Article]()
        var urlString = ""
        if isPersonalized {
            urlString = "http://localhost:8000/newsfeed/api/v1/categoryrecommendation"
        } else {
            urlString = "http://localhost:8000/newsfeed/api/v1/categoryarticles"
        }
        Alamofire.request(URL(string: urlString)!, method: .get, parameters: params).validate().responseJSON { response in
            
            guard response.result.isSuccess else {
                print("Error while fetching articles: \(response.result.error)")
                return
            }
            
            if let value = response.result.value {
                if let articleArray = value as? [Any] {
                    for articleJSON in articleArray {
                        let article = Article(json: articleJSON as! [String: Any])
                        if article != nil {
                            articlesArray.append(article!)
                        }
                    }
                }
                print("load articles json: success")
            }
            DispatchQueue.main.async {
                print("successfully loaded with Alamofire")
                completionHandler(articlesArray)
            }
        }
    }
    
    func loadRelatedArticles(params: [String: String],
            completionHandler: @escaping (_ articles: [Article]) -> ()) {
        var articlesArray = [Article]()
        let queue = DispatchQueue(label: "response-queue", qos: .utility, attributes: [.concurrent])
        Alamofire.request(URL(string: "http://localhost:8000/newsfeed/api/v1/relatedarticles")!, method: .get, parameters: params).validate().responseJSON(queue: queue, completionHandler: { response in
            
            guard response.result.isSuccess else {
                print("Error while fetching articles: \(response.result.error)")
                return
            }
            
            if let value = response.result.value {
                if let articleArray = value as? [Any] {
                    for articleJSON in articleArray {
                        let article = Article(json: articleJSON as! [String: Any])
                        if article != nil {
                            articlesArray.append(article!)
                        }
                    }
                }
                
            }
            DispatchQueue.main.async {
                print("successfully loaded with Alamofire")
                completionHandler(articlesArray)
            }
        })
    }
}
