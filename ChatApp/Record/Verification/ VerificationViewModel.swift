//
//   VerificationViewModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 14.09.2025.
//

final class VerificationViewModel {
    
    func verifyCode(smsCode: String){
        AuthManager.shared.verifyCode(smsCode: smsCode) { [weak self] success in
            guard success else { return }
            if success {
                
            }
        }
    }
}
