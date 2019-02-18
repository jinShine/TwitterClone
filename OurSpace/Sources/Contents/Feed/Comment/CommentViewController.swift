//
//  CommentViewController.swift
//  OurSpace
//
//  Created by 승진김 on 10/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import RxSwift
import RxCocoa
import NVActivityIndicatorView

final class CommentViewController: UIViewController, ViewType {
    
    //MARK:- UI Metrics
    
    struct UI {
        static let estimatedRowHeight: CGFloat = 44
        static let baseMargin: CGFloat = 8
    }
    
    
    //MARK:- Properties
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UI.estimatedRowHeight
        tableView.separatorInset = UIEdgeInsets(top: 0, left: UI.baseMargin, bottom: 0, right: UI.baseMargin)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = UIColor.mainColor()
        tableView.register(CommentCell.self, forCellReuseIdentifier: String(describing: CommentCell.self))
        return tableView
    }()
    
    let indicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: .zero, type: .init(NVActivityIndicatorType.ballTrianglePath), color: UIColor.mainColor(), padding: 0)
        return indicator
    }()
    
    var viewModel: CommentViewModel!
    var disposeBag: DisposeBag!
    
    
    //MARK:- Setup UI
    
    func setupUI() {
        [indicator, tableView].forEach {
            view.addSubview($0)
        }
        
        indicator.center = view.center
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
    }
    
    //MARK:- -> Event Binding
    
    func setupEventBinding() {

        rx.viewWillAppear
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: self.disposeBag)
        
        
    }
    
    //MARK:- <- Rx UI Binding
    
    func setupUIBinding() {
        viewModel.commentData
            .drive(onNext: { data in
                print("======")
                print(data)
            })
            .disposed(by: self.disposeBag)
    }
    
    //MARK:- Action Handler
    
}

//
//final class CommentViewController: UIViewController, View {
//
//
//    //MARK:- UI
//    lazy var collectionView: UICollectionView = {
//        let flowlayout = UICollectionViewFlowLayout()
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
//        collectionView.backgroundColor = .white
//        collectionView.keyboardDismissMode = .interactive
//        collectionView.delegate = self
//        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: String(describing: CommentCell.self))
//        return collectionView
//    }()
//
//    lazy var containerView: UIView = {
//        let containerView = UIView()
//        containerView.backgroundColor = .white
//        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
//
//        [submitButton, inputTextField].forEach {
//            containerView.addSubview($0)
//        }
//
//        submitButton.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.trailing.equalToSuperview().offset(-12)
//            $0.height.equalTo(40)
//        }
//
//        inputTextField.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.leading.equalToSuperview().offset(12)
//            $0.trailing.equalTo(submitButton.snp.leading).offset(-12)
//            $0.height.equalTo(40)
//        }
//
//        return containerView
//    }()
//
//    lazy var submitButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("게시", for: UIControl.State.normal)
//        button.setTitleColor(.white, for: UIControl.State.normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//        button.backgroundColor = UIColor.mainColor()
//        return button
//    }()
//
//    let inputTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "댓글 달기"
//        textField.borderStyle = .roundedRect
//        return textField
//    }()
//
//
//    override var inputAccessoryView: UIView? {
//        return containerView
//    }
//
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//
//
//    //MARK:- Property
//
//    var post: Post?
//    var comments = [Comment]()
//    var navi: SJNavigationView = SJNavigationView(lLeftImage: "Back_White", c_Title: "댓글")
//    var disposeBag: DisposeBag = DisposeBag()
//
//
//    //MARK:- Life Cycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        configureUI()
//    }
//
//
//    private func configureUI() {
//        setupNavigation()
//
//        [collectionView].forEach {
//            view.addSubview($0)
//        }
//        collectionView.snp.makeConstraints {
//            $0.top.equalTo(navi.snp.bottom)
//            $0.leading.trailing.equalToSuperview()
//            $0.bottom.equalToSuperview().offset(-60)
//        }
//    }
//
//    private func setupNavigation() {
//        view.addSubview(navi)
//        navi.snp.makeConstraints {
//            if hasTopNotch {
//                $0.height.equalTo(88)
//            } else {
//                $0.height.equalTo(64)
//            }
//            $0.top.equalToSuperview()
//            $0.leading.trailing.equalToSuperview()
//        }
//
//
//    }
//
//
//}
//
//extension CommentViewController {
//
//    // Reactor
//    func bind(reactor: CommentViewModel) {
//
//        self.navi.lLeftButton.rx.tap.asObservable()
//            .subscribe(onNext: { [weak self] _ in
//                self?.navigationController?.popViewController(animated: true)
//            })
//            .disposed(by: self.disposeBag)
//
//        NotificationCenter.default.rx.notification(Notification.Name?.init(UIApplication.keyboardWillShowNotification))
//            .subscribe(onNext: { [weak self] notification in
//                self?.keyboardWillShow(notification: notification)
//            })
//            .disposed(by: self.disposeBag)
//
//        NotificationCenter.default.rx.notification(Notification.Name?.init(UIApplication.keyboardWillHideNotification))
//            .subscribe(onNext: { [weak self] notification in
//                self?.keyboardWillHide(notification: notification)
//            })
//            .disposed(by: self.disposeBag)
//
//        // Action
//
//        self.rx.viewDidLoad
//            .map { Reactor.Action.fetchComment(self.post ?? Post()) }
//            .bind(to: reactor.action)
//            .disposed(by: self.disposeBag)
//
//        self.submitButton.rx.tap.asObservable()
//            .filter { self.inputTextField.text?.count ?? 0 > 0 }
//            .map { _ in Reactor.Action.handleSubmit(self.inputTextField.text ?? "", self.post ?? Post()) }
//            .bind(to: reactor.action)
//            .disposed(by: self.disposeBag)
//
//
//        // State
//
//        reactor.state
//            .map { $0.handleSubmitResult }
//            .distinctUntilChanged()
//            .subscribe(onNext: { [weak self] result in
//                if result {
//                    print("success")
//                }
//            })
//            .disposed(by: self.disposeBag)
//
//        reactor.state
//            .map { $0.fetchPostsResult }
//            .do(onNext: { comments in
//                self.comments = comments
//            })
//            .bind(to: self.collectionView.rx.items(cellIdentifier: String(describing: CommentCell.self), cellType: CommentCell.self)) { (indexPath, item, cell) in
//                cell.comment = item
//            }
//            .disposed(by: self.disposeBag)
//    }
//
//    func keyboardWillShow(notification: Notification) {
//        let notiInfo = notification.userInfo! as Dictionary
//        let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//        let keyboardHeight = keyboardFrame.size.height - 30
//        self.collectionView.contentInset.bottom = keyboardHeight
//        UIView.animate(withDuration: notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval) {
//            self.view.layoutIfNeeded()
//        }
//    }
//
//    func keyboardWillHide(notification: Notification) {
//        let notiInfo = notification.userInfo! as Dictionary
//        self.collectionView.contentInset.bottom = 0
//        UIView.animate(withDuration: notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval) {
//            self.view.layoutIfNeeded()
//        }
//    }
//
//}
//
//extension CommentViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let dummyCell = CommentCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
//        dummyCell.comment = self.comments[indexPath.item]
//        dummyCell.layoutIfNeeded()
//
//        let targetSize = CGSize(width: view.frame.width, height: 1000)
//        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
//        
//        let height = max(8 + 40 + 8, estimatedSize.height)
//        return CGSize(width: view.frame.width, height: height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//}
//
