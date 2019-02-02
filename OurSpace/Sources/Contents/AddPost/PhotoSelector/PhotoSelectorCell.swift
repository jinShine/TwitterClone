//
//  PhotoSelectorCell.swift
//  OurSpace
//
//  Created by 승진김 on 02/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit
import SnapKit

class PhotoSelectorCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let checkView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 28 / 2
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.white.cgColor
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let checkImage: UIImageView = {
        let check = UIImageView()
        check.backgroundColor = UIColor.white
        check.image = UIImage(named: "Check_Main")
        check.layer.cornerRadius = 28 / 2
        check.layer.masksToBounds = true
        check.isHidden = true
        return check
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [photoImageView].forEach {
            addSubview($0)
        }
        [checkView].forEach {
            photoImageView.addSubview($0)
        }
        [checkImage].forEach {
            checkView.addSubview($0)
        }
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        checkView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.size.equalTo(28)
        }
        checkImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
