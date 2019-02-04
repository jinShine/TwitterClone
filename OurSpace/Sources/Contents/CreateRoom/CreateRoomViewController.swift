//
//  CreateRoomViewController.swift
//  OurSpace
//
//  Created by 승진김 on 27/01/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa
import SnapKit
import NVActivityIndicatorView

final class CreateRoomViewController: UIViewController, View {
    
    //UI
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
        label.text = "우리들만의 공간의 이름을 입력해주세요.\n방의 이름이 곧 주소입니다."
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    let spaceNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "공간명: (2-15자 이내)"
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 15)
        return tf
    }()
    
    let pwTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "비빌번호 (2-15자 이내)"
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("공간 확인하기", for: UIControl.State.normal)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.backgroundColor = UIColor.mainAlphaColor()
        button.isEnabled = false
        return button
    }()
    
    let indicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: .zero, type: .init(NVActivityIndicatorType.ballTrianglePath), color: UIColor.mainColor(), padding: 0)
        return indicator
    }()

    
    //Property
    var disposeBag: DisposeBag = DisposeBag()
    let navi = SJNavigationView(lLeftImage: "Back_White", c_Title: "글쓰기")
    
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func closeAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
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
        navi.lLeftButton.addTarget(self, action: #selector(closeAction), for: UIControl.Event.touchUpInside)
    }
    
    private func configureUI() {
        setupNavigation()
        
        [scrollView, indicator].forEach { view.addSubview($0) }
        [contentsView].forEach { scrollView.addSubview($0) }
        [spaceTitleLabel, spaceNameTextField, pwTextField, createButton].forEach {
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
        spaceNameTextField.snp.makeConstraints {
            $0.top.equalTo(spaceTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
        }
        pwTextField.snp.makeConstraints {
            $0.top.equalTo(spaceNameTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
        }
        createButton.snp.makeConstraints {
            $0.top.equalTo(pwTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
        }
        
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: Notification) {
        let notiInfo = notification.userInfo! as Dictionary
        let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let keyboardHeight = keyboardFrame.size.height / 2
        self.scrollView.contentInset.bottom = keyboardHeight
        UIView.animate(withDuration: notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval) {
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        let notiInfo = notification.userInfo! as Dictionary
        self.scrollView.contentInset.bottom = 0
        UIView.animate(withDuration: notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval) {
            self.view.layoutIfNeeded()
        }
    }
}

extension CreateRoomViewController {
    
    func bind(reactor: CreateRoomViewModel) {
        
        NotificationCenter.default.rx.notification(Notification.Name?.init(UIApplication.keyboardWillShowNotification))
            .subscribe(onNext: { [weak self] notification in
                self?.keyboardWillShow(notification: notification)
            })
            .disposed(by: self.disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name?.init(UIApplication.keyboardWillHideNotification))
            .subscribe(onNext: { [weak self] notification in
                self?.keyboardWillHide(notification: notification)
            })
            .disposed(by: self.disposeBag)
        
        
        let spaceNameOb = self.spaceNameTextField.rx.text.orEmpty
        let pwTextOb = self.pwTextField.rx.text.orEmpty
        Observable.combineLatest(spaceNameOb, pwTextOb)
            .subscribe(onNext: { [weak self] (name, pw) in
                guard let self = self else { return }
                guard (name.count >= 2 && name.count <= 15) &&
                    (pw.count >= 2 && pw.count <= 15) else {
                        self.createButton.backgroundColor = UIColor.mainAlphaColor()
                        self.createButton.isEnabled = false
                        return
                    }
                self.createButton.backgroundColor = UIColor.mainColor()
                self.createButton.isEnabled = true
            })
            .disposed(by: self.disposeBag)
        
        
        // Action
        createButton.rx.tap
            .map { (self.spaceNameTextField.text ?? "", self.pwTextField.text ?? "")}
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.indicator.startAnimating()
            })
            .map { Reactor.Action.validSpaceName($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        // State
        reactor.state
            .map { $0.isSpaceName }
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                if result {
                    self.rx.showOkAlert(title: "알림", message: "이미 존재하는 공간입니다.")
                        .subscribe(onNext: { _ in self.indicator.stopAnimating() })
                        .disposed(by: self.disposeBag)
                } else {
                    // 저장 && 다음화면 이동 로직
                    print("존재하지 않은 공간명")
                   
                    guard let vc = ProvideObject.createRoomInfo.viewController as? CreateRoomInfoViewController else { return }
                    let createRoomModel = CreateRoom(spaceRoomName: self.spaceNameTextField.text ?? "", spaceRoomPw: self.pwTextField.text ?? "")
                    vc.createRoomModel = createRoomModel
                    self.navigationController?.pushViewController(vc, animated: false)
                }
                self.indicator.stopAnimating()
            })
            .disposed(by: self.disposeBag)
        
    }
}
