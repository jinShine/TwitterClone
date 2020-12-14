//
//  MainTabController.swift
//  TwitterClone
//
//  Created by buzz on 2020/12/15.
//

import UIKit

class MainTabController: UITabBarController {
  
  // MARK: - Properties
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViewController()
  }
  
  // MARK: - Helpers
  
  func configureViewController() {
    let feed = FeedController()
    let feedNavi = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
    
    let explore = ExploreController()
    let exploreNavi = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: explore)
    
    let notifications = NotificationsController()
    let notificationsNavi = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: notifications)
    
    let conversations = ConversationsController()
    let conversatinosNavi = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: conversations)
    
    viewControllers = [feedNavi, exploreNavi, notificationsNavi, conversatinosNavi]
  }
  
  func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
    
    let nav = UINavigationController(rootViewController: rootViewController)
    nav.tabBarItem.image = image
    nav.navigationBar.barTintColor = .white
    
    return nav
  }

}
