//
//  UserProfileCell.swift
//  OurSpace
//
//  Created by 승진김 on 22/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class UserProfileCell: UICollectionViewCell {

    //MARK:- UI Matrics
    
    private enum UI {
    }
    
    //MARK:- UI Properties
    
    let profileImageView: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        return button
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
        
        [profileImageView].forEach { addSubview($0) }
        
    }
    
    private func setupConstraint() {
        
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    
}
