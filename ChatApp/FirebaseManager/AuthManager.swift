//
//  AuthManager.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 14.09.2025.
//

import Foundation
import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
    private let auth = Auth.auth()
    private var verificationId: String?
    
    func startAuth(phoneNumber: String, compleation: @escaping(Bool) -> Void){
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationId, error in
            guard let verificationId = verificationId, error == nil else {
                compleation(false)
                return
            }
            self?.verificationId = verificationId
            compleation(true)
        }
    }
    
    func verifyCode(smsCode: String, compleation: @escaping(Bool) -> Void){
        guard let verificationId = verificationId else {
            compleation(false)
            return
        }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: smsCode)
        auth.signIn(with: credential){ result, error in
            guard result != nil, error == nil else {
                compleation(false)
                return
            }
            compleation(true)
        }
    }
}
