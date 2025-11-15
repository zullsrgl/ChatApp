//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 24.09.2025.
//

protocol LoginViewModelDelegate: AnyObject {
    func didCheckEmail(exists: Bool, message: String)
    func passwordResetDidFinish(message: String)
}

final class LoginViewModel {
    
    weak var delegate: LoginViewModelDelegate?
    
    func loginUser(email: String, password: String){
        AuthManager.shared.loginUser(email: email, password: password) { [weak self] success, message  in
            self?.delegate?.didCheckEmail(exists: success, message: message)
        }
    }
    
    func resetPassword(email: String){
        AuthManager.shared.resetPassword(email: email) {[weak self] message, success in
            
            if success {
                self?.delegate?.passwordResetDidFinish(message: message ?? "")
                
            } else {
                self?.delegate?.passwordResetDidFinish(message: "Password reset email could not be sent")
            }
        }
    }
}
