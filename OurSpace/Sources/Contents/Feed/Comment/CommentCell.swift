//
//  CommentCell.swift
//  OurSpace
//
//  Created by 승진김 on 11/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit
import SnapKit

class CommentCell: UICollectionViewCell {
    
    private enum Constants {
        static let defaultFont = FontName.regular(14).font
    }
    
    var comment: Comment? {
        didSet {
            self.textLabel.text = comment?.text

//            self.profileImageView
//            let labelWidth = textLabel.frame.width
//            let maxLabelSize = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
//            let actualLabelSize = textLabel.text!.boundingRect(with: maxLabelSize, options: [.usesLineFragmentOrigin], attributes: [.font: textLabel.font], context: nil)
//            let labelHeight = actualLabelSize.height
//            print(labelHeight)

            
        }
    }
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.defaultFont
        label.numberOfLines = 0
        label.backgroundColor = .gray
//        label.isScrollEnabled = false
        return label
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "UserPlaceholder")
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .yellow
        
//        addSubview(profileImageView)
//
//        profileImageView.snp.makeConstraints {
//            $0.top.leading.equalToSuperview().offset(8)
//            $0.size.equalTo(40)
//
//        }
//        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.leading.equalToSuperview().offset(4)
            $0.trailing.bottom.equalToSuperview().offset(-4)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func cellHeight(width: CGFloat) -> CGSize {
        print("Constant.defaultLineHeight", Constants.defaultFont.lineHeight)
        let height: CGFloat = Constants.defaultFont.lineHeight
        
//        let dd = self.textLabel.sizeThatFits(CGSize(width: 100, height: self.textLabel.frame.height))
//        print("lllllllllllllllllllll",dd.height)
        
        return CGSize(width: width, height: height)
    }
    
    
}
