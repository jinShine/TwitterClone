//
//  UserProfileHeader.swift
//  OurSpace
//
//  Created by 승진김 on 22/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class UserProfileHeader: UICollectionViewCell {
    
    //MARK:- UI Matrics
    
    private enum UI {
        static let profileImageSize: CGFloat = 130
        static let profileImageTopMargin: CGFloat = 20
        static let howToViewStackHeight: CGFloat = 50
    }
    
    //MARK:- UI Properties
    
    let profileImageView: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "UserPlaceholder"), for: UIControl.State.normal)
        return button
    }()
    
    let gridButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "grid"), for: UIControl.State.normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "list"), for: UIControl.State.normal)
        return button
    }()
    
    let topSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        return view
    }()
    
    let bottomSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        return view
    }()
    
    lazy var howToViewStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
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
        
        [profileImageView, howToViewStack, topSeparatorLine, bottomSeparatorLine].forEach { addSubview($0) }

    }
    
    private func setupConstraint() {
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UI.profileImageTopMargin)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(UI.profileImageSize)
        }
        
        topSeparatorLine.snp.makeConstraints {
            $0.bottom.equalTo(howToViewStack.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        howToViewStack.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(UI.profileImageTopMargin + 10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UI.howToViewStackHeight)
        }
        
        bottomSeparatorLine.snp.makeConstraints {
            $0.top.equalTo(howToViewStack.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
}

