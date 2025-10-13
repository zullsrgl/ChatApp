//
//  AuthManager.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 8.10.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Lottie

class AuthManager {
    static let shared = AuthManager()
    private let auth = Auth.auth()
    private var verificationId: String?
    
    func createUser(email: String, password: String, phoneNumber: String, name: String, completion: @escaping (Bool, String) -> Void) {
        auth.createUser(withEmail: email, password: password){ authResult, error in
            
            if let err = error as NSError? {
                var message = ""
                
                if let errorCode = AuthErrorCode(rawValue: err.code) {
                    switch errorCode {
                    case .emailAlreadyInUse:
                        message = "This email is already registered."
                    case .invalidEmail:
                        message = "Invalid email format. Please check your email address."
                    case .weakPassword:
                        message = "Password is too weak. Try a stronger one."
                    default:
                        message = "Other error: \(err.localizedDescription)"
                    }
                } else {
                    message = "Other error: \(err.localizedDescription)"
                }
                
                completion(false, message)
                return
            }
            
            guard let user = authResult?.user else {
                completion(false, "User could not be created.")
                return
            }
            let db = Firestore.firestore()
            db.collection("user").document(user.uid).setData([
                "name": name,
                "phone": phoneNumber,
                "email": email,
                "uid": user.uid
            ]) { error in
                if let error = error {
                    completion(false, "Firestore record error: \(error.localizedDescription)")
                } else {
                    print("user successfully saved")
                }
            }
            user.sendEmailVerification { error in
                if let error = error {
                    completion(false, "Verification email not sent: \(error.localizedDescription)")
                } else {
                    completion(true, "Check your email for verification.")
                    NotificationCenter.default.post(name: .emailVerificationSent, object: nil)
                }
            }
        }
    }
    
    func checkEmailExists(email: String, completion: @escaping (Bool) -> Void){
        let db = Firestore.firestore()
        db.collection("user").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                print("Firestore error: \(error)")
                completion(false)
                return
            }
            
            completion(!(snapshot?.documents.isEmpty ?? true))
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let maybeError = error {
                print("maybeError: \(maybeError)")
                if let err = error as? NSError {
                    if let errorCode = AuthErrorCode(rawValue: err.code){
                        var message = ""
                        switch errorCode {
                        case .invalidEmail:
                            message = "Invalid email format. Please check your email address."
                        case .wrongPassword, .invalidCredential, .userNotFound:
                            message = "Email or password is incorrect. Please try again."
                        case .userDisabled:
                            message = "This account has been disabled. Contact support for help."
                        case .tooManyRequests:
                            message = "Too many login attempts. Please try again later."
                        case .networkError:
                            message = "Network error. Please check your internet connection and try again."
                        default:
                            message = "An unknown error occurred: \(err.localizedDescription)"
                        }
                        completion(false, message)
                        return
                    }
                }
            }
            
            if let user = authResult?.user {
                if user.isEmailVerified {
                    completion(true, "Login successful! Welcome \(user.email ?? "user").")
                } else {
                    completion(false, "Your email address is not verified. Please check your inbox.")
                }
            } else {
                completion(false, "Something went wrong. Please try again.")
            }
        }
    }
    
    func resetPassword(email: String, completion: @escaping (String?, Bool) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email){ error in
            
            if let error = error {
                completion("Password reset email could not be sent \(error.localizedDescription)", false)
            }else {
                completion("Password reset email sent successfully", true)
            }
        }
    }
}
