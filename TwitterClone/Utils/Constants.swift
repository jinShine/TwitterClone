//
//  Constants.swift
//  TwitterClone
//
//  Created by buzz on 2020/12/16.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage

let firestore = Firestore.firestore()
let usersDB = firestore.collection("users")
let tweetsDB = firestore.collection("tweets")

let storage = Storage.storage().reference()
let profileStorage = storage.child("profile_images")
