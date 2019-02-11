//
//  CommentViewModel.swift
//  OurSpace
//
//  Created by 승진김 on 10/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//


import ReactorKit
import Firebase
import RxSwift

final class CommentViewModel: Reactor {
    
    // Action is an user interaction
    enum Action {
        case handleSubmit(String, Post)
        case fetchComment(Post)
    }
    
    // Mutate is a state manipulator which is not exposed to a view
    enum Mutation {
        case setHandleSubmit(Bool)
        case setFetchComment([Comment])
    }
    
    // State is a current view state
    struct State {
        var handleSubmitResult: Bool = false
        var fetchPostsResult: [Comment] = [Comment]()
    }
    
    let initialState: State = State()
    var comment = [Comment]()
    
    init() { }
    
    // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .handleSubmit(let comment, let post):
            return self.handleSumitAction(commentText: comment, post: post).map { Mutation.setHandleSubmit($0) }
        case .fetchComment(let post):
            return self.fetchComments(post: post).map { Mutation.setFetchComment($0) }
        }
    }
    
    // Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setHandleSubmit(let result):
            state.handleSubmitResult = result
            return state
            
        case .setFetchComment(let comment):
            state.fetchPostsResult = comment
            return state
        }
        
        
    }

    
}

extension CommentViewModel {
    private func handleSumitAction(commentText: String, post: Post) -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            guard let currentRoom = App.userDefault.object(forKey: CURRENT_ROOM) as? String else {
                return observer.onNext(false) as! Disposable
            }
            
            let uid = Auth.auth().currentUser?.uid
            let postId = post.id
            let values = ["text": commentText, "creationDate": Date().timeIntervalSince1970,
                          "uid": uid ?? ""] as [String : Any]
            
            Database.database().reference().child("comments").child(currentRoom).child(postId ?? "").childByAutoId().updateChildValues(values) { (error, ref) in
                if let error = error {
                    print("Failed to insert comment:", error)
                    return
                }
                
                observer.onNext(true)
                print("Success")
            }
            return Disposables.create()
        })
    }
    
    private func fetchComments(post: Post) -> Observable<[Comment]> {
        return Observable.create { (observer) -> Disposable in
            
            guard let currentRoom = App.userDefault.object(forKey: CURRENT_ROOM) as? String else {
                return observer.onNext([Comment]()) as! Disposable
            }
//            guard let postID = post.id else { return observer.onNext([Comment]()) as! Disposable }

            Database.database().reference().child("comments").child(currentRoom).observeSingleEvent(of: DataEventType.childAdded, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else { return }

                var comparedCount = 0
                dictionary.forEach({ (key, value) in
                    guard let commentValue = value as? [String : Any] else { return }
                    
                    guard let uid = commentValue["uid"] as? String else { return }
                    
                    Database.fetchUserWithUID(uid: uid, completion: { (user) in
                        let comment = Comment(user: user, dictionary: commentValue)
                        self.comment.append(comment)
                        
                        comparedCount += 1
                        if dictionary.count == comparedCount {
                            print("selfcomment",self.comment)
                            observer.onNext(self.comment)
                        }
                    })

                })
            }, withCancel: { error in
                print("Failed to observe comments")
            })
            
            return Disposables.create()
        }
    }
}

