//
//  CommentViewController.swift
//  OurSpace
//
//  Created by 승진김 on 10/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
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
        tableView.separatorColor = .clear
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = UIColor.mainColor()
        tableView.keyboardDismissMode = .interactive
        tableView.register(CommentCell.self, forCellReuseIdentifier: String(describing: CommentCell.self))
        return tableView
    }()
    
    let indicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: .zero, type: .init(NVActivityIndicatorType.ballTrianglePath), color: UIColor.mainColor(), padding: 0)
        return indicator
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 60)

        [submitButton, inputTextField].forEach {
            containerView.addSubview($0)
        }

        submitButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-12)
            $0.height.equalTo(40)
            $0.width.equalTo(60)
        }

        inputTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(submitButton.snp.leading).offset(-12)
            $0.height.equalTo(40)
        }

        return containerView
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("게시", for: UIControl.State.normal)
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor.mainColor()
        return button
    }()

    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "댓글 달기"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    var navi: SJNavigationView = SJNavigationView(lLeftImage: "Back_White", c_Title: "댓글")
    var viewModel: CommentViewModel!
    var disposeBag: DisposeBag!
    
    
    //MARK:- Setup UI
    
    override var inputAccessoryView: UIView {
        return containerView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupUI() {
        [indicator, tableView, navi].forEach {
            view.addSubview($0)
        }
        
        indicator.center = view.center
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navi.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-60)
        }
        
        navi.snp.makeConstraints {
            if hasTopNotch { $0.height.equalTo(88) }
            else { $0.height.equalTo(64) }
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    //MARK:- -> Event Binding
    
    func setupEventBinding() {

        rx.viewWillAppear
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: self.disposeBag)
        
        tableView.refreshControl?.rx.controlEvent(UIControlEvents.valueChanged)
            .bind(to: viewModel.didPullRefresh)
            .disposed(by: self.disposeBag)
        
        navi.lLeftButton.rx.tap.asObservable()
            .bind(to: viewModel.didTapNaviLeftBarButton)
            .disposed(by: self.disposeBag)
        
        submitButton.rx.tap.asObservable()
            .throttle(1.0, scheduler: MainScheduler.instance)
            .map { [weak self] _ in
                guard let comment = self?.inputTextField.text else { return "" }
                return comment
            }
            .bind(to: viewModel.didTapSubmitButton)
            .disposed(by: self.disposeBag)
        
    }
    
    //MARK:- <- Rx UI Binding
    
    func setupUIBinding() {
        
        NotificationCenter.default.rx.notification(Notification.Name?.init(UIApplication.keyboardWillShowNotification))
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] notification in
                self?.keyboardWillShow(notification: notification)
            })
            .disposed(by: self.disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name?.init(UIApplication.keyboardWillHideNotification))
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] notification in
                self?.keyboardWillHide(notification: notification)
            })
            .disposed(by: self.disposeBag)
        
        let datasource = RxTableViewSectionedReloadDataSource<CommentsData>(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentCell.self), for: indexPath) as? CommentCell else { return UITableViewCell() }
            cell.cellConfigure(item)
            return cell
        })
        
        viewModel.commentData
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: self.disposeBag)
        
        viewModel.isNetworking
            .drive(onNext: { [weak self] isNetworking in
                guard let self = self else { return }
                if !isNetworking {
                    self.indicator.stopAnimating()
                    self.tableView.refreshControl?.endRefreshing()
                } else if !self.tableView.refreshControl!.isRefreshing {
                    self.indicator.startAnimating()
                }
            })
            .disposed(by: self.disposeBag)

        viewModel.popViewController
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: $0)
            })
            .disposed(by: self.disposeBag)

        viewModel.isSubmitting
            .drive(onNext: { result in
                if result { self.inputTextField.text = "" }
                else { self.rx.showOkAlert(title: "에러", message: "서버와의 통신에 문제가 있습니다.").subscribe().disposed(by: self.disposeBag) }
            })
            .disposed(by: self.disposeBag)
    }
    
    //MARK:- Action Handler
    
    func keyboardWillShow(notification: Notification) {
        let notiInfo = notification.userInfo! as Dictionary
        let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let keyboardHeight = keyboardFrame.size.height
        self.tableView.contentInset.bottom = keyboardHeight
        UIView.animate(withDuration: notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval) {
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        let notiInfo = notification.userInfo! as Dictionary
        self.tableView.contentInset.bottom = 0
        UIView.animate(withDuration: notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval) {
            self.view.layoutIfNeeded()
        }
    }
    
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
