//
//  AddPostViewModel.swift
//  OurSpace
//
//  Created by 승진김 on 01/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import ReactorKit
import Firebase
import RxSwift

final class AddPostViewModel: Reactor {
    // Action is an user interaction
    enum Action {
        
    }
    
    // Mutate is a state manipulator which is not exposed to a view
    enum Mutation {
        
    }
    
    // State is a current view state
    struct State {
        
    }
    
    let initialState: State = State()
    
    init() { }
    
    // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        }
    }
    
    // Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
            
        }
        return state
    }
}

extension AddPostViewModel {
    
}
