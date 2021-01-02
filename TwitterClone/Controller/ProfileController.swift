//
//  ProfileController.swift
//  TwitterClone
//
//  Created by buzz on 2020/12/25.
//

import UIKit

class ProfileController: UICollectionViewController {
 
  private let headerIdentifier = "ProfileHeader"
  private let reuseIdentifier = "TweetCell"
  
  // MARK: - Properties
  
  private let user: User

  // MARK: - Lifecycle
  
  init(user: User) {
    self.user = user
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.backgroundColor = .blue
    configureCollectionView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.barStyle = .black
    navigationController?.navigationBar.isHidden = true
    
  }
  
  // MARK: - Selectors
  
  // MARK: - Helpers
  
  func configureCollectionView() {
    collectionView.backgroundColor = .white
    collectionView.contentInsetAdjustmentBehavior = .never
    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
  }
  
}

// MARK: - UICollectionViewDataSource & Delegate

extension ProfileController {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
    
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
    
    header.user = user
    
    return header
  }
  
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: 350)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    CGSize(width: collectionView.frame.width, height: 120)
  }
  
}
