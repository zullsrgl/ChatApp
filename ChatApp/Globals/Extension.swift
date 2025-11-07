//
//  Extension.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 12.09.2025.
//
import UIKit
import Lottie


extension Notification.Name {
    static let emailVerificationSent = Notification.Name("emailVerificationSent")
    static let userUpdated = Notification.Name("userUpdated")
}

extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
}

extension Date {
    
    // MARK: - Date → String
    var formattedString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd h:mm:ss a Z"
        return formatter.string(from: self)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    // MARK: - String → Date
    static func from(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "yyyy-MM-dd h:mm:ss a ZZZ"
        return formatter.date(from: string)
    }
}
