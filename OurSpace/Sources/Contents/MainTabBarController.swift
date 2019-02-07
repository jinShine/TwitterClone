//
//  MainTabBarController.swift
//  OurSpace
//
//  Created by 승진김 on 01/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    enum TabbarType: Int {
        case feed = 0
        case usersLoacation
        case addPost
        case chat
        case userProfile
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        configure()
        
    }
    
    private func configure() {
        tabBar.isTranslucent = true
        tabBar.barTintColor = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        tabBar.layer.borderWidth = 0.0
    }

}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        let index = viewControllers?.index(of: viewController)
        if index == 2 {

            let naviController = UINavigationController(rootViewController: ProvideObject.addPhoto.viewController)
            naviController.setNavigationBarHidden(true, animated: false)
            self.present(naviController, animated: true, completion: nil)
            
            return false
        }
        return true
    }
}
