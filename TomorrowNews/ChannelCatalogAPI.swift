//
//  ChannelCatalog.swift
//  iOSPractice1
//
//  Created by Ruslan D on 19.04.17.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import UIKit

class ChannelCatalogAPI: NSObject {
    private let persistenceManager: UserChannelCatalogManager
    private let connector: UserChannelCatalogConnector
    
    class var shared: ChannelCatalogAPI {
        struct Singleton {
            static let instance = ChannelCatalogAPI()
        }
        return Singleton.instance
    }
    
    override private init() {
        persistenceManager = UserChannelCatalogManager()
        connector = UserChannelCatalogConnector()
        
        super.init()
    }
    
    func load(params: [String: String],
              completionHandlerForUI: @escaping () -> ()) {
        connector.load(params: params, completionHandler: {
            channels in
            
            self.persistenceManager.add(channels: channels)
            completionHandlerForUI()
        })
    }
    
    func get() -> [Channel] {
        return persistenceManager.get()
    }
}
