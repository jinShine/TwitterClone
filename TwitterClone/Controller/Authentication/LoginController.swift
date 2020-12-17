//
//  LoginController.swift
//  TwitterClone
//
//  Created by buzz on 2020/12/15.
//

import UIKit

class LoginController: UIViewController {
  
  //MARK: - Properties
  
  private let logoImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    iv.image = #imageLiteral(resourceName: "TwitterLogo")
    return iv
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
  
  private let emailTextField: UITextField = {
    let tf = Utilities().textField(withPlaceholder: "Email")
    return tf
  }()
  
  private let passwordTextField: UITextField = {
    let tf = Utilities().textField(withPlaceholder: "Password")
    tf.isSecureTextEntry = true
    return tf
  }()
  
  private let loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Log In", for: .normal)
    button.setTitleColor(.twitterBlue, for: .normal)
    button.backgroundColor = .white
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    button.layer.cornerRadius = 5
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    return button
  }()
  
  private let dontHaveAccountButton: UIButton = {
    let button = Utilities().attributedButton("Dont't have an account?", "Sign Up")
    button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
    return button
  }()
  
  //MARK: - Lifecycle
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
  
  //MARK: - Selectors
  
  @objc func handleLogin() {
    guard let email = emailTextField.text,
          let password = passwordTextField.text else { return }
    
    AuthService.shared.logUserIn(withEmail: email, password: password) { (result, error) in
      if let error = error {
        print("DEBUG: Error is logging in \(error.localizedDescription)")
        self.showAlert(withMessage: error.localizedDescription)
        return
      }
      
      print("DEBUG: Successful log in..")
    }
  }
  
  @objc func handleShowSignUp() {
    let controller = RegistrationController()
    navigationController?.pushViewController(controller, animated: true)
  }
  
  //MARK: - Helpers
  
  func configureUI() {
    view.backgroundColor = .twitterBlue
    navigationController?.navigationBar.barStyle = .black // navitionBar를 hidden시 status bar가 하얀색으로 변한다! 꿀팁
    navigationController?.navigationBar.isHidden = true
    
    view.addSubview(logoImageView)
    logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
    logoImageView.setDimensions(width: 150, height: 150)
    
    let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
    stack.axis = .vertical
    stack.spacing = 20
    stack.distribution = .fillEqually
    view.addSubview(stack)
    stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 16, paddingRight: 16)
    
    view.addSubview(dontHaveAccountButton)
    dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                                 paddingLeft: 40, paddingRight: 40)
  }
  
  func showAlert(withMessage message: String) {
    let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
    alertController.addAction(okAction)
    
    present(alertController, animated: true, completion: nil)
  }
  
}
