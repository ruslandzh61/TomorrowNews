//
//  UserChannelCatalogPersistenceManager.swift
//  iOSPractice1
//
//  Created by Ruslan D on 18.04.17.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import UIKit

class UserChannelCatalogManager {
    
    private var channels = [Channel]()
    //newShape.dynamicType.className() // "Square"
    //newShape.dynamicType.className() == Square.className() // true
    
    func get() -> [Channel] {
        return channels
    }
    
    func add(channel: Channel, index: Int = -1) {
        if (channels.count >= index && index >= 0) {
            channels.insert(channel, at: index)
        } else {
            channels.append(channel)
        }
    }
    
    func add(channels: [Channel]) {
        self.channels.removeAll()
        self.channels.append(contentsOf: channels)
    }
    
    //at - index
    func remove(at: Int) {
        channels.remove(at: at)
    }
}
