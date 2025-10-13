//
//  App.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 11.09.2025.
//
import UIKit

enum AppFont: String {
    case light = "SFProText-Light"
    case regular = "SFProText-Regular"
    case medium = "SFProText-Medium"
    case semibold = "SFProText-Semibold"
    case bold = "SFProText-Bold"
    
    func font(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: self.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}


class PaddingTextField: UITextField {
    var textpadding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textpadding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textpadding)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textpadding)
    }
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
           var rect = super.rightViewRect(forBounds: bounds)
           rect.origin.x -= 8 
           return rect
       }
}
