//
//  CreateRoomViewModel.swift
//  OurSpace
//
//  Created by 승진김 on 27/01/2019.
//  Copyright © 2019 승진김. All rights reserved.
//


import ReactorKit
import Firebase
import RxSwift

final class CreateRoomViewModel: Reactor {
    
    enum Action {
        case validSpaceName(String)
    }

    enum Mutation {
        case isSpaceNameCheck(Bool)
        case setLoading(Bool)
    }

    struct State {
        var isSpaceName: Bool = false
        var isLoading: Bool = false
    }
    
    var initialState: CreateRoomViewModel.State = State()
    
    // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .validSpaceName(let name):
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                self.validSpaceName(spaceName: name).map { Mutation.isSpaceNameCheck($0) },
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }
    
    // Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .isSpaceNameCheck(let isValue):
            state.isSpaceName = isValue
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        }
        return state
    }
    
    private func validSpaceName(spaceName: String) -> Observable<Bool> {
        return Observable<Bool>.create({ (observer) -> Disposable in
            
            Database.database().reference().child("spaceNames").observeSingleEvent(of: DataEventType.value) { (snapshot) in
                
                guard let value = snapshot.value as? [String : Any] else { return observer.onNext(false) }
                guard let finedSpaceName = value[spaceName] as? String else { return observer.onNext(false) }
                
                print("******************************************************")
                print(" <validSpaceName> \n\t", finedSpaceName)
                print("******************************************************")
                
                for (_, element) in value.enumerated() {
                    if element.key == spaceName {
                        return observer.onNext(false)
                    }
                    observer.onNext(true)
                }
                observer.onCompleted()
            }
            
            return Disposables.create()
        })
    }
}
