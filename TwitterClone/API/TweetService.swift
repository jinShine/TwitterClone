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
      "timestamp": Date().timeIntervalSince1970,
      "likes": 0,
      "retweets": 0,
      "caption": caption
    ] as [String: Any]

    tweetsDB.document().setData(value, completion: completion)
  }
  
  func fetchTweets(completion: @escaping ([Tweet]) -> Void) {

    // 추가될때마다 데이터를 가져온다
    tweetsDB.addSnapshotListener { (snapshot, erorr) in
      guard let documents = snapshot?.documents else { return }
      
      let tweets = documents.map { document -> Tweet in
        let tweetID = document.documentID
        let uid = document.data()["uid"]
        return Tweet(tweetID: tweetID, dictionary: document.data())
      }
      
      completion(tweets)
      
    }
  }
}
