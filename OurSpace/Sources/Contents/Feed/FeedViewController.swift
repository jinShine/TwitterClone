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
    let collectionView: UICollectionView = {
        let cv = UICollectionView()
        cv.scrollIndicatorInsets.top = cv.contentInset.top
        return cv
    }()
    
    let indicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: .zero, type: .init(NVActivityIndicatorType.ballTrianglePath), color: UIColor.mainColor(), padding: 0)
        return indicator
    }()
    
    
    
    // Property
    let navi = CustomNavigationView()
    var disposeBag: DisposeBag = DisposeBag()
    
    
    
    
    
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
        navi.backgroundColor = UIColor.mainColor()
        navi.leftButton.setImage(UIImage(named: "Back_White"), for: UIControl.State.normal)
//        navi.leftButton.addTarget(self, action: #selector(closeAction), for: UIControl.Event.touchUpInside)
        navi.titleLabel.text = "공간 이름" //TODO:- 공간 이름 넣기
        navi.titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        navi.titleLabel.textColor = UIColor.white
    }
    
    
    
    
}

extension FeedViewController {
    
    // Reactor
    func bind(reactor: FeedViewModel) {
        
        // Action
        
        
        
        
        // State
        
        
    }
}
