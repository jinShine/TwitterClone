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
    
    init(email: String, id: String, pw: String) {
        self.email = email
        self.id = id
        self.pw = pw
    }
}
