//
//  RegisterViewModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 23.09.2025.
//

final class RegisterViewModel {
    
    func createUser(email: String, password: String, phoneNumber: String, name: String){
        AuthManager.shared.createUser(email: email, password: password, phoneNumber: phoneNumber, name: name)
    }
}
