//
//  FeedController.swift
//  TwitterClone
//
//  Created by buzz on 2020/12/15.
//

import UIKit
import SDWebImage

final class FeedController: UIViewController {
  
  // MARK: - Properties
  
  var user: User? {
    didSet {
      print("DEBUG: Did set user in feed controller?..")
      configureLeftbarButton()
    }
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    fetchTweets()
  }
  
  // MARK: - API
  
  func fetchTweets() {
    TweetService.shared.fetchTweets { tweets in
      print(tweets)
    }
  }
  
  // MARK: - Helpers
  
  func configureUI() {
    view.backgroundColor = .white
    
    let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
    imageView.contentMode = .scaleAspectFit
    imageView.setDimensions(width: 44, height: 44)
    navigationItem.titleView = imageView
    
  }
  
  func configureLeftbarButton() {
    guard let user = user else { return }
    
    let profileImageView = UIImageView()
    profileImageView.backgroundColor = .twitterBlue
    profileImageView.setDimensions(width: 32, height: 32)
    profileImageView.layer.cornerRadius = 32 / 2
    profileImageView.layer.masksToBounds = true
    profileImageView.sd_setImage(with: URL(string: user.profileImageURL), completed: nil)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
  }
}
