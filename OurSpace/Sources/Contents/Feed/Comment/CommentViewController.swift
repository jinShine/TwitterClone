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

        collectionView.backgroundColor = .white
        collectionView.delegate = self

        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: "CommentCell")

        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        return collectionView
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)

        [submitButton, inputTextField].forEach {
            containerView.addSubview($0)
        }
        
        submitButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-12)
            $0.width.equalTo(50)
        }

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
    var comments = [Comment]()
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
            .do(onNext: { comments in
                self.comments = comments
            })
            .bind(to: self.collectionView.rx.items(cellIdentifier: "CommentCell", cellType: CommentCell.self)) { (indexPath, item, cell) in
                print(item)
                cell.comment = item
            }
            .disposed(by: self.disposeBag)
    }
    
}

extension CommentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let dummyCell = CommentCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        dummyCell.comment = self.comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(8 + 40 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

