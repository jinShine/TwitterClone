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
        tf.font = UIFont.systemFont(ofSize: 15)
        return tf
    }()

    let idTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "아이디"
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 15)
        return tf
    }()

    let pwTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "숫자 혹은 특수문자 포함 8자 이상"
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 15)
        return tf
    }()

    let confirmPwTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "비밀번호 확인"
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 15)
        return tf
    }()
    
    let indicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: .zero, type: .init(NVActivityIndicatorType.ballTrianglePath), color: UIColor.mainColor(), padding: 0)
        return indicator
    }()
    
    
    
    // Property
    
    var disposeBag: DisposeBag = DisposeBag()
    let navi = CustomNavigationView()
    
    
    
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
        navi.leftButton.setImage(UIImage(named: "Close_White"), for: UIControl.State.normal)
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
        [spaceTitleLabel, emailTextField, idTextField, pwTextField, confirmPwTextField].forEach {
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
    }
    

    
}

extension CreateRoomInfoViewController {
    
    // Reactor
    func bind(reactor: CreateRoomInfoViewModel) {
        
        // Action
        
        
        
        
        // State
        
        
    }
}
