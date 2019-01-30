//
//  CreateRoom.swift
//  OurSpace
//
//  Created by 승진김 on 30/01/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Foundation

struct CreateRoom {
    var spaceRoomName: String = ""
    var spaceRoomPw: String = ""
    
    init() {
        spaceRoomName = ""
        spaceRoomPw = ""
    }
    
    init (spaceRoomName: String, spaceRoomPw: String) {
        self.spaceRoomName = spaceRoomName
        self.spaceRoomPw = spaceRoomPw
    }
}
