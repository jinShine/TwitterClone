//
//  CreateRoomInfoViewModel.swift
//  OurSpace
//
//  Created by 승진김 on 29/01/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import ReactorKit
import Firebase
import RxSwift

final class CreateRoomInfoViewModel: Reactor {
    // Action is an user interaction
    enum Action {
        case emailInfo(String)
        case idInfo(String)
        case pwInfo(String)
        case confirmPwInfo((String, String))
    }
    
    // Mutate is a state manipulator which is not exposed to a view
    enum Mutation {
        case validCheckEmailResult(Bool)
        case validCheckIDResult(Bool)
        case validCheckPWResult(Bool)
        case validCheckPWs(Bool)
    }
    
    // State is a current view state
    struct State {
        var isValidEmail: Bool = false
        var isValidID: Bool = false
        var isValidPW: Bool = false
        var isPwCheck: Bool = false
    }
    
    let initialState: State = State()
    var resultOks: (Bool,Bool,Bool,Bool) = (false, false, false, false)
    
    init() { }
    
    // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .emailInfo(let email):
            return self.validCheckEmail(email).map { Mutation.validCheckEmailResult($0) }
        case .idInfo(let id):
            return self.validCheckID(id).map { Mutation.validCheckIDResult($0) }
        case .pwInfo(let pw):
            return self.validCheckPW(pw).map { Mutation.validCheckPWResult($0) }
        case .confirmPwInfo(let pw, let confirmPw):
            print("::::::",pw, confirmPw)
            guard confirmPw.count > 0 else { return Observable.just(Mutation.validCheckPWs(true))}
            guard pw == confirmPw else { return Observable.just(Mutation.validCheckPWs(true))}
            return Observable.just(Mutation.validCheckPWs(false))
        }
    }
    
    // Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .validCheckEmailResult(let result):
            resultOks.0 = !result
            state.isValidEmail = result
            
        case .validCheckIDResult(let result):
            resultOks.1 = !result
            state.isValidID = result
            
        case .validCheckPWResult(let result):
            resultOks.2 = !result
            state.isValidPW = result
            
        case .validCheckPWs(let result):
            state.isPwCheck = result
        }
        return state
    }
}

extension CreateRoomInfoViewModel {
    
    //Method
    private func validCheckEmail(_ email: String) -> Observable<Bool> {
        return Observable<Bool>.create({ (observer) -> Disposable in
            if validateEmail(email) { observer.onNext(false) }
            else { observer.onNext(true) }
            return Disposables.create()
        })
    }
    
    private func validCheckID(_ id: String) -> Observable<Bool> {
        return Observable<Bool>.create({ (observer) -> Disposable in
            if id.count >= 1 && id.count <= 20 { observer.onNext(false) }
            else { observer.onNext(true) }
            return Disposables.create()
        })
    }
    
    private func validCheckPW(_ pw: String) -> Observable<Bool> {
        return Observable<Bool>.create({ (observer) -> Disposable in
            if validatePassword(password: pw) { observer.onNext(false) }
            else { observer.onNext(true) }
            return Disposables.create()
        })
    }
    
    private func validCheckConfirmPW(_ pw: String) -> Observable<Bool> {
        return Observable<Bool>.create({ (observer) -> Disposable in
            
            return Disposables.create()
        })
    }
    
}
