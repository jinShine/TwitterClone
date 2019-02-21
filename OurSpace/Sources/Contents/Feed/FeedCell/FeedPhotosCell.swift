//
//  FeedPhotosCell.swift
//  OurSpace
//
//  Created by 승진김 on 07/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit
import SnapKit

class FeedPhotosCell: UICollectionViewCell {
    
    let imagesCell: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [imagesCell].forEach {
            addSubview($0)
        }
        
        imagesCell.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print(3333333333333333)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
