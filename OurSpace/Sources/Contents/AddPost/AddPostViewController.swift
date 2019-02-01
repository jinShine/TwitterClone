//
//  AddPostViewController.swift
//  OurSpace
//
//  Created by 승진김 on 01/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa
import SnapKit
import NVActivityIndicatorView

final class AddPostViewController: UIViewController, View {
    
    
    // UI
    let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let contentTextView: UITextView = {
        let tv = UITextView()
        tv.text = "Test"
        tv.font = UIFont.systemFont(ofSize: 15)
        
        return tv
    }()
    
    let optionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        return view
    }()
    
    let photoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Camera"), for: UIControl.State.normal)
        return button
    }()
    
    
    let indicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: .zero, type: .init(NVActivityIndicatorType.ballTrianglePath), color: UIColor.mainColor(), padding: 0)
        return indicator
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentTextView.becomeFirstResponder()
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
        navi.rightButton.setTitle("Post", for: UIControl.State.normal)
        navi.titleLabel.textColor = UIColor.white
        
        navi.titleLabel.text = "글쓰기"
        navi.titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        navi.titleLabel.textColor = UIColor.white
    }
    
    private func configureUI() {
        
        setupNavigation()
        
        [containerView, indicator].forEach {
            view.addSubview($0)
        }
        [contentTextView, optionView].forEach {
            containerView.addSubview($0)
        }
        [photoButton].forEach {
            optionView.addSubview($0)
        }
        
        containerView.snp.makeConstraints {
            guard let tabbarHeight = tabBarController?.tabBar.frame.height else { return }
            $0.top.equalTo(navi.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(-tabbarHeight)
        }

        contentTextView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalTo(optionView.snp.top)
        }
        
        optionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(40)
        }
        photoButton.snp.makeConstraints {
            $0.size.equalTo(50)
            $0.centerY.equalTo(optionView)
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(50)
        }
    }
    
    func keyboardWillShow(notification: Notification) {
        let notiInfo = notification.userInfo! as Dictionary
        let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let keyboardHeight = keyboardFrame.size.height
        
        containerView.snp.updateConstraints {
            $0.bottom.equalTo(-keyboardHeight)
        }
    }
    
    @objc private func closeAction() {
        print("dd")
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddPostViewController {
    
    // Reactor
    func bind(reactor: AddPostViewModel) {
        
        NotificationCenter.default.rx.notification(Notification.Name?.init(UIApplication.keyboardWillShowNotification))
            .subscribe(onNext: { [weak self] notification in
                self?.keyboardWillShow(notification: notification)
            })
            .disposed(by: self.disposeBag)
        
        // Action
        
        
        
        
        // State
        
        
    }
}
