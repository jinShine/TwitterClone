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
}


extension ProvideObject {
    var viewController: UIViewController {
        switch self {
        case .start:
            let startViewController: StartViewController = StartViewController()
            let navigationVC = UINavigationController(rootViewController: startViewController)
            navigationVC.setNavigationBarHidden(true, animated: false)
            return navigationVC
            
        case .createRoom:
            let createViewController: CreateRoomViewController = CreateRoomViewController()
            createViewController.reactor = CreateRoomViewModel()
            return createViewController
        }
    }
}
