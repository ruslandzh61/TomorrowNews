//
//  Category.swift
//  iOSPractice1
//
//  Created by Ruslan D on 27/03/2017.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import Foundation


//singleton containing dictionary, hash computed with id and enum or with generated id, counter static

class Category {
    let id: Int
    let name: String
    var parent: Int?
    
    var description: String { return "Category: \(name)" }
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
        let name = json["name"] as? String
        else {
            return nil
            
        }
        
        self.id = id
        self.name = name
        self.parent = nil
        let par = try json["parent"] as? Int?
        if par != nil {
            self.parent = par!
        }
    }
}
