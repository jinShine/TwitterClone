//
//  PhotoSelectorViewController.swift
//  OurSpace
//
//  Created by 승진김 on 02/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//


import UIKit
import Photos

import ReactorKit
import RxSwift
import RxCocoa
import SnapKit
import NVActivityIndicatorView


final class PhtoSelectorViewController: UIViewController, View {
    
    
    // UI
    lazy var collectionView: UICollectionView = {
        
        let flowlayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: "PhotoSelector")
        
        return collectionView
    }()
    
    let indicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: .zero, type: .init(NVActivityIndicatorType.ballTrianglePath), color: UIColor.mainColor(), padding: 0)
        return indicator
    }()
    
    
    // Property
    
    let datasource: BehaviorRelay<[UIImage]> = BehaviorRelay(value: [])
    var images: [UIImage] = []
    var assets: [PHAsset] = []
    var selectedItem: (item: [Int], count: Int) = ([],1)
    var refreshResult = false
    let navi = SJNavigationView()
    var disposeBag: DisposeBag = DisposeBag()
    
    
    private let imagePickerController = UIImagePickerController()
    
    
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        //fetch
//        fetchPhoto { [weak self] images in
//            self?.datasource.accept(images)
//        }
        
        let type = UIImagePickerController.SourceType.photoLibrary
        guard UIImagePickerController.isSourceTypeAvailable(type) else { return }
        imagePickerController.sourceType = type
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    private func configureUI() {
        
        setupNavigation()
        
        [collectionView, indicator].forEach {
            view.addSubview($0)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navi.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(50)
        }

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
        navi.backgroundColor = UIColor.mainColor()
        
        navi.lLeftButton.setImage(UIImage(named: "Back_White"), for: UIControl.State.normal)
        navi.lLeftButton.addTarget(self, action: #selector(closeAction), for: UIControl.Event.touchUpInside)
        navi.rRightButton.setTitle("Post", for: UIControl.State.normal)
        navi.rRightButton.addTarget(self, action: #selector(doneAction), for: UIControl.Event.touchUpInside)
        navi.titleLabel.textColor = UIColor.white
        
        navi.titleLabel.text = "카메라롤"
        navi.titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        navi.titleLabel.textColor = UIColor.white
    }
    
    @objc private func closeAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func doneAction() {
        
        guard let addPhotoVC = ProvideObject.addPhoto.viewController as? AddPostViewController else { return }
        print((selectedItem.item, self.assets))
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func assetsFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 50
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    private func fetchPhoto(complete: @escaping ([UIImage]) -> ()) {
        
        let allPhotos = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: self.assetsFetchOptions())
        
        DispatchQueue.global(qos: .userInteractive).async {
            allPhotos.enumerateObjects { [weak self] (asset, count, stop) in
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true // 순서대로 불러온다.
                
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: PHImageContentMode.aspectFit, options: options, resultHandler: { (image, info) in
                    guard let image = image else { return }
                    
                    self?.images.append(image)
                    self?.assets.append(asset)
                    
                    complete(self?.images ?? [UIImage]())

                    if count == allPhotos.count - 1 {
                        self?.refreshResult = true
                    }
                })
            }
        }
    }
    
}

extension PhtoSelectorViewController {
    
    // Reactor
    func bind(reactor: PhotoSelectorViewModel) {
        
        // Action
        
        datasource
            .map { Reactor.Action.photoInfo($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        
        // State
        reactor.state
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                if !self.refreshResult { self.indicator.startAnimating() }
                else { self.indicator.stopAnimating() }
            })
            .map { $0.images }
            .bind(to: collectionView.rx.items(cellIdentifier: "PhotoSelector",
                                              cellType: PhotoSelectorCell.self)) { (indexPath, image, cell) in
                    cell.photoImageView.image = image
            }
            .disposed(by: self.disposeBag)
        
        
        
        // View
        
        collectionView.rx.itemSelected.asObservable()
            .subscribe(onNext: { [weak self] indexPath in
                print(indexPath)
                guard let self = self else { return }
                guard let cell = self.collectionView.cellForItem(at: indexPath) as? PhotoSelectorCell else { return }

                // 4개이고 선택한 셀선택했을때 풀기
                guard self.selectedItem.count <= 4 else {
                    for (offset, item) in self.selectedItem.item.enumerated() {
                        if item == indexPath.item {
                            cell.checkImage.isHidden = true
                            self.selectedItem.count -= 1
                            self.selectedItem.item.remove(at: offset)
                            return
                        }
                    }

                    // 알림
                    self.rx.showOkAlert(title: "알림", message: "4개까지 이미지를 선택할 수 있습니다.")
                        .subscribe().disposed(by: self.disposeBag)
                    return
                }
                
                // -
                for (offset, item) in self.selectedItem.item.enumerated() {
                    print(offset, item)

                    if item == indexPath.item {
                        cell.checkImage.isHidden = true
                        self.selectedItem.count -= 1
                        self.selectedItem.item.remove(at: offset)
                        return
                    }
                }
                
                // +
                cell.checkImage.isHidden = false
                self.selectedItem.count += 1
                self.selectedItem.item.append(indexPath.item)
                
            })
            .disposed(by: self.disposeBag)
        
    }
    
    
}

extension PhtoSelectorViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 5) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
}
