//
//  UploadTweetController.swift
//  TwitterClone
//
//  Created by buzz on 2020/12/20.
//

import UIKit

class UploadTweetController: UIViewController {
  
  //MARK: - Properties
  
  private var user: User?
  
  private lazy var actionButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 32))
    button.backgroundColor = .twitterBlue
    button.setTitle("Tweet", for: .normal)
    button.titleLabel?.textAlignment = .center
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 32 / 2
    button.layer.masksToBounds = true
    
    button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
    return button
  }()
  
  private let profileImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    iv.setDimensions(width: 48, height: 48)
    iv.layer.cornerRadius = 48 / 2
    iv.backgroundColor = .blue
    return iv
  }()
  
  private let captionTextView = CaptionTextView()
  
  //MARK: - Lifecycle
  
  init(user: User) {
    super.init(nibName: nil, bundle: nil)
    self.user = user
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
  
  //MARK: - Selectors
  
  @objc func handleCancel() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func handleUploadTweet() {
    guard let caption = captionTextView.text,
          caption.isEmpty == false else { return }
    
    TweetService.shared.uploadTweet(caption: caption) { error in
      if let error = error {
        print("Error is \(error.localizedDescription)")
        return
      }
      
      print("Tweet did upload to database..")
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  //MARK: - API
  
  //MARK: - Helpers
  
  func configureUI() {
    view.backgroundColor = .white
    configureNavigationBar()
    
    let stack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
    stack.axis = .horizontal
    stack.spacing = 12
    
    view.addSubview(stack)
    stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                 paddingTop: 16, paddingLeft: 16, paddingRight: 16)
    
    if let profileImageURLString = self.user?.profileImageURL {
      profileImageView.sd_setImage(with: URL(string: profileImageURLString), completed: nil)
    }
    
  }
  
  func configureNavigationBar() {
    navigationController?.navigationBar.barTintColor = .white
    navigationController?.navigationBar.isTranslucent = false
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
  }
  
}
