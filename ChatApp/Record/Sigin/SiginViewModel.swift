//
//  SiginViewModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 14.09.2025.
//

final class SiginViewModel{
    
    func startAuth(phoneNumer: String) {
        AuthManager.shared.startAuth(phoneNumber: phoneNumer) { [weak self] success in
            guard success else { return }
        }
    }
}
