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
        case createRoomInfo((CreateRoom, User))
    }
    
    // Mutate is a state manipulator which is not exposed to a view
    enum Mutation {
        case validCheckEmailResult(Bool)
        case validCheckIDResult(Bool)
        case validCheckPWResult(Bool)
        case validCheckPWs(Bool)
        case createRoomResult((Bool, CreateRoom))
        case activationButton(Bool)
        case setErrorMessage(String)
    }
    
    // State is a current view state
    struct State {
        var isValidEmail: Bool = false
        var isValidID: Bool = false
        var isValidPW: Bool = false
        var isPwCheck: Bool = false
        var isCreateRoom: (Bool, CreateRoom) = (false, CreateRoom())
        var errorMessage: String = ""
        var activationState: Bool = false
    }
    
    let initialState: State = State()
    var resultOks: PublishSubject<(Bool,Bool,Bool,Bool)> = PublishSubject()
    
    init() { }
    
    // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
//        case .login:
//        let setLoading: Observable<Mutation> = .just(Mutation.setLoading(true))
//        let setLoggedIn: Observable<Mutation> = self.authService.authorize()
//            .asObservable()
//            .flatMap { self.userService.fetchMe() }
//            .map { true }
//            .catchErrorJustReturn(false)
//            .map(Mutation.setLoggedIn)
//        return setLoading.concat(setLoggedIn)
        switch action {
        case .emailInfo(let email):
            return self.validCheckEmail(email).map { Mutation.validCheckEmailResult($0) }
        case .idInfo(let id):
            return self.validCheckID(id).map { Mutation.validCheckIDResult($0) }
        case .pwInfo(let pw):
            return self.validCheckPW(pw).map { Mutation.validCheckPWResult($0) }
        case .confirmPwInfo(let pw, let confirmPw):
            guard confirmPw.count > 0 else { return Observable.just(Mutation.validCheckPWs(true))}
            guard (pw == confirmPw) && validatePassword(password: confirmPw) else { return Observable.just(Mutation.validCheckPWs(true))}
            
            return Observable.just(Mutation.validCheckPWs(false))
        case .createRoomInfo((let createRoom, let user)):
            
                let signAndCreate = self.signupAndCreateRoom(createRoom, user)
                    .map { Mutation.createRoomResult(($0.0, $0.1)) }
                    .catchError({ error -> Observable<CreateRoomInfoViewModel.Mutation> in
                        guard let error = error as? AuthError else { return .empty() }
                        return Observable<Mutation>.just(.setErrorMessage(error.description))
                    })
            return Observable.concat([signAndCreate])
            
            
        }
    }
    
    // Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .validCheckEmailResult(let result):
            resultOks.onNext((!result, false, false, false))
            state.isValidEmail = result
            return state
            
        case .validCheckIDResult(let result):
            resultOks.onNext((!result, !result, false, false))
            state.isValidID = result
            return state
            
        case .validCheckPWResult(let result):
            resultOks.onNext((!result, !result, !result, false))
            state.isValidPW = result
            return state
            
        case .validCheckPWs(let result):
            resultOks.onNext((!result, !result, !result, !result))
            state.isPwCheck = result
            return state
            
        case .createRoomResult((let result, let createRoom)):
            state.isCreateRoom = (result, createRoom)
            return state
            
        case .setErrorMessage(let errorMessage):
            state.errorMessage = errorMessage
            return state
            
        case .activationButton(let result):
            state.activationState = result
            return state
        }
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
    
    private func signupAndCreateRoom(_ createRoomModel: CreateRoom, _ userModel: User ) -> Observable<(Bool, CreateRoom)> {
        return Observable<(Bool, CreateRoom)>.create({ (observer) -> Disposable in
            
            Auth.auth().createUser(withEmail: userModel.email ?? "", password: userModel.pw ?? "", completion: { (user, error) in
                if let error = (error as NSError?) {
                    print("******************************************************")
                    print(" <Create User Error> \n\t", error)
                    print("******************************************************")
                    
                    if error.code == 17007 { observer.onError(AuthError.registerdUser) }
                    else { observer.onError(AuthError.createError) }
                    
                    return
                }
                
                print("******************************************************")
                print(" <회원 가입 성공> \n\t", user?.user.uid ?? "")
                print("******************************************************")
                
                let inputValue = [
                    "email": userModel.email,
                    "id": userModel.id,
                    "rooms": ["room": createRoomModel.spaceRoomName]
                    ] as [String : Any]
                guard let uid = user?.user.uid else { return }
                
                let values = [uid: inputValue]
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, ref) in
                    
                    if let error = error {
                        print("******************************************************")
                        print(" <Database에 User 저장 실패> \n\t", error)
                        print("******************************************************")
                        
                        observer.onError(DatabaseError.saveUserError)
                        return
                    }
                    
                    print("******************************************************")
                    print(" <Database에 User 저장 성공>")
                    print("******************************************************")
                    
                    let roomValue = [createRoomModel.spaceRoomName: createRoomModel.spaceRoomPw]
                    Database.database().reference().child("rooms").updateChildValues(roomValue, withCompletionBlock: { (error, ref) in
                        
                        if let error = error {
                            print("******************************************************")
                            print(" <Database에 Room 저장 실패> \n\t", error)
                            print("******************************************************")
                            
                            observer.onError(DatabaseError.saveRoomError)
                            return
                        }
                        
                        print("******************************************************")
                        print(" <Database에 User 저장 성공>")
                        print("******************************************************")
                        
                        
                        observer.onNext((true, createRoomModel))
                        observer.onCompleted()
                    })
                })
                
                
            })
            return Disposables.create()
        })
    }
    
}
