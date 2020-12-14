//
//  ExploreController.swift
//  TwitterClone
//
//  Created by buzz on 2020/12/15.
//

import UIKit

final class ExploreController: UIViewController {
  
  // MARK: - Properties
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
  
  // MARK: - Helpers
  
  func configureUI() {
    view.backgroundColor = .blue
    navigationItem.title = "Explore"
  }
  
}
