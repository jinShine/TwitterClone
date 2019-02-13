//
//  Comment.swift
//  OurSpace
//
//  Created by 승진김 on 11/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Foundation

struct Comment {
    
    var user: User
    var text: String
    var uid: String
    var creationDate: Date?
    
    init(user: User, dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.user = user
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
    
    init() {
        self.text = ""
        self.uid = ""
        self.user = User()
    }
}
