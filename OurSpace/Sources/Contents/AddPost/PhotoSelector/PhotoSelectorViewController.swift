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
    
    
    
    // Property
    
    let datasource: BehaviorRelay<[UIImage]> = BehaviorRelay(value: [])
    var images: [UIImage] = []
    var assets: [PHAsset] = []
    var disposeBag: DisposeBag = DisposeBag()
    
    
    
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        fetchPhoto { [weak self] images in
            self?.datasource.accept(images)
        }
        
    }
    
    private func configureUI() {
        [collectionView].forEach {
            view.addSubview($0)
        }
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func assetsFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
//        fetchOptions.fetchLimit = 10
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    private func fetchPhoto(complete: @escaping ([UIImage]) -> ()) {
        print("fetchPhoto")
        
        let allPhotos = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: self.assetsFetchOptions())
        print(allPhotos)
        
        DispatchQueue.global(qos: .background).async {
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
                        DispatchQueue.main.async {
                            self?.collectionView.reloadData()
                        }
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
            .filter({ img -> Bool in
                if img.images.count > 0 {
                    return true
                }
                self.collectionView.reloadData()
                return false
            })
            .map { $0.images }
            .bind(to: collectionView.rx.items(cellIdentifier: "PhotoSelector",
                                              cellType: PhotoSelectorCell.self)) { (indexPath, image, cell) in
                    cell.photoImageView.image = image
            }
            .disposed(by: self.disposeBag)
        
    }
}


extension PhtoSelectorViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
