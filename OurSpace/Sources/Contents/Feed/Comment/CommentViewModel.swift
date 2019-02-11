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
        case handleSubmit(String)
    }
    
    // Mutate is a state manipulator which is not exposed to a view
    enum Mutation {
        case setHandleSubmit
    }
    
    // State is a current view state
    struct State {
        
    }
    
    let initialState: State = State()
    
    init() { }
    
    // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .handleSubmit(let comment):
            Observable.filter(<#T##Observable<_>#>)
            
        }
    }
    
    // Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
            
            
            
        }
        return state
        
    }
    
    func handleSumitAction(commentText: String) -> Bool {
        guard let currentRoom = App.userDefault.object(forKey: CURRENT_ROOM) as? String else { return }
        let postId = "temporaryPostId"
        let values = ["text": commentText]
        
        Database.database().reference().child("comments").child(currentRoom).child(postId).updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Failed to insert comment:", error)
                return
            }
            
            print("Success")
        }
        return true
    }
}

extension CommentViewModel {
    
}

