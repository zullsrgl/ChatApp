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
