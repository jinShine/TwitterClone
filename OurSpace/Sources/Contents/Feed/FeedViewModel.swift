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
import RxDataSources

typealias FeedDatas = SectionModel<String, Post>

final class FeedViewModel: Reactor {
    
    // Action is an user interaction
    enum Action {
        case fetchPosts
    }
    
    // Mutate is a state manipulator which is not exposed to a view
    enum Mutation {
        case setFetchPosts([FeedDatas])
    }
    
    // State is a current view state
    struct State {
        var fetchPostsResult: [FeedDatas] = [FeedDatas]()
    }
    
    let initialState: State = State()
    var posts: [Post] = []
    
    init() { }
    
    // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchPosts:
            return Observable.just(())
                .flatMapLatest { _ -> Observable<[Post]> in
                    return self.fetchPosts()
                }
                .map { [FeedDatas(model: "", items: $0)] }
                .map { Mutation.setFetchPosts($0) }
            
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
    
        var posts: [Post] = []
        
        return Observable.create({ (observer) -> Disposable in
            Database.database().reference().child("users").observe(DataEventType.value, with: { snapshot in
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                guard let userDictionary = snapshot.value as? [String : Any] else { return }
                guard let currentRoom = App.userDefault.object(forKey: CURRENT_ROOM) as? String else { return }
                guard let currentUser = userDictionary[uid] as? [String : Any] else { return }
                let user = User(uid: uid, dictionary: currentUser)
                
                Database.database().reference().child("posts").child(currentRoom).child(user.uid).observe(DataEventType.value, with: { snapshot in
                    guard let dictionary = snapshot.value as? [String: Any] else { return }
                    dictionary.forEach({ (key, value) in
                        guard let dictionary = value as? [String: Any] else { return }
                        var post = Post(user: user, dictionary: dictionary)
                        post.id = key
                        
                        posts.append(post)
                        posts.sort(by: { (p1, p2) -> Bool in
                            return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                        })
                        observer.onNext(posts)
                    })
                    
                }, withCancel: { error in
                    print(error.localizedDescription)
                })
            })
            
            
            
//            Database.database().reference().child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//                guard let userDictionary = snapshot.value as? [String: Any] else { return }
//
//                userDictionary.forEach({ (key, value) in
//                    guard let userDic = value as? [String: Any] else { return }
//                    let user = User(uid: key, dictionary: userDic)
//
//                    guard let currentRoom = App.userDefault.object(forKey: CURRENT_ROOM) as? String else { return }
//                    let databaseRef = Database.database().reference().child("posts").child(currentRoom).child(user.uid)
//                    databaseRef.observeSingleEvent(of: DataEventType.value, with: { snapshot in
//
//                        var comparedCount = 0
//                        guard let postValue = snapshot.value as? [String:Any] else { return }
//                        postValue.forEach({ (key, value) in
//
//                            guard let dictionary = value as? [String: Any] else { return }
//                            var post = Post(user: user, dictionary: dictionary)
//                            post.id = key
//
//                            self.posts.append(post)
//                            self.posts.sort(by: { (post1, post2) -> Bool in
//                                return post1.creationDate.compare(post2.creationDate) == .orderedDescending
//                            })
//
//                            comparedCount += 1
//                            print("compred", comparedCount)
//                            if postValue.count == comparedCount {
//                                print(" POST::", self.posts)
//                                observer.onNext(self.posts)
//                            }
//                        })
//                    }) { (error) in
//                        print("******************************************************")
//                        print(" <Failed to fetch posts:> \n\t", error)
//                        print("******************************************************")
//                    }
//                })
//            }) { (error) in
//                print("******************************************************")
//                print(" <User 정보 가져오기 실패:> \n\t", error)
//                print("******************************************************")
//            }
            
            return Disposables.create()
        })
    }
}
