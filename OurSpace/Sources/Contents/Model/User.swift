//
//  User.swift
//  OurSpace
//
//  Created by 승진김 on 30/01/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Foundation

struct User {
    
    var email: String = ""
    var id: String = ""
    var pw: String = ""
    var uid: String = ""
//    var username: String = ""
    var profileImageUrl: String = ""
    var rooms: [String]
    
    init(uid: String? = "", dictionary: [String: Any]? = ["":""]) {
        self.uid = uid ?? ""
        self.email = dictionary?["email"] as? String ?? ""
        self.id = dictionary?["id"] as? String ?? ""
        self.pw = dictionary?["pw"] as? String ?? ""
//        self.username = dictionary?["username"] as? String ?? ""
        self.profileImageUrl = dictionary?["profileImageUrl"] as? String ?? ""
        self.rooms = dictionary?["rooms"] as? [String] ?? []
    }
}
