//
//  CommentViewController.swift
//  OurSpace
//
//  Created by 승진김 on 10/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//


import UIKit

import ReactorKit
import RxSwift
import RxCocoa
import SnapKit
import NVActivityIndicatorView
//import Kingfisher

import Firebase

final class CommentViewController: UIViewController, View {
    
    
    // UI
    lazy var collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.backgroundView = UIImageView.init(image: UIImage(named: "EmptyFeedBackground")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        collectionView.backgroundView?.contentMode = UIView.ContentMode.scaleAspectFit
        
        collectionView.backgroundView?.isHidden = true
//        collectionView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        
        return collectionView
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)

        containerView.addSubview(submitButton)
        submitButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-12)
            $0.width.equalTo(50)
        }

        containerView.addSubview(inputTextField)
        inputTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(submitButton.snp.leading).offset(-12)
        }
        
        return containerView
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: UIControl.State.normal)
        button.setTitleColor(.black, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Commet"
        return textField
    }()
    
    override var inputAccessoryView: UIView? {
        return containerView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    
    // Property
    var navi: SJNavigationView = SJNavigationView(lLeftImage: "Back_White", c_Title: "댓글")
    var disposeBag: DisposeBag = DisposeBag()
    
    
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    private func configureUI() {
        setupNavigation()
        
        [collectionView].forEach {
            view.addSubview($0)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navi.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        

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
    }
    

}

extension CommentViewController {
    
    // Reactor
    func bind(reactor: CommentViewModel) {
        
        self.navi.lLeftButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.submitButton.rx.tap.asObservable()
            .subscribe(onNext: { _ in
                print(123123)
                
            })
            .disposed(by: self.disposeBag)
        
        // Action

        self.submitButton.rx.tap.asObservable()
            .map { Reactor.Action.handleSubmit(self.inputTextField.text ?? "") }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        
        // State

    }
    
}

extension CommentViewController: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10, left: 0, bottom: 1, right: 0)
//    }
    
}

