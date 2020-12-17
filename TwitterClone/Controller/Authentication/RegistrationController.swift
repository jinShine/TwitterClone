//
//  RegistrationController.swift
//  TwitterClone
//
//  Created by buzz on 2020/12/15.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegistrationController: UIViewController {
  
  //MARK: - Properties
  
  private let imagePicker = UIImagePickerController()
  private var profileImage: UIImage?

  private let plusPhotoButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "plus_photo"), for: .normal)
    button.tintColor = .white
    button.layer.cornerRadius = 128 / 2
    button.layer.masksToBounds = true
    button.layer.borderColor = UIColor.white.cgColor
    button.imageView?.contentMode = .scaleAspectFill
    button.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
    return button
  }()
  
  private lazy var emailContainerView: UIView = {
    let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
    let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)

    return view
  }()
  
  private lazy var passwordContainerView: UIView = {
    let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
    let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
    return view
  }()
  
  private lazy var fullNameContainerView: UIView = {
    let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
    let view = Utilities().inputContainerView(withImage: image, textField: fullNameTextField)

    return view
  }()
  
  private lazy var usernameContainerView: UIView = {
    let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
    let view = Utilities().inputContainerView(withImage: image, textField: usernameTextField)
    return view
  }()
  
  private let emailTextField: UITextField = {
    let tf = Utilities().textField(withPlaceholder: "Email")
    return tf
  }()
  
  private let passwordTextField: UITextField = {
    let tf = Utilities().textField(withPlaceholder: "Password")
    tf.isSecureTextEntry = true
    return tf
  }()
  
  private let fullNameTextField: UITextField = {
    let tf = Utilities().textField(withPlaceholder: "Full Name")
    return tf
  }()
  
  private let usernameTextField: UITextField = {
    let tf = Utilities().textField(withPlaceholder: "Username")
    return tf
  }()
  
  private let registrationButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Sign Up", for: .normal)
    button.setTitleColor(.twitterBlue, for: .normal)
    button.backgroundColor = .white
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    button.layer.cornerRadius = 5
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
    return button
  }()
  
  private let alreadyHaveAccountButton: UIButton = {
    let button = Utilities().attributedButton("Already have an account?", "Log In")
    button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
    return button
  }()
  
  //MARK: - Lifecycle
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
  
  //MARK: - Selectors
  
  @objc func handleShowLogin() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc func handleAddProfilePhoto() {
    present(imagePicker, animated: true, completion: nil)
  }
  
  @objc func handleRegistration() {

    guard let profileImage = profileImage else {
      print("DEBUG: Please select a profile image..")
      self.showAlert(withMessage: "프로필 사진을 선택해 주세요")
      return
    }
    guard let email = emailTextField.text,
          let password = passwordTextField.text,
          let fullName = fullNameTextField.text,
          let username = usernameTextField.text else { return }
    
    let credentials = AuthCredentials(email: email, password: password, fullname: fullName, username: username, profileImage: profileImage)
    
    AuthService.shared.registerUser(credentials: credentials) { error in
      if let error = error {
        print("Error is \(error.localizedDescription)")
        return
      }
      
      self.navigationController?.popToRootViewController(animated: true)
      print("DEBUG: Sign up successful")
    }
    
    
  }
  
  //MARK: - Helpers
  
  func configureUI() {
    view.backgroundColor = .twitterBlue
    
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    
    view.addSubview(plusPhotoButton)
    plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
    plusPhotoButton.setDimensions(width: 128, height: 128)
    
    let stack = UIStackView(arrangedSubviews: [
      emailContainerView, passwordContainerView, fullNameContainerView, usernameContainerView, registrationButton
    ])
    stack.axis = .vertical
    stack.spacing = 20
    stack.distribution = .fillEqually
    view.addSubview(stack)
    stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
    
    
    view.addSubview(alreadyHaveAccountButton)
    alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                                 paddingLeft: 40, paddingRight: 40)
  }
  
  func showAlert(withMessage message: String) {
    let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
    alertController.addAction(okAction)
    
    present(alertController, animated: true, completion: nil)
  }
  
}

//MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    guard let profileImage = info[.editedImage] as? UIImage else { return }
    self.profileImage = profileImage
    plusPhotoButton.setImage(profileImage, for: .normal)
    plusPhotoButton.layer.borderWidth = 3
    
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}
