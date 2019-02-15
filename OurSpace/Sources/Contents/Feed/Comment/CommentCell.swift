//
//  CommentCell.swift
//  OurSpace
//
//  Created by 승진김 on 11/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class CommentCell: UITableViewCell {
    
    private enum Constants {
        static let commnetFont = FontName.regular(14).font
        static let creationTimeFont = FontName.regular(12).font
    }

    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }

            // ProfileImage
            let imageName = comment.user.profileImageUrl
            self.profileImageView.kf.setImage(with: URL(string: imageName), placeholder: UIImage(named: "UserPlaceholder") )

            let attributedText = NSMutableAttributedString(string: comment.user.id, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: " " + comment.text, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
            self.commentTextView.attributedText = attributedText

            self.creationTimeLabel.text = comment.creationDate.timeAgoDisplay()
        }
    }

    let commentTextView: UITextView = {
        let label = UITextView()
        label.font = Constants.commnetFont
        label.isScrollEnabled = false
        return label
    }()

    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "UserPlaceholder")
        return iv
    }()

    let creationTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Time"
        label.textColor = UIColor.lightGray
        label.font = Constants.creationTimeFont
        return label
    }()

    let lineSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [profileImageView, commentTextView, creationTimeLabel, lineSeparatorView].forEach {
            addSubview($0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(8)
            $0.size.equalTo(40)
        }
        profileImageView.layer.cornerRadius = 40 / 2
        
        commentTextView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().offset(-4)
        }
        
        creationTimeLabel.snp.makeConstraints {
            $0.top.equalTo(commentTextView.snp.bottom)
            $0.leading.equalTo(commentTextView).offset(4)
            $0.trailing.equalTo(commentTextView)
            $0.bottom.equalToSuperview().offset(-4)
        }
        
        lineSeparatorView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
