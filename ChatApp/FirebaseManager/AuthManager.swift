//
//  AuthManager.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 14.09.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Lottie

class AuthManager {
    static let shared = AuthManager()
    private let auth = Auth.auth()
    private var verificationId: String?
    
    func createUser(email: String, password: String, phoneNumber: String, name: String){
        auth.createUser(withEmail: email, password: password){ authResult, error in
            if let error = error {
                print("record error: \(error.localizedDescription)")
            }
            guard let user = authResult?.user else { return }
            
            let db = Firestore.firestore()
            
            db.collection("user").document(user.uid).setData([
                "name": name,
                "phone": phoneNumber,
                "email": email,
                "uid": user.uid
            ]){ error in
                if let error = error {
                    print("Firestore record error: \(error.localizedDescription)")
                } else {
                    print("user successfully saved")
                }
            }
            
            user.sendEmailVerification { error in
                if let error = error {
                    print("verification e-mail not sent: \(error.localizedDescription)")
                } else {
                    print("check your email")
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
    
    func loginUser(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
                return
            }
            
            if let user = authResult?.user, user.isEmailVerified {
                completion(true, nil)
            } else {
                completion(false, "email not verified")
            }
        }
    }
}
