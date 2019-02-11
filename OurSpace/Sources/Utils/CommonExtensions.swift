//
//  Extensions.swift
//  OurSpace
//
//  Created by 승진김 on 27/01/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit

///Notch Check
var hasTopNotch: Bool {
    if #available(iOS 11.0,  *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }
    
    return false
}

///Email 정규식
func validateEmail(_ email: String) -> Bool {
    let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
    let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return predicate.evaluate(with: email)
}

func validatePassword(password: String) -> Bool {
    let passwordRegEx = "^(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9])(?=.*[0-9]).{8,50}$"
    let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
    return predicate.evaluate(with: password)
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

extension UITextField {
    
    func setLeftPaddingPoints(_ amount: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        
    }
}

/// Font
enum FontName {
    case regular(CGFloat)
    case bold(CGFloat)
    case alphabet(CGFloat)
    case appleBold(CGFloat)
}

extension FontName {
    var font: UIFont {
        switch self {
        case .regular(let size):
            return UIFont.systemFont(ofSize: size)
        case .bold(let size):
            return UIFont.boldSystemFont(ofSize: size)
        case .alphabet(let size):
            return UIFont.systemFont(ofSize: size)
        case .appleBold(let size):
            return UIFont.boldSystemFont(ofSize: size)
        }
    }
}

extension UILabel {
//    static func dynamicLabelHeight() -> CGFloat {
//        var maximumLabelSize: CGSize = CGSize(width: 280, height: 9999)
//        var expectedLabelSize: CGSize = label.sizeThatFits(maximumLabelSize)
//        var newFrame: CGRect = self
//
//    }
}

extension UITextView {
    
}
