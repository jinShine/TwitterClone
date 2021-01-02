//
//  ProfileFilterCell.swift
//  TwitterClone
//
//  Created by buzz on 2020/12/28.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
  
  // MARK: - Properties
  
  var option: ProfileFilterOptions = .tweets {
    didSet {
      titleLabel.text = option.description
    }
  }
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    label.font = UIFont.systemFont(ofSize: 14)
    label.text = "Test filter"
    return label
  }()
  
  override var isSelected: Bool {
    didSet {
      titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
      titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
    }
  }
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(titleLabel)
    titleLabel.center(inView: self)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
