//
//  StartViewController.swift
//  OurSpace
//
//  Created by 승진김 on 27/01/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class StartViewController: UIViewController {

    // UI
    let backgroundImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 35, green: 102, blue: 255, alpha: 0.75)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "우공,"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 55)
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "우리들의 공간"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let goCreateButton: UIButton = {
        let button = UIButton()
        button.setTitle("개설하기", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.backgroundColor = .white
        return button
    }()
    
    let goLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인하기", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.backgroundColor = .white
        return button
    }()
    
    let contentText: UILabel = {
        let label = UILabel()
        label.text = "우리들의 공간에 로그인할 정보를 입력해주세요"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    
    
    // Property
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let backgroundImages: [UIImage] = [
        UIImage(named: "StartView1"),
        UIImage(named: "StartView2"),
        UIImage(named: "StartView3"),
        UIImage(named: "StartView4"),
        UIImage(named: "StartView5"),
        UIImage(named: "StartView6"),
        UIImage(named: "StartView7")
        ].compactMap { $0 }
    
    
    init() { super.init(nibName: nil, bundle: nil) }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEINIT: StartViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bind()
    }

    private func configureUI() {
        let random = Int(arc4random_uniform(7))
        backgroundImageView.image = backgroundImages[random]
        [backgroundImageView, goCreateButton, goLoginButton].forEach {
            view.addSubview($0)
        }
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [shadowView].forEach {
            self.backgroundImageView.addSubview($0)
        }
        shadowView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [titleLabel, subTitleLabel, contentText].forEach {
            self.shadowView.addSubview($0)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(200)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().offset(-50)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
        }
        goCreateButton.snp.makeConstraints {
            $0.bottom.equalTo(goLoginButton.snp.top).offset(-15)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
        }
        goLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(contentText.snp.top).offset(-20)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
        }
        contentText.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-50)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        
        self.view.bringSubviewToFront(goCreateButton)
        self.view.bringSubviewToFront(goLoginButton)
    }
    
    func bind() {
        
        goCreateButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                print("goCreate")
                let vc = ProvideObject.createRoom.viewController as! CreateRoomViewController
                self?.navigationController?.pushViewController(vc, animated: false)
            })
            .disposed(by: self.disposeBag)
    }
}
