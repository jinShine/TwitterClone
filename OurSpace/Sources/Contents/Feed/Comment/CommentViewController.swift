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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        
//        collectionView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        
        collectionView.backgroundColor = .red
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: "CommentCell")
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        
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
    var post: Post?
    
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
        
        // Action
        
        self.rx.viewDidLoad
            .map { Reactor.Action.fetchComment(self.post ?? Post()) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.submitButton.rx.tap.asObservable()
            .map { _ in Reactor.Action.handleSubmit(self.inputTextField.text ?? "", self.post ?? Post()) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        
        // State

        reactor.state
            .map { $0.handleSubmitResult }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] result in
                if result {
                    print("success")
                }
            })
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.fetchPostsResult }
            .bind(to: self.collectionView.rx.items(cellIdentifier: "CommentCell", cellType: CommentCell.self)) { (indexPath, item, cell) in
                print(item)
                cell.comment = item
                cell.textLabel.sizeToFit()
            }
            .disposed(by: self.disposeBag)
    }
    
}

extension CommentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CommentCell.cellHeight(width: view.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }

    
}

