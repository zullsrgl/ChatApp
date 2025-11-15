//
//  RegisterViewModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 23.09.2025.
//
import UIKit

protocol RegisterViewModelDelegate: AnyObject{
    func userDidCreate(isSuccess: Bool, message: String)
    func animationShowed()
}

final class RegisterViewModel {
    
    weak var delegate: RegisterViewModelDelegate?
    
    private func uploadImage(image: UIImage, userId: String, completion: @escaping () -> Void){
        CloudinaryManager.shared.uploadImage(image, userId: userId) {  imageURL in
            guard let imageURL = imageURL else {
                completion()
                return
            }
            
            AuthManager.shared.saveProfileImage(userId: userId, imageURL: imageURL) { success in
                if success {
                    print("operation is success")
                }else {
                    print(" Failed to save image URL")
                   
                }
                
                completion()
            }
        }
    }
    
    func createUser(email: String, password: String, phoneNumber: String, name: String, image: UIImage){
        delegate?.animationShowed()
        AuthManager.shared.createUser(email: email, password: password, phoneNumber: phoneNumber, name: name){ [weak self] success, message, userId  in
            if success, let userId = userId {
                self?.uploadImage(image: image, userId: userId){
                    self?.delegate?.userDidCreate(isSuccess: true, message: "")
                }
            } else {
                self?.delegate?.userDidCreate(isSuccess: false, message: message)
            }
        }
    }
}
