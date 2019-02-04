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
        case handleShare(String, [UIImage])
        case isPostEnable(String)
    }
    
    // Mutate is a state manipulator which is not exposed to a view
    enum Mutation {
        case handleSharePost(Bool)
        case postEnable(Bool)
    }
    
    // State is a current view state
    struct State {
        var isShareResult: Bool = false
        var isPostEnableResult: Bool = false
    }
    
    let initialState: State = State()
    
    init() { }
    
    // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .handleShare(let contents, let images):
            return handlePostAction(contents, images).map { Mutation.handleSharePost($0) }
            
        case .isPostEnable(let content):
            return Observable.just(content)
                .map({ content -> Bool in
                    guard content.count > 0 else {
                        return false
                    }
                    return true
                })
                .map { Mutation.postEnable($0) }
                
        }
    }
    
    // Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .handleSharePost(let result):
            state.isShareResult = result
            return state
        case .postEnable(let result):
            state.isPostEnableResult = result
            return state
        }
        
    }
}

extension AddPostViewModel {
    private func handlePostAction(_ content: String, _ images: [UIImage]) -> Observable<Bool> {
        return Observable<Bool>.create { (observer) -> Disposable in
            
            var comparedCount = 0
            var imageURLs: [String] = []
            
            if images.count > 0 {
                images.enumerated().forEach  {

                    guard let data = $0.element.jpegData(compressionQuality: 0.5) else { return }
                    
                    let fileName = NSUUID().uuidString
                    let storageRef = Storage.storage().reference().child("posts").child(fileName)
                    storageRef.putData(data, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            print("******************************************************")
                            print(" <이미지 업로드 실패> \n\t")
                            print("******************************************************")
                            observer.onNext(false)
                            return
                        }
                        storageRef.downloadURL(completion: { (downloadURL, err) in
                            if let error = error {
                                print("******************************************************")
                                print(" <이미지 URL 다운로드 에러> \n\t", error)
                                print("******************************************************")
                                observer.onNext(false)
                                return
                            }
                            
                            guard let imageURL = downloadURL else { return }
                            print("******************************************************")
                            print(" <Share 이미지 업로드 성공> \n\t", imageURL)
                            print("******************************************************")
                            
                            //데이터베이스에 url저장
                            imageURLs.append(imageURL.absoluteString)
                            comparedCount += 1
                            
                            if images.count == comparedCount {
                                self.saveToDatabaseWithImageUrl(imageUrls: imageURLs, content: content)
                                observer.onNext(true)
                            }
                        })
                    })
                }
            } else {
                self.saveToDatabaseWithImageUrl(imageUrls: nil, content: content)
                observer.onNext(true)
            }

            return Disposables.create()
        }
    }
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrls: [String]?, content: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        

        let values = ["imageUrls": imageUrls ?? "", "caption": content, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(values) { (error, ref) in
            if let error = error {
                
                print("******************************************************")
                print(" <저장 이미지 데이터베이스에 저장 실패> \n\t", error)
                print("******************************************************")
                return
            }
            
            print("******************************************************")
            print(" <데이터베이스에 이미지 저장 성공> \n\t")
            print("******************************************************")
            
//            self.dismiss(animated: true, completion: nil)
//            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
        }
    }
}
