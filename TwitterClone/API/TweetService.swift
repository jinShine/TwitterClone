//
//  TweetService.swift
//  TwitterClone
//
//  Created by buzz on 2020/12/20.
//

import FirebaseFirestore
import FirebaseAuth

struct TweetService {
  static let shared = TweetService()
  
  private init() {
    
  }
  
  func uploadTweet(caption: String, completion: @escaping ((Error?) -> Void)) {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    let value = [
      "uid": uid,
      "timestamp": Int(NSDate().timeIntervalSince1970),
      "likes": 0,
      "retweets": 0,
      "caption": caption
    ] as [String: Any]

    tweetsDB.document().setData(value, completion: completion)
  }
}
