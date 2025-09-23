//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 24.09.2025.
//

protocol LoginViewModelDelegate: AnyObject {
    func didCheckEmail(exists: Bool)
}

final class LoginViewModel {
    
    weak var delegate: LoginViewModelDelegate?
    
    func getUser(email: String, password: String){
        AuthManager.shared.loginUser(email: email, password: password) { success in
            
            if success {
                self.delegate?.didCheckEmail(exists: success)
            } else {
                
            }
        }
    }
}
