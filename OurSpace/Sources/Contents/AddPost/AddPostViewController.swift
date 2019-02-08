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
import Photos

final class AddPostViewController: UIViewController, View {
    
    
    // UI
    let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let contentTextView: UITextView = {
        let tv = UITextView()
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
        button.layer.cornerRadius = 5.0
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.gray.cgColor
        button.contentMode = .scaleAspectFill
        button.setImage(UIImage(named: "addPhoto"), for: UIControl.State.normal)
        return button
    }()
    
    lazy var imagesCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        collectionView.delegate = self
        
        collectionView.register(SelectedCell.self, forCellWithReuseIdentifier: "SelectedCell")
        
        return collectionView
    }()
    
    let indicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: .zero, type: .init(NVActivityIndicatorType.ballTrianglePath), color: UIColor.mainColor(), padding: 0)
        return indicator
    }()
    
    
    // Property
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let navi = SJNavigationView(lLeftImage: "Close_White", c_Title: "글쓰기", rRightTitle: "Post")
    var containerBottomConstant: Constraint?
    
    let imagePickerViewController = UIImagePickerController()
    var images = [UIImage]()
    let imagesSubject: BehaviorRelay<[UIImage]> = BehaviorRelay(value: [])
    
    
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
        self.contentTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.contentTextView.resignFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // Setup Method
    private func setupNavigation() {
        view.addSubview(navi)
        navi.snp.makeConstraints {
            if hasTopNotch { $0.height.equalTo(88) }
            else { $0.height.equalTo(64) }
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureUI() {
        setupNavigation()
        
        [containerView, indicator].forEach {
            view.addSubview($0)
        }
        [contentTextView, optionView].forEach {
            containerView.addSubview($0)
        }
        [photoButton, imagesCollectionView].forEach { optionView.addSubview($0) }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(navi.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            self.containerBottomConstant = $0.bottom.equalToSuperview().constraint
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalTo(optionView.snp.top)
        }

        optionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }

        photoButton.snp.makeConstraints {
            $0.size.equalTo((self.view.frame.width - 10) / 5)
            $0.centerY.equalTo(optionView)
            $0.leading.equalToSuperview().offset(8)
        }
        
        imagesCollectionView.snp.makeConstraints {
            $0.leading.equalTo(photoButton.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.height.equalTo(optionView.snp.height)
            $0.centerY.equalToSuperview()
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
        
        self.containerBottomConstant?.update(offset: -keyboardHeight)
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
        
        photoButton.rx.tap
            .filter({ [weak self] _ -> Bool in
                guard let self = self else { return false }
                guard self.images.count <= 2 else {
                    self.rx.showOkAlert(title: "알림", message: "3개까지만 추가 할 수 있습니다.").subscribe().disposed(by: self.disposeBag)
                    return false
                }
                return true
            })
            .subscribe({ [weak self] _ in
                guard let self = self else { return }
                let type = UIImagePickerController.SourceType.photoLibrary
                guard UIImagePickerController.isSourceTypeAvailable(type) else { return }
                self.imagePickerViewController.sourceType = type
                self.imagePickerViewController.delegate = self
                self.present(self.imagePickerViewController, animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        
        imagesSubject.asObservable()
            .map { $0 }
            .bind(to: imagesCollectionView.rx.items(cellIdentifier: "SelectedCell", cellType: SelectedCell.self)) { (index, item, cell) in
                cell.photoImageView.image = item
            }
            .disposed(by: self.disposeBag)
        
        // 이미지 삭제
        imagesCollectionView.rx.itemSelected.asObservable()
            .subscribe(onNext: { indexPath in
                self.images.remove(at: indexPath.item)
                self.imagesSubject.accept(self.images)
            })
            .disposed(by: self.disposeBag)
        
        navi.lLeftButton.rx.tap.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        


        // Action
        
        let caption = contentTextView.rx.text.orEmpty
        navi.rRightButton.rx.tap.asObservable()
            .do(onNext: { [weak self] _ in self?.indicator.startAnimating() })
            .throttle(7.0, scheduler: MainScheduler.instance)
            .flatMap { _ -> Observable<(String, [UIImage])> in
                return Observable.combineLatest(caption, self.imagesSubject).take(1)
            }.map { Reactor.Action.handleShare($0, $1) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        contentTextView.rx.text.orEmpty
            .map { Reactor.Action.isPostEnable($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        
        // State
        
        reactor.state
            .map { $0.isShareResult }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] result in
                if result {
                    self?.dismiss(animated: true, completion: nil)
                }
                self?.indicator.stopAnimating()
            })
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.isPostEnableResult }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] result in
                if result {
                    self?.navi.rRightButton.isEnabled = true
                    self?.navi.rRightButton.alpha = 1.0
                } else {
                    self?.navi.rRightButton.isEnabled = false
                    self?.navi.rRightButton.alpha = 0.5
                }
            })
            .disposed(by: self.disposeBag)
        
        
    }
}
extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        self.images.append(originalImage)
        self.imagesSubject.accept(self.images)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //취소 했을때
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddPostViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = (self.view.frame.width - 10) / 5
        return CGSize(width: width, height: width)
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
