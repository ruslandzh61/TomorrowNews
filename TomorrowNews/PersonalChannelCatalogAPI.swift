//
//  UserChannelCatalogAPI.swift
//  iOSPractice1
//
//  Created by Ruslan D on 19.04.17.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import UIKit

//not singleton because there are user catalog and catalog of all categories
class PersonalChannelCatalogAPI: NSObject {
    private let persistenceManager: UserChannelCatalogManager
    private let connector: UserChannelCatalogConnector
    
    class var shared: PersonalChannelCatalogAPI {
        struct Singleton {
            static let instance = PersonalChannelCatalogAPI()
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
    
    func add(channel: Channel, at: Int = -1) {
        persistenceManager.add(channel: channel, index: at)
        //connector.add(channel)
    }
    
    func remove(at: Int) {
        persistenceManager.remove(at: at)
        //connector.remove(at: at)
    }
}
