//
//  UserService.swift
//  TwitterClone
//
//  Created by buzz on 2020/12/18.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct UserService {
  static let shared = UserService()
  
  private init() {
    
  }
  
  func fetchUser(uid: String, completion: @escaping (User) -> Void) {
    usersDB.document(uid).getDocument { (snapshot, error) in
      if let error = error {
        print("Error is \(error.localizedDescription)")
        return
      }

      guard let results = snapshot?.data() else { return }
      
      let user = User(uid: uid, dictionary: results)
      print("DEBUG: Username is \(user)")
      completion(user)
    }
  }
}
