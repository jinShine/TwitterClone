//
//  TweetCell.swift
//  TwitterClone
//
//  Created by buzz on 2020/12/21.
//

import UIKit

protocol TweetCellDelegate: class {
  func handleProfileImagedTapped(_ cell: TweetCell)
}

class TweetCell: UICollectionViewCell {
  
  // MARK: - Properties
  
  var tweet: Tweet? {
    didSet {
      configure()
    }
  }
  
  weak var delegate: TweetCellDelegate?
  
  private lazy var profileImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    iv.setDimensions(width: 48, height: 48)
    iv.layer.cornerRadius = 48 / 2
    iv.backgroundColor = .gray
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
    iv.isUserInteractionEnabled = true
    iv.addGestureRecognizer(tap)
    
    return iv
  }()
  
  private let captionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.numberOfLines = 0
    label.text = "Some test caption"
    return label
  }()
  
  private let infoLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  private lazy var commnetButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "comment"), for: .normal)
    button.tintColor = .darkGray
    button.setDimensions(width: 20, height: 20)
    button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var retweetButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "retweet"), for: .normal)
    button.tintColor = .darkGray
    button.setDimensions(width: 20, height: 20)
    button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var likeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "like"), for: .normal)
    button.tintColor = .darkGray
    button.setDimensions(width: 20, height: 20)
    button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var shareButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "share"), for: .normal)
    button.tintColor = .darkGray
    button.setDimensions(width: 20, height: 20)
    button.contentMode = .scaleAspectFit
    button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(profileImageView)
    profileImageView.anchor(top: topAnchor, left: leftAnchor,
                            paddingTop: 12, paddingLeft: 8)
    
    let stackView = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
    stackView.axis = .vertical
    stackView.spacing = 4
    stackView.distribution = .fillProportionally
    
    contentView.addSubview(stackView)
    stackView.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor,
                     right: rightAnchor, paddingLeft: 12, paddingRight: 12)
    
    infoLabel.text = "Eddie Brock @venom"
    infoLabel.font = UIFont.systemFont(ofSize: 14)
    
    let actionStack = UIStackView(arrangedSubviews: [commnetButton, retweetButton, likeButton, shareButton])
    actionStack.axis = .horizontal
    actionStack.spacing = 72
    
    contentView.addSubview(actionStack)
    actionStack.anchor(bottom: bottomAnchor, paddingBottom: 8)
    actionStack.centerX(inView: self)

    let underLineView = UIView()
    underLineView.backgroundColor = .systemGroupedBackground
    contentView.addSubview(underLineView)
    underLineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
  }
  
  // MARK: - Selectors
  
  @objc func handleProfileImageTapped() {
    print("handleProfileImageTapped")
    delegate?.handleProfileImagedTapped(self)
  }
  
  @objc func handleCommentTapped() {
    print("handleCommentTapped")
  }
  
  @objc func handleRetweetTapped() {
    print("handleRetweetTapped")
  }
  
  @objc func handleLikeTapped() {
    print("handleLikeTapped")
  }
  
  @objc func handleShareTapped() {
    print("handleShareTapped")
  }
  
  // MARK: - Helpers
  
  func configure() {
    guard let tweet = self.tweet else { return }

    let viewModel = TweetViewModel(tweet: tweet)
    
    captionLabel.text = tweet.caption
    profileImageView.sd_setImage(with: URL(string: viewModel.profileImageURL), completed: nil)
    infoLabel.attributedText = viewModel.userInfoText
  }
}
