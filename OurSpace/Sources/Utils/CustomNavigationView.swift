//
//  CustomNavigationView.swift
//  OurSpace
//
//  Created by 승진김 on 27/01/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit
import SnapKit

class CustomNavigationView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let leftButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    let rightButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [titleLabel, leftButton, rightButton].forEach {
            self.addSubview($0)
        }
        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-14)
            $0.centerX.equalToSuperview()
            $0.leading.equalTo(leftButton.snp.trailing).priority(100)
            $0.trailing.equalTo(rightButton.snp.leading).priority(100)
        }
        leftButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25)
            $0.centerY.equalTo(titleLabel)
            $0.size.equalTo(18)
        }
        rightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-25)
            $0.centerY.equalTo(titleLabel)
            $0.size.equalTo(18)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
