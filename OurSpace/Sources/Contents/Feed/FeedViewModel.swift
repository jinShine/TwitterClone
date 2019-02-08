//
//  FeedViewModel.swift
//  OurSpace
//
//  Created by 승진김 on 31/01/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import ReactorKit
import Firebase
import RxSwift

final class FeedViewModel: Reactor {
    
    // Action is an user interaction
    enum Action {
        case fetchPosts
//        case likeSelected(FeedCell, Int)
    }
    
    // Mutate is a state manipulator which is not exposed to a view
    enum Mutation {
        case setFetchPosts([Post])
    }
    
    // State is a current view state
    struct State {
        var fetchPostsResult: [Post]?
    }
    
    let initialState: State = State()
    var posts: [Post] = []
    
    init() { }
    
    // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchPosts:
            return Observable.concat([
                self.fetchPosts().map { Mutation.setFetchPosts($0) }
            ])
            
//        case .likeSelected(let cell, let indexPathItem):
//            self.likeHandle(cell: cell, indexPathItem: indexPathItem)
            
        }
    }
    
    // Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setFetchPosts(let post):
            state.fetchPostsResult = post
        return state
        }
        
    }
}

extension FeedViewModel {
    private func fetchPosts() -> Observable<[Post]> {
        return Observable<[Post]>.create({ (observer) -> Disposable in
            
            Database.database().reference().child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                guard let userDictionary = snapshot.value as? [String: Any] else { return }

                userDictionary.forEach({ (key, value) in
                    guard let userDic = value as? [String: Any] else { return }
                    let user = User(uid: key, dictionary: userDic)
                    
                    guard let currentRoom = App.userDefault.object(forKey: CURRENT_ROOM) as? String else { return }
                    let databaseRef = Database.database().reference().child("posts").child(currentRoom).child(user.uid)
                    databaseRef.observeSingleEvent(of: DataEventType.value, with: { snapshot in

                        var comparedCount = 0
                        guard let postValue = snapshot.value as? [String:Any] else { return }
                        postValue.forEach({ (key, value) in
                
                            guard let dictionary = value as? [String: Any] else { return }
                            var post = Post(user: user, dictionary: dictionary)
                            post.id = key
                            
                            guard let uid = Auth.auth().currentUser?.uid else { return }
                            Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                                
                                guard let likeValue = snapshot.value as? Int else { return }

                                if likeValue == 1 {
                                    post.hasLiked = true
                                } else {
                                    post.hasLiked = false
                                }
                            
                                self.posts.append(post)
                                self.posts.sort(by: { (post1, post2) -> Bool in
                                    return post1.creationDate.compare(post2.creationDate) == .orderedDescending
                                })
                                
                                comparedCount += 1
                                if postValue.count == comparedCount {
                                    print("", self.posts)
                                    observer.onNext(self.posts)
                                }
                            })

                        })
                    }) { (error) in
                        print("******************************************************")
                        print(" <Failed to fetch posts:> \n\t", error)
                        print("******************************************************")
                    }
                })
            }) { (error) in
                print("******************************************************")
                print(" <User 정보 가져오기 실패:> \n\t", error)
                print("******************************************************")
            }
            
            return Disposables.create()
        })
    }
    
    func likeHandle(cell: FeedCell, indexPathItem: Int) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var post = self.posts[indexPathItem]
        
        let value = [uid: post.hasLiked == true ? 0 : 1]
        Database.database().reference().child("likes").child(post.id ?? "").updateChildValues(value , withCompletionBlock: { (error, _) in
            if let error = error {
                print("Error", error)
                return
            }

            post.hasLiked == true ? cell.likeButton.setImage(UIImage(named: "Emoji_Heart"), for: .normal) : cell.likeButton.setImage(UIImage(named: "Emoji_Normal"), for: .normal)
            
            post.hasLiked = !post.hasLiked
            self.posts[indexPathItem] = post
            
            print("success like")
        })
    }
}
