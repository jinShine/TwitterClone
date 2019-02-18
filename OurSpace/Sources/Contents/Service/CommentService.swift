//
//  CommentService.swift
//  OurSpace
//
//  Created by 승진김 on 18/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import RxSwift
import Firebase

protocol CommentServiceType {
    func fetchComment(post: Post) -> Observable<[Comment]>
}

struct CommentService: CommentServiceType {
    
    func fetchComment(post: Post) -> Observable<[Comment]> {
        
        var comments: [Comment] = []
        return Observable.create { observer -> Disposable in
            guard let postID = post.id else {
                return observer.onError(CommentError.unknown) as! Disposable
            }
            
            guard let currentRoom = App.userDefault.object(forKey: CURRENT_ROOM) as? String else {
                
                return observer.onError(CommentError.unknown) as! Disposable
            }
            
            Database.database().reference().child("comments").child(currentRoom).child(postID).observe(DataEventType.childAdded, with: { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                Database.fetchUserWithUID(uid: uid, completion: { user in
                    let comment = Comment(user: user, dictionary: dictionary)
                    comments.append(comment)
                    observer.onNext(comments)
                })
            }, withCancel: { error in
                print(error.localizedDescription)
            })
            return Disposables.create()
        }
//        return Observable.create(subscribe: { (observer) -> Disposable in
//
//            guard let postID = post.id else {
//                return observer(.error(CommentError.unknown)) as! Disposable
//            }
//
//            guard let currentRoom = App.userDefault.object(forKey: CURRENT_ROOM) as? String else {
//                return observer(.error(CommentError.unknown)) as! Disposable
//            }
//
//            Database.database().reference().child("comments").child(currentRoom).child(postID).observe(DataEventType.childAdded, with: { snapshot in
//                guard let dictionary = snapshot.value as? [String: Any] else { return }
//                guard let uid = dictionary["uid"] as? String else { return }
//                Database.fetchUserWithUID(uid: uid, completion: { user in
//                    let comment = Comment(user: user, dictionary: dictionary)
//                    comments.append(comment)
//                    observer(.success(comments))
//                })
//            }, withCancel: { error in
//                print(error.localizedDescription)
//            })
//            return Disposables.create()
//        })
    }
    
}




//            Database.database().reference().child("comments").child(currentRoom).observeSingleEvent(of: DataEventType.childAdded, with: { snapshot in
////                guard let dictionary = snapshot.value as? [String: Any] else { return }
//                print("DICDIC", snapshot)
////                guard let uid = dictionary["uid"] as? String else { return }
////                Database.fetchUserWithUID(uid: uid, completion: { user in
////                    let comment = Comment(user: user, dictionary: dictionary)
////                    comments.append(comment)
////                    comparedInt += 1
////
////                    if comparedInt == dictionary.count {
////                        observer(.success(comments))
////                    }
////                })
//            }, withCancel: { error in
//                print(error.localizedDescription)
//            })
