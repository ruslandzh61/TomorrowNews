//
//  User.swift
//  iOSPractice1
//
//  Created by Ruslan D on 06.04.17.
//  Copyright © 2017 Ruslan D. All rights reserved.
//

import Foundation

class User {
    var uid: String?
    var name: String?
    var email: String?
    var pictureURL: String?
    var isChanged = false
    static let shared = User()
    
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    func update(uid: String, name: String, email: String, picture: String) {
        self.uid = uid
        self.name = name
        self.email = email
        self.pictureURL = picture
        self.isChanged = true
    }
}
