//
//  UserProfileService.swift
//  OurSpace
//
//  Created by 승진김 on 22/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import RxSwift
import Firebase

protocol UserProfileService {
    func fetchUserProfileData() -> Observable<Void>
}
