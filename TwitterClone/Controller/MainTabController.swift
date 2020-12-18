//
//  MainTabController.swift
//  TwitterClone
//
//  Created by buzz on 2020/12/15.
//

import UIKit
import FirebaseAuth

class MainTabController: UITabBarController {
  
  // MARK: - Properties
  
  let actionButton: UIButton = {
    let button = UIButton(type: .system)
    button.tintColor = .white
    button.backgroundColor = UIColor.twitterBlue
    button.setImage(UIImage(named: "new_tweet"), for: .normal)
    button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    logUserOut()
    view.backgroundColor = .twitterBlue
    authenticateUserAndConfigureUI()
  }
  
  // MARK: - API
  
  func authenticateUserAndConfigureUI() {
    if Auth.auth().currentUser == nil {
      // present login
      DispatchQueue.main.async {
        let nav = UINavigationController(rootViewController: LoginController())
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
      }
      
      print("DEBUG: User is Not logged in..")
    } else {
      // go home
      print("DEBUG: User is logged in..")
      configureViewController()
      configureUI()
      fetchUser()
    }
  }
  
  func logUserOut() {
    do {
      try Auth.auth().signOut()
    } catch let error {
      print("DEBUg: Faild to sign out with error \(error.localizedDescription)")
    }
    
  }
  
  func fetchUser() {
    UserService.shared.fetchUser { user in
      
    }
  }
  
  // MARK: - Selectors
  
  @objc func actionButtonTapped() {
    print(123)
  }
  
  // MARK: - Helpers
  
  func configureUI() {
    view.addSubview(actionButton)
    actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                        paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
    actionButton.layer.cornerRadius = 56 / 2
  }
  
  func configureViewController() {
    let feed = FeedController()
    let feedNavi = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
    
    let explore = ExploreController()
    let exploreNavi = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: explore)
    
    let notifications = NotificationsController()
    let notificationsNavi = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: notifications)
    
    let conversations = ConversationsController()
    let conversatinosNavi = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conversations)
    
    viewControllers = [feedNavi, exploreNavi, notificationsNavi, conversatinosNavi]
  }
  
  func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
    
    let nav = UINavigationController(rootViewController: rootViewController)
    nav.tabBarItem.image = image
    nav.navigationBar.barTintColor = .white
    
    return nav
  }

}
