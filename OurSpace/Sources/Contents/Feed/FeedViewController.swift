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

final class FeedViewController: UIViewController, View {
    
    
    // UI
//    let collectionView: UICollectionView = {
//        let cv = UICollectionView()
//        cv.scrollIndicatorInsets.top = cv.contentInset.top
////        cv.register(UINib(nibName: "Feed", bundle: nil), forCellWithReuseIdentifier: String(describing: FeedCell.self))
//        return cv
//    }()
    
    let indicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: .zero, type: .init(NVActivityIndicatorType.ballTrianglePath), color: UIColor.mainColor(), padding: 0)
        return indicator
    }()
    
    
    
    // Property
    let navi = SJNavigationView(lLeftImage: "Back_White", c_Title: "공간 이름")
    var disposeBag: DisposeBag = DisposeBag()
    
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        setupNavigation()
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
//        navi.leftButton.addTarget(self, action: #selector(closeAction), for: UIControl.Event.touchUpInside)

    }
    
    
    
    
}

extension FeedViewController {
    
    // Reactor
    func bind(reactor: FeedViewModel) {
        
        // Action
        
        
        
        
        // State
        
        
    }
}
