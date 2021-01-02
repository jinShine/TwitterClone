//
//  ProfileHeaderViewModel.swift
//  TwitterClone
//
//  Created by buzz on 2020/12/31.
//

import UIKit
import Firebase

enum ProfileFilterOptions: Int, CaseIterable {
  case tweets
  case replies
  case likes
  
  var description: String {
    switch self {
    case .tweets: return "Tweets"
    case .replies: return "Tweets & Replies"
    case .likes: return "Likes"
    }
  }
}


struct ProfileHeaderViewModel {
  
  private let user: User
  
  var followerString: NSAttributedString? {
    return attributedText(withValue: 0, text: "followers")
  }
  
  var followingString: NSAttributedString? {
    return attributedText(withValue: 0, text: "following")
  }
  
  var actionButtonTitle: String {
    if user.isCurrentUser {
      return "Edit Profile"
    } else {
      return "Follow"
    }
  }
  
  init(user: User) {
    self.user = user
  }
  
  private func attributedText(withValue value: Int, text: String) -> NSAttributedString {
    let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                    attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
    attributedTitle.append(NSAttributedString(string: " \(text)",
                                              attributes: [
                                                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                                                NSAttributedString.Key.foregroundColor: UIColor.lightGray
                                              ]))
    
    return attributedTitle
  }
  
}
