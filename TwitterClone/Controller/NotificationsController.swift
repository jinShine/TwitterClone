//
//  NotificationsController.swift
//  TwitterClone
//
//  Created by buzz on 2020/12/15.
//

import UIKit

final class NotificationsController: UIViewController {
  
  // MARK: - Properties
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
  
  // MARK: - Helpers
  
  func configureUI() {
    view.backgroundColor = .systemPink
    navigationItem.title = "Notifications"
  }
}
