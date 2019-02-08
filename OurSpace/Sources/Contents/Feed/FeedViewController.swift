//
//  FeedViewController.swift
//  OurSpace
//
//  Created by 승진김 on 31/01/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa
import SnapKit
import NVActivityIndicatorView
//import Kingfisher

final class FeedViewController: UIViewController, View {
    
    
    // UI
    lazy var collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.backgroundView = UIImageView.init(image: UIImage(named: "EmptyFeedBackground")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        collectionView.backgroundView?.contentMode = UIView.ContentMode.scaleAspectFit
        
        collectionView.backgroundView?.isHidden = true
        collectionView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "FeedCell", bundle: nil), forCellWithReuseIdentifier: "FeedCell")
        return collectionView
    }()
    
    let indicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: .zero, type: .init(NVActivityIndicatorType.ballTrianglePath), color: UIColor.mainColor(), padding: 0)
        return indicator
    }()
    
    
    
    // Property
    var navi: SJNavigationView = SJNavigationView(lLeftImage: "Back_White")
    var disposeBag: DisposeBag = DisposeBag()
    
    
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
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
    
    private func setupNavigation() {
        self.navi = SJNavigationView(lLeftImage: "Back_White")
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
        navi.backgroundColor = UIColor.white
        navi.titleLabel.textColor = .black
        guard let currentRoom = App.userDefault.object(forKey: CURRENT_ROOM) as? String else { return }
        navi.titleLabel.text = currentRoom
    }
}

extension FeedViewController {
    
    // Reactor
    func bind(reactor: FeedViewModel) {
        
        // Action
        self.rx.viewDidLoad
            .map { Reactor.Action.fetchPosts }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.rx.viewDidLoad
            .flatMap { NotificationCenter.default.rx.notification(Notification.Name.init("UpdateFeed")) }
            .flatMap { _ in Observable<Void>.just(()) }
            .map { reactor.posts.removeAll() }
            .map { Reactor.Action.fetchPosts }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        
        
        
        // State
        reactor.state
            .map({ (state) -> [Post] in
                guard let post = state.fetchPostsResult else { return [Post(user: User(), dictionary: [:])] }
                return post
            })
            .filter({ post -> Bool in
                guard post.count > 0 && post.first?.caption.count ?? 0  > 0 else {
                    self.collectionView.backgroundView?.isHidden = false
                    return false
                }
                self.collectionView.backgroundView?.isHidden = true
                return true
            })
            .bind(to: collectionView.rx.items(cellIdentifier: "FeedCell", cellType: FeedCell.self)) { (indexPath, item, cell) in
                
                cell.photoCollectionView.dataSource = nil
                cell.pagesControl.numberOfPages = item.imageUrl.count
                cell.configureCell(post: item)
            }
            .disposed(by: self.disposeBag)
    }
    
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 1, right: 0)
    }
}
