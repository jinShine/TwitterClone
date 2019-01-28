//
//  Extensions.swift
//  OurSpace
//
//  Created by 승진김 on 27/01/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit

var hasTopNotch: Bool {
    if #available(iOS 11.0,  *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }
    
    return false
}

///MARK:- UIColor
extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    static func mainColor() -> UIColor {
        return UIColor(red: 35/255, green: 102/255, blue: 255/255, alpha: 1)
    }
    
    static func mainAlphaColor() -> UIColor {
        return UIColor(red: 35/255, green: 102/255, blue: 255/255, alpha: 0.3)
    }
}
