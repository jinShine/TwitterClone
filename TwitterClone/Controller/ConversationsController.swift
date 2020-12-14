//
//  ConversationsController.swift
//  TwitterClone
//
//  Created by buzz on 2020/12/15.
//

import UIKit

final class ConversationsController: UIViewController {
  
  // MARK: - Properties
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
  
  // MARK: - Helpers
  
  func configureUI() {
    view.backgroundColor = .purple
    navigationItem.title = "Message"
  }
}
