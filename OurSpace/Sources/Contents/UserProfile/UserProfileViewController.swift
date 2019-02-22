//
//  UserProfileViewController.swift
//  OurSpace
//
//  Created by 승진김 on 01/02/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

final class UserProfileViewController: UIViewController, ViewType {
    
    //MARK:- UI Metrics
    
    struct UI {
        static let profileImageSize: CGFloat = 130
        static let profileImageTopMargin: CGFloat = 50
    }
    

    
    //MARK:- UI Properties
    
    var navi: SJNavigationView = SJNavigationView()
    
    lazy var collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(UserProfileCell.self, forCellWithReuseIdentifier: String(describing: UserProfileCell.self))
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: UserProfileHeader.self))
        return collectionView
    }()
    
    
    
    
    //MARK:- Properties
    
    var viewModel: UserProfileViewModelType!
    var disposeBag: DisposeBag!
    
    
    //MARK:- Setup UI
    
    func setupUI() {
        
        [navi, collectionView].forEach { view.addSubview($0) }
        
        navi.snp.makeConstraints {
            if hasTopNotch { $0.height.equalTo(88) }
            else { $0.height.equalTo(64) }
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        navi.backgroundColor = .white
        navi.rRightButton.setImage(UIImage(named: "gear")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: UIControl.State.normal)
        navi.rRightButton.tintColor = UIColor.mainColor()
        navi.titleLabel.text = "UserName"
        
        //collectionview
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navi.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    
    //MARK:- -> Event Binding
    
    func setupEventBinding() {
        
        rx.viewWillAppear
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: self.disposeBag)
        
        navi.rRightButton.rx.tap.asObservable()
            
        
    }
    
    //MARK:- <- Rx UI Binding
    
    func setupUIBinding() {
//        let datasource = RxCollectionViewSectionedReloadDataSource<UserProfileData>(configureCell: { (_, collectionView, indexPath, item) -> UICollectionViewCell in
//            let cell = UICollectionViewCell()
//            return cell
//        }, configureSupplementaryView: { (items, collectionView, str, indexPath) -> UICollectionReusableView in
//            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: str, withReuseIdentifier: String(describing: UserProfileHeader.self), for: indexPath) as? UserProfileHeader else { return UICollectionViewCell() }
//            return header
//        })
//
//
//        Observable<Void>.just(())
//            .bind(to: collectionView.rx.items(dataSource: datasource))
        

        let datasource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Double>>(configureCell: { (datasource, collectionView, indexPath, item) -> UICollectionViewCell in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UserProfileCell.self), for: indexPath)
            
            return cell
            
        }, configureSupplementaryView: { (datasource, collectionView, kind, indexPath) -> UICollectionReusableView in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: UserProfileHeader.self), for: indexPath) as? UserProfileHeader else { return UICollectionViewCell() }
            
            
            
            return header
        })
        
        
        let items = Observable.just([
            SectionModel(model: "Frist", items: [
                1.0,
                2.0,
                3.0,
                1.0,
                2.0,
                3.0,
                1.0,
                2.0,
                3.0,
                1.0,
                2.0,
                3.0,
                1.0,
                2.0,
                3.0
                ])
            ])
        
        items
            .bind(to: collectionView.rx.items(dataSource: datasource))
            .disposed(by: self.disposeBag)
        
    }
    
    //MARK:- Action Handler
    
}

extension UserProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 232)
    }
}
