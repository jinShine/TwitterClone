//
//  CommonReactive.swift
//  OurSpace
//
//  Created by 승진김 on 28/01/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit
import RxSwift

extension Reactive where Base: UIViewController {
    func showOkCancelAlert(title: String?,
                           message: String?,
                           style: UIAlertController.Style,
                           ok: String? = "확인",
                           okHandle: ((UIAlertAction) -> Void)? = nil,
                           cancel: String? = "취소",
                           cancelHandle: ((UIAlertAction) -> Void)? = nil,
                           sheet: UIAlertAction...) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)
            
            
            ///OK
            if okHandle == nil {
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { _ in
                    observer.onNext(())
                    observer.onCompleted()
                }))
            } else {
                alert.addAction(UIAlertAction(title: ok, style: UIAlertAction.Style.default, handler: okHandle))
            }

            //Cancel
            if cancel == nil {
                alert.addAction(UIAlertAction(title: cancel, style: UIAlertAction.Style.cancel, handler: { _ in observer.onCompleted() }))
            } else {
                alert.addAction(UIAlertAction(title: cancel, style: UIAlertAction.Style.cancel, handler: cancelHandle))
            }
            
            ///Sheet
            sheet.forEach { alert.addAction($0)}
            
            self.base.present(alert, animated: true, completion: nil)
            return Disposables.create()
        })
    }
    
    func showOkAlert(title: String?,
                     message: String?,
                     ok: String? = "확인",
                     okHandle: ((UIAlertAction) -> Void)? = nil) -> Observable<Void> {
        
        return Observable.create({ (observer) -> Disposable in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            if okHandle == nil {
                alert.addAction(UIAlertAction(title: ok, style: UIAlertAction.Style.default, handler: { _ in
                    observer.onNext(())
                    observer.onCompleted()
                }))
            } else {
                alert.addAction(UIAlertAction(title: ok, style: UIAlertAction.Style.default, handler: okHandle))
            }
            
            
            self.base.present(alert, animated: true, completion: nil)
            return Disposables.create()
        })
    }
}
