//
//  Colors.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 11.09.2025.
//

import UIKit

struct Colors {
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
    
    static var bgWhite: UIColor {
        return color(
            dark: UIColor(red: 30.0 / 255.0, green: 30.0 / 255.0, blue: 30.0 / 255.0, alpha: 1.0),
            light: UIColor(red: 245.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        )
    }
    
    static var darko: UIColor {
            return color(
                dark: UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0),
                light: UIColor(red: 23.0 / 255.0, green: 23.0 / 255.0, blue: 23.0 / 255.0, alpha: 1.0)
            )
        }
    
    static var gray: UIColor {
        return color(
            dark: UIColor(red: 171.0 / 255.0, green: 170.0 / 255.0, blue: 169.0 / 255.0, alpha: 1.0),
            light: UIColor(red: 171.0 / 255.0, green: 170.0 / 255.0, blue: 169.0 / 255.0, alpha: 1.0)
        )
    }
    
    static var lightGray: UIColor {
        return color(
            dark: UIColor(red: 238.0 / 255.0, green: 238.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0),
            light: UIColor(red: 238.0 / 255.0, green: 238.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
        )
    }
    static var white: UIColor {
            return color(
                dark: UIColor(red: 29.0 / 255.0, green: 29.0 / 255.0, blue: 31.0 / 255.0, alpha: 1.0),
                light: UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
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
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? dark : light
        }
    }
}
