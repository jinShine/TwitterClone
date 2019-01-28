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
    }

    struct State {
        var isSpaceName: Bool = false
    }
    
    var initialState: CreateRoomViewModel.State = State()
    
    // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .validSpaceName(let name):
            return Observable.concat([
                self.validSpaceName(name).map { Mutation.isSpaceNameCheck($0) }
            ])
        }
    }
    
    // Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .isSpaceNameCheck(let isValue):
            state.isSpaceName = isValue
            return state
        }
    }
    
    // Method
    private func validSpaceName(_ name: String) -> Observable<Bool> {
        return Observable<Bool>.create({ (observer) -> Disposable in
            
            Database.database().reference().child("spaceNames").observeSingleEvent(of: DataEventType.value) { (snapshot) in
                
                guard let value = snapshot.value as? [String : Any] else { return observer.onNext(false) }
                guard let finedSpaceName = value[name] as? String else { return observer.onNext(false) }
                
                print("******************************************************")
                print(" <validSpaceName> \n\t", finedSpaceName)
                print("******************************************************")
                
                for (_, element) in value.enumerated() {
                    if element.key == name {
                        observer.onNext(true)
                        observer.onCompleted()
                        return
                    }
                }
                
                observer.onNext(false)
                return
            }
            
            return Disposables.create()
        })
    }
}
