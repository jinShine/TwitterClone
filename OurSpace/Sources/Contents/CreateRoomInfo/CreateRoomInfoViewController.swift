//
//  CreateRoomInfoViewController.swift
//  OurSpace
//
//  Created by 승진김 on 29/01/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa
import SnapKit
import NVActivityIndicatorView

final class CreateRoomInfoViewController: UIViewController, View {
    
    // UI
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
    let contentsView: UIView = {
        let view = UIView()
        return view
    }()
    
    let spaceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "개설자의 정보를 입력해주세요."
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "이메일을 입력해주세요."
        tf.borderStyle = .roundedRect
        tf.rightViewMode = .always
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.keyboardType = .emailAddress
        return tf
    }()

    let idTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "아이디 (20자 이내)"
        tf.borderStyle = .roundedRect
        tf.rightViewMode = .always
        tf.font = UIFont.systemFont(ofSize: 15)
        return tf
    }()

    let pwTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "비밀번호(숫자 혹은 특수문자 포함 8자 이상)"
        tf.borderStyle = .roundedRect
        tf.rightViewMode = .always
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.isSecureTextEntry = true
        return tf
    }()

    let confirmPwTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "비밀번호 확인"
        tf.borderStyle = .roundedRect
        tf.rightViewMode = .always
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("공간 개설하기", for: UIControl.State.normal)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.backgroundColor = UIColor.mainColor()
        return button
    }()
    
    let indicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: .zero, type: .init(NVActivityIndicatorType.ballTrianglePath), color: UIColor.mainColor(), padding: 0)
        return indicator
    }()
    
    let emailPaddingView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    let idPaddingView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    let pwPaddingView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    let confirmPwPaddingView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    
    
    // Property
    
    var disposeBag: DisposeBag = DisposeBag()
    let navi = CustomNavigationView()
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // Setup Method
    private func setupNavigation() {
        view.addSubview(navi)
        navi.snp.makeConstraints {
            if hasTopNotch {
                $0.height.equalTo(88)
            } else {
                $0.height.equalTo(64)
            }
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        navi.backgroundColor = UIColor.mainColor()
        navi.leftButton.setImage(UIImage(named: "Back_White"), for: UIControl.State.normal)
        navi.leftButton.addTarget(self, action: #selector(closeAction), for: UIControl.Event.touchUpInside)
        navi.titleLabel.text = "프로필 작성"
        navi.titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        navi.titleLabel.textColor = UIColor.white
    }
    
    @objc private func closeAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configureUI() {
        setupNavigation()
        
        [scrollView, indicator].forEach { view.addSubview($0) }
        [contentsView].forEach { scrollView.addSubview($0) }
        [spaceTitleLabel, emailTextField, idTextField, pwTextField, confirmPwTextField, createButton].forEach {
            contentsView.addSubview($0)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(navi.snp.bottom)
            $0.leading.trailing.bottom.equalTo(self.view)
        }
        contentsView.snp.makeConstraints {
            $0.top.bottom.width.height.equalTo(scrollView)
            $0.leading.trailing.equalTo(self.view)
        }
        spaceTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(spaceTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
        }
        idTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
        }
        pwTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
        }
        confirmPwTextField.snp.makeConstraints {
            $0.top.equalTo(pwTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
        }
        createButton.snp.makeConstraints {
            $0.top.equalTo(confirmPwTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
        }
        
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        setupValidCheckImage()
    }
    
    func setupValidCheckImage() {
        
        emailPaddingView.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        let emailCheckImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        emailCheckImg.image = UIImage(named:"Check_Main")
        emailCheckImg.contentMode = .scaleAspectFit
        emailPaddingView.addSubview(emailCheckImg)
        
        idPaddingView.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        let idCheckImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        idCheckImg.image = UIImage(named:"Check_Main")
        idCheckImg.contentMode = .scaleAspectFit
        idPaddingView.addSubview(idCheckImg)
        
        pwPaddingView.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        let pwCheckImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        pwCheckImg.image = UIImage(named:"Check_Main")
        pwCheckImg.contentMode = .scaleAspectFit
        pwPaddingView.addSubview(pwCheckImg)

        confirmPwPaddingView.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        let confirmPwCheckImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        confirmPwCheckImg.image = UIImage(named:"Check_Main")
        confirmPwCheckImg.contentMode = .scaleAspectFit
        confirmPwPaddingView.addSubview(confirmPwCheckImg)

        emailTextField.rightView = emailPaddingView
        idTextField.rightView = idPaddingView
        pwTextField.rightView = pwPaddingView
        confirmPwTextField.rightView = confirmPwPaddingView
    }
    
}

extension CreateRoomInfoViewController {
    
    // Reactor
    func bind(reactor: CreateRoomInfoViewModel) {
        
        // Action
        emailTextField.rx.text.orEmpty
            .map { Reactor.Action.emailInfo($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        idTextField.rx.text.orEmpty
            .map { Reactor.Action.idInfo($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        let pwObserver = pwTextField.rx.text.orEmpty
        let confirmPwObserver = confirmPwTextField.rx.text.orEmpty
        
        pwObserver.map { Reactor.Action.pwInfo($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        Observable.combineLatest(pwObserver, confirmPwObserver)
            .map { Reactor.Action.confirmPwInfo(($0, $1)) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)


        // State
        reactor.state
            .map { $0.isValidEmail }
            .bind(to: emailPaddingView.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.isValidID }
            .bind(to: idPaddingView.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.isValidPW }
            .bind(to: pwPaddingView.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.isPwCheck }
            .bind(to: confirmPwPaddingView.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        
    }
}
