//
//  ProvideObject.swift
//  OurSpace
//
//  Created by 승진김 on 27/01/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import RxSwift
import RxCocoa

enum ProvideObject {
    case start          // StartView
    case createRoom     // CreateRoom
    case createRoomInfo // CreateRoomInfo
    case feed           // Feed
}


extension ProvideObject {
    var viewController: UIViewController {
        switch self {
        case .start:
            let viewController: StartViewController = StartViewController()
            viewController.setNeedsStatusBarAppearanceUpdate()
            let navigationVC = UINavigationController(rootViewController: viewController)
            navigationVC.setNavigationBarHidden(true, animated: false)
            return navigationVC
            
        case .createRoom:
            let viewController: CreateRoomViewController = CreateRoomViewController()
            viewController.setNeedsStatusBarAppearanceUpdate()
            viewController.reactor = CreateRoomViewModel()
            return viewController
            
        case .createRoomInfo:
            let viewController: CreateRoomInfoViewController = CreateRoomInfoViewController()
            viewController.setNeedsStatusBarAppearanceUpdate()
            viewController.reactor = CreateRoomInfoViewModel()
            return viewController
            
        case .feed:
            let viewController: FeedViewController = FeedViewController()
            viewController.reactor = FeedViewModel()
            return viewController
        }
    }
}
