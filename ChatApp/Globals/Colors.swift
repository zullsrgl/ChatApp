//
//  Colors.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 11.09.2025.
//

import UIKit

enum Colors {
    static var primary: UIColor {
        return color(
            dark: UIColor(red: 254.0 / 255.0, green: 192.0 / 255.0, blue: 8.0 / 255.0, alpha: 1.0),
            light: UIColor(red: 254.0 / 255.0, green: 192.0 / 255.0, blue: 8.0 / 255.0, alpha: 1.0)
        )
    }
    
    static var secondary: UIColor {
        return color(
            dark: UIColor(red: 254.0 / 255.0, green: 159.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0),
            light: UIColor(red: 254.0 / 255.0, green: 159.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        )
    }
    
    static var bgYellow: UIColor {
        return color(
            dark: UIColor(red: 255.0 / 255.0, green: 248.0 / 255.0, blue: 225.0 / 255.0, alpha: 1.0),
            light: UIColor(red: 255.0 / 255.0, green: 248.0 / 255.0, blue: 225.0 / 255.0, alpha: 1.0)
        )
    }
    
    static var darko: UIColor {
        return color(
            dark: UIColor(red: 23.0 / 255.0, green: 23.0 / 255.0, blue: 23.0 / 255.0, alpha: 1.0),
            light: UIColor(red: 23.0 / 255.0, green: 23.0 / 255.0, blue: 23.0 / 255.0, alpha: 1.0)
        )
    }
    
    static var gray: UIColor {
        return color(
            dark: UIColor(red: 171.0 / 255.0, green: 170.0 / 255.0, blue: 169.0 / 255.0, alpha: 1.0),
            light: UIColor(red: 171.0 / 255.0, green: 170.0 / 255.0, blue: 169.0 / 255.0, alpha: 1.0)
        )
    }
    static var white: UIColor {
        return color(
            dark: UIColor(red: 244.0 / 255.0, green: 243.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0),
            light: UIColor(red: 244.0 / 255.0, green: 243.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
        )
    }
    
    static var red: UIColor {
        return color(
            dark: UIColor(red: 255.0 / 255.0, green: 59.0 / 255.0, blue: 48.0 / 255.0, alpha: 1.0),
            light: UIColor(red: 255.0 / 255.0, green: 59.0 / 255.0, blue: 48.0 / 255.0, alpha: 1.0)
        )
    }


}

extension Colors {

    static func color(dark: UIColor, light: UIColor) -> UIColor {
        guard #available(iOS 13, *) else { return light }
        
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            switch UITraitCollection.userInterfaceStyle {
            case .dark: return dark
            case .light: return light
            default: return light
            }
        }
    }
}
