//
//  FeedCell.swift
//  OurSpace
//
//  Created by 승진김 on 04/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class FeedCell: UICollectionViewCell {
    
    // Constant
    struct Constant {
        
    }

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var pagesControl: UIPageControl!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var layoutPhotoCollectionHeight: NSLayoutConstraint!
    var disposeBag: DisposeBag = DisposeBag()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupUI()
        
        
        
    }
    
    private func setupUI() {
        backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width)
            ])
        
        self.pagesControl.currentPageIndicatorTintColor = UIColor.mainColor()
        
        photoCollectionView.delegate = self
        photoCollectionView.register(FeedPhotosCell.self, forCellWithReuseIdentifier: "FeedPhotosCell")
    }
    
    func configureCell(post: Post) {

        if post.imageUrl.count > 0 {

            Observable.of(post.imageUrl)
                .bind(to: photoCollectionView.rx.items(cellIdentifier: "FeedPhotosCell", cellType: FeedPhotosCell.self)) { (index, imageURL, cell) in
                    cell.imagesCell.kf.setImage(with: URL(string: imageURL))
                }
                .disposed(by: self.disposeBag)

            pagesControl.isHidden = false
            layoutPhotoCollectionHeight.constant = 280
            
        } else {
            pagesControl.isHidden = true
            layoutPhotoCollectionHeight.constant = 0
        }
        
        userNameLabel.text = post.user.id
        postDateLabel.text = post.creationDate.timeAgoDisplay()
        captionLabel.attributedText = self.setupAttributedCaption(post: post)
    }
    
    private func setupAttributedCaption(post: Post) -> NSMutableAttributedString {
        
        let attributedText = NSMutableAttributedString(string: post.user.id, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4)]))
        
        attributedText.append(NSAttributedString(string: "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.gray]))
        
        return attributedText
    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        setNeedsLayout()
//        layoutIfNeeded()
//        
//        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
//        
//        var frame = layoutAttributes.frame
//        frame.size.height = ceil(size.height)
//        layoutAttributes.frame = frame
//        
//        return layoutAttributes
//    }
}

extension FeedCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentIndex = scrollView.contentOffset.x / photoCollectionView.frame.width
        print(currentIndex)
        pagesControl.currentPage = Int(currentIndex)
    }
}
