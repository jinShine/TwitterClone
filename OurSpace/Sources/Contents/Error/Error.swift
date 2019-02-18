//
//  Error.swift
//  OurSpace
//
//  Created by 승진김 on 30/01/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Foundation

//MARK:- Auth Error
enum AuthError: Error {
    case createError
    case registerdUser
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

//MARK:- Database Error
enum DatabaseError: Error {
    case saveUserError
    case saveRoomError
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

//MARK:- CommentError
enum CommentError: Error {
    case unknown
}

extension CommentError: CustomStringConvertible {
    var description: String {
        switch self {
        case .unknown:
            return "unknown"
        }
    }
}



