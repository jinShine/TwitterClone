//
//  FeedController.swift
//  TwitterClone
//
//  Created by buzz on 2020/12/15.
//

import UIKit
import SDWebImage

final class FeedController: UICollectionViewController {
  
  // MARK: - Constant
  
  private let reuseIdentifier = "TweetCell"

  // MARK: - Properties
  
  var user: User? {
    didSet {
      print("DEBUG: Did set user in feed controller?..")
      configureLeftbarButton()
    }
  }
  
  var tweets: [Tweet] = [] {
    didSet {
      collectionView.reloadData()
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
      self.tweets.removeAll()
      self.tweets.append(contentsOf: tweets)
    }
  }
  
  // MARK: - Helpers
  
  func configureUI() {
    view.backgroundColor = .white
    
    collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    collectionView.backgroundColor = .white
    
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

// MARK: - UICollectionViewDelegate/Datasource

extension FeedController {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tweets.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
    
    cell.tweet = tweets[indexPath.item]
    
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 120)
  }
  
}
