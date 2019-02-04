//
//  CustomNavigationView.swift
//  OurSpace
//
//  Created by 승진김 on 27/01/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit
import SnapKit

class SJNavigationView: UIView {
    
    // UI
    let lLeftButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    let lRightButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        return button
    }()
   
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    let rLeftButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    let rRightButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    
    // Property
    var lLeftImage: String?
    var lLeftTitle: String?
    var lRightImage: String?
    var lRightTitle: String?
    var title: String?
    var rLeftImage: String?
    var rLeftTitle: String?
    var rRightImage: String?
    var rRightTitle: String?
    
    // Init
    convenience init(lLeftImage lImage1: String? = nil, lLeftTitle lTitle1: String? = nil,
                     lRightImage lImage2: String? = nil, lRightTitle lTitle2: String? = nil,
                     c_Title title: String? = nil,
                     rLeftImage rImage1: String? = nil, rLeftTitle rTitle1: String? = nil,
                     rRightImage rImage2: String? = nil, rRightTitle rTitle2: String? = nil)
    {
        self.init()
        
        self.lLeftImage = lImage1
        self.lLeftTitle = lTitle1
        self.lRightImage = lImage2
        self.lRightTitle = lTitle2
        self.title = title
        self.rLeftImage = rImage1
        self.rLeftTitle = rTitle1
        self.rRightImage = rImage2
        self.rRightTitle = rTitle2
        
        // view
        backgroundColor = UIColor(red: 35/255, green: 102/255, blue: 255/255, alpha: 1) // default

        // Left_Left
        lLeftButton.setImage(UIImage(named: lLeftImage ?? ""), for: UIControl.State.normal)
        lLeftButton.setTitle(lLeftTitle, for: UIControl.State.normal)
        lLeftButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        // Left_Right
        lRightButton.setImage(UIImage(named: lRightImage ?? ""), for: UIControl.State.normal)
        lRightButton.setTitle(lRightTitle, for: UIControl.State.normal)
        lRightButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        // Title
        titleLabel.text = title
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18) // default
        
        // Right_Left
        rLeftButton.setImage(UIImage(named: rLeftImage ?? ""), for: UIControl.State.normal)
        rLeftButton.setTitle(rLeftTitle, for: UIControl.State.normal)
        rLeftButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        // Right_Right
        rRightButton.setImage(UIImage(named: rRightImage ?? ""), for: UIControl.State.normal)
        rRightButton.setTitle(rRightTitle, for: UIControl.State.normal)
        rRightButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        // configure
        configure()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        // configure
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        // Configure
        [titleLabel, lLeftButton, lRightButton, rLeftButton, rRightButton].forEach {
            self.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-14)
            $0.centerX.equalToSuperview()
            $0.leading.equalTo(lRightButton.snp.trailing).offset(30).priority(100)
            $0.trailing.equalTo(rLeftButton.snp.leading).offset(30).priority(100)
        }
        lLeftButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.centerY.equalTo(titleLabel)
            if lLeftTitle == nil && lLeftImage != nil {
                $0.size.equalTo(18)
            }
        }
        lRightButton.snp.makeConstraints {
            $0.leading.equalTo(lLeftButton.snp.trailing).offset(25)
            $0.centerY.equalTo(titleLabel)
            if lRightTitle == nil && lRightImage != nil {
                $0.size.equalTo(18)
            }
        }
        rLeftButton.snp.makeConstraints {
            $0.trailing.equalTo(rRightButton.snp.leading).offset(-25)
            $0.centerY.equalTo(titleLabel)
            if rLeftTitle == nil && rLeftImage != nil {
                $0.size.equalTo(18)
            }
        }
        rRightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-15)
            $0.centerY.equalTo(titleLabel)
            if rRightTitle == nil && rRightImage != nil {
                $0.size.equalTo(18)
            }
        }
    }
}

extension UIButton {
    func makeBarbutton (cloure: (UIButton) -> ()) { }
}
