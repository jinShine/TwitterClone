//
//  PhotoSelectorViewModel.swift
//  OurSpace
//
//  Created by 승진김 on 02/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//


import ReactorKit
import Firebase
import RxSwift
import Photos

final class PhotoSelectorViewModel: Reactor {
    // Action is an user interaction
    enum Action {
        case photoInfo([UIImage])
    }
    
    // Mutate is a state manipulator which is not exposed to a view
    enum Mutation {
        case photoImage([UIImage])
    }
    
    // State is a current view state
    struct State {
        var images: [UIImage] = []
    }
    
    let initialState: State = State()
    
    init() { }
    
    // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .photoInfo(let images):
            return Observable.concat([
                    Observable.just(images).map { Mutation.photoImage($0)}
                ])
        }
    }
    
    // Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .photoImage(let images):
            state.images = images
            return state
        }
    }
}

extension PhotoSelectorViewModel {
    
}
