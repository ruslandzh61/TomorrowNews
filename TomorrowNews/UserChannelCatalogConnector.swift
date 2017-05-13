//
//  UserChannelCatalogPersistencyManager.swift
//  iOSPractice1
//
//  Created by Ruslan D on 18.04.17.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import UIKit
import Alamofire

class UserChannelCatalogConnector {
    
    // so far simply all categories in db, channelCollectioviewController
    func load(params: [String: String],
            completionHandler: @escaping (_ articles: [Channel]) -> ()) {
        var categoriesArray = [Channel]()
        var urlString = ""
        urlString = "http://localhost:8000/newsfeed/api/v1/channels"
        let queue = DispatchQueue(label: "response-queue", qos: .utility, attributes: [.concurrent])
        Alamofire.request(URL(string: urlString)!, method: .get, parameters: params).validate().responseJSON(queue: queue, completionHandler: { response in
            
            guard response.result.isSuccess else {
                print("Error while fetching articles: \(response.result.error)")
                return
            }
            
            if let value = response.result.value {
                if let articleArray = value as? [Any] {
                    print("all categories: \(articleArray)")
                    for articleJSON in articleArray {
                        // access all objects in array
                        let channel = Channel(json: articleJSON as! [String: Any])
                        if channel != nil {
                            categoriesArray.append(channel!)
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                completionHandler(categoriesArray)
            }
        })
    }
}
