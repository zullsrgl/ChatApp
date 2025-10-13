//
//  RegisterViewModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 23.09.2025.
//
import UIKit

protocol RegisterViewModelDelegate: AnyObject{
    func userDidCreate(isSuccess: Bool, message: String)
}

final class RegisterViewModel {
    
    weak var delegate: RegisterViewModelDelegate?
    
    func createUser(email: String, password: String, phoneNumber: String, name: String){
        AuthManager.shared.createUser(email: email, password: password, phoneNumber: phoneNumber, name: name){ success, message  in
            if success {
                self.delegate?.userDidCreate(isSuccess: true, message: "")
            } else {
                self.delegate?.userDidCreate(isSuccess: false, message: message)
            }
        }
    }
    
    func uploadImage(image: UIImage, userId: String){
        CloudinaryManager.shared.uploadImage(image, userId: userId)
    }
}
