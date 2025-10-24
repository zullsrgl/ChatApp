//
//  EditProfileViewModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 24.10.2025.
//
import UIKit

protocol EditProfileViewModelDelegate: AnyObject {
    func userFetchedSuccessfully(user: User)
    func userSussessfullyUpdated()
}


final class EditProfileViewModel {
    
    weak var delegate: EditProfileViewModelDelegate?
    
    func fetchUserData() {
        AuthManager.shared.currentUser { user in
            guard let user = user else { return }
            self.delegate?.userFetchedSuccessfully(user: user)
            
        }
    }
    
    func updateUserData(image: UIImage, fullName: String, phone: String) {
        AuthManager.shared.currentUser { user in
            guard let userId = user?.uid else { return }
            
            CloudinaryManager.shared.uploadImage(image, userId: userId) { imageURL in
                guard let imageURL = imageURL else {
                    print("Cloudinary upload failed.")
                    return
                }
                
                AuthManager.shared.updateUser(imageUrl: imageURL, fullName: fullName, phone: phone) { success in
                    if (success != nil) {
                        print("User data successfully updated")
                        self.delegate?.userSussessfullyUpdated()
                    } else {
                        print("Firestore update fail")
                    }
                }
            }
        }
    }
}
