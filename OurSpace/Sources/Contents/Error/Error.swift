//
//  Error.swift
//  OurSpace
//
//  Created by 승진김 on 30/01/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Foundation

enum AuthError: Error {
    case createError
    case registerdUser
}

enum DatabaseError: Error {
    case saveUserError
    case saveRoomError
}

extension AuthError: CustomStringConvertible {
    var description: String {
        switch self {
        case .createError:
            return "유저 가입 에러"
        case .registerdUser:
            return "이미 가입된 이메일 입니다."
        }
    }
}

extension DatabaseError: CustomStringConvertible {
    var description: String {
        switch self {
        case .saveUserError:
            return "데이터베이스 User저장 실패"
        case .saveRoomError:
            return "데이터베이스 Room저장 실패"
        }
    }
}
