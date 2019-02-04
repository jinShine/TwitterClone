//
//  SelectedCell.swift
//  OurSpace
//
//  Created by 승진김 on 03/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit
import SnapKit

class SelectedCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let deleteImage: UIButton = {
        let iv = UIButton()
        iv.contentMode = .scaleAspectFill
        iv.setImage(UIImage(named: "DeleteShape"), for: .normal)
        iv.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [photoImageView, deleteImage].forEach {
            addSubview($0)
        }
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = 2.0
        
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        deleteImage.snp.makeConstraints {
            $0.size.equalTo(23)
            $0.top.equalToSuperview().offset(-9)
            $0.trailing.equalToSuperview().offset(9)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

