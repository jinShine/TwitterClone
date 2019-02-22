//
//  UserProfileCollectionView.swift
//  OurSpace
//
//  Created by 승진김 on 22/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class UserProfileCollectionView: UICollectionViewCell {

    //MARK:- UI Matrics
    
    private enum UI {
        
    }
    
    //MARK:- UI Properties
    
    lazy var collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(UserProfileCell.self, forCellWithReuseIdentifier: String(describing: UserProfileCell.self))
        return collectionView
    }()
    
    
    //MARK:- Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK:- Setup UI
    private func setupUI() {
        [collectionView].forEach { addSubview($0) }

    }
    
    private func setupConstraint() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
}

extension UserProfileCollectionView: UICollectionViewDelegateFlowLayout {
    
    

}
