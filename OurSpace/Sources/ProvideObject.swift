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
    case start              // StartView
    case createRoom         // CreateRoom
    case createRoomInfo     // CreateRoomInfo
    
    case main(CreateRoom?)   // mainTabbar
    case feed               // FeedVC
    case addPhoto           // addPhoto
    case userProfile        // userProfile
    case photoSelector      // PhotoSelector
    
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
            
        case .main(let createRoomModel):
            let tabBarController = MainTabBarController()
            tabBarController.viewControllers = [
                ProvideObject.feed.viewController,
                ProvideObject.feed.viewController,
                ProvideObject.addPhoto.viewController,
                ProvideObject.userProfile.viewController,
                ProvideObject.userProfile.viewController
            ]
            guard let feedVC = tabBarController.viewControllers?.first as? FeedViewController else { return UITabBarController() }
            feedVC.createRoomModel = createRoomModel
            return tabBarController
            
        case .feed:
            let viewController: FeedViewController = FeedViewController()
            viewController.reactor = FeedViewModel()
            viewController.tabBarItem.image = UIImage(named: "Home")?.withRenderingMode(.alwaysOriginal)
            viewController.tabBarItem.selectedImage = UIImage(named: "Home_Selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            return viewController
            
        case .addPhoto:
            let viewController: AddPostViewController = AddPostViewController()
            viewController.reactor = AddPostViewModel()
            viewController.setNeedsStatusBarAppearanceUpdate()
            viewController.tabBarItem.image = UIImage(named: "Post_Selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            viewController.tabBarItem.selectedImage = UIImage(named: "Post_Selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            return viewController
            
        case .userProfile:
            let viewController: UserProfileViewController = UserProfileViewController()
            viewController.reactor = UserProfileViewModel()
            viewController.tabBarItem.image = UIImage(named: "Profile")?.withRenderingMode(.alwaysOriginal)
            viewController.tabBarItem.selectedImage = UIImage(named: "Profile_Selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            return viewController
            
        case .photoSelector:
            let viewController: PhtoSelectorViewController = PhtoSelectorViewController()
            viewController.reactor = PhotoSelectorViewModel()
            return viewController
        }
    }
}
