//
//  UserProfileViewModel.swift
//  OurSpace
//
//  Created by 승진김 on 01/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

protocol UserProfileViewModelType: ViewModelType {
    
    // Event
    var viewWillAppear: PublishSubject<Void> { get }
    var didTapSetting: PublishSubject<Void> { get }
    
    // UI
    var showSheetAlert: Driver<Bool> { get }
    
}

final class UserProfileViewModel: UserProfileViewModelType {
    
    //MARK:- Properties
    //MARK: -> Event
    let viewWillAppear = PublishSubject<Void>()
    let didTapSetting = PublishSubject<Void>()
    
    
    //MARK: <- UI
    var showSheetAlert: Driver<Bool>
    
    
    
    //MARK:- Initialize
    init() {
        
        var settingDataSource: BehaviorRelay<[String]> = BehaviorRelay(value: ["로그아웃"])
        
        
        
    }
    
}
