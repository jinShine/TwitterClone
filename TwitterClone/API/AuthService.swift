//
//  AuthService.swift
//  TwitterClone
//
//  Created by buzz on 2020/12/17.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct AuthCredentials {
  let email: String
  let password: String
  let fullname: String
  let username: String
  let profileImage: UIImage
}

struct AuthService {
  static let shared = AuthService()
  
  private init() {
    
  }
  
  func logUserIn(withEmail email: String, password: String,
                 completion: ((AuthDataResult?, Error?) -> Void)?) {
    Auth.auth().signIn(withEmail: email, password: password, completion: completion)
  }
  
  func registerUser(credentials: AuthCredentials, completion: @escaping (Error?) -> Void) {
    
    guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
    let fileName = UUID().uuidString
    let storage = profileStorage.child(fileName)
    
    storage.putData(imageData, metadata: nil) { (metadata, error) in
      if let error = error {
        print("DEBUG: Error is \(error.localizedDescription)")
        return
      }
      
      storage.downloadURL { (url, error) in
        guard let profileImageURL = url?.absoluteString else { return }
        
        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
          if let error = error {
            print("DEBUG: Error is \(error.localizedDescription)")
            return
          }
          
          guard let uid = result?.user.uid else { return }
          
          usersDB.document(uid)
            .setData([
              "email": credentials.email,
              "fullname": credentials.fullname,
              "username": credentials.username,
              "profileImageURL": profileImageURL
            ], completion: completion)
          
          print("DEBUG: Successfully registered user")
        }
      }
    }
    
  }
}
