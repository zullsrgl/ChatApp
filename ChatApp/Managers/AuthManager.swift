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
import FirebaseDatabase

class AuthManager {
    static let shared = AuthManager()
    private let auth = Auth.auth()
    private var verificationId: String?
    private let db = Firestore.firestore()
    private let realTimeDb = Database.database().reference()
    
    func createUser(email: String, password: String, phoneNumber: String, name: String, completion: @escaping (Bool, String, String?) -> Void) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
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
                }
                completion(false, message, nil)
                return
            }
            
            guard let user = authResult?.user else {
                completion(false, "User could not be created.", nil)
                return
            }
            
            self.db.collection("user").document(user.uid).setData([
                "name": name,
                "phone": phoneNumber,
                "email": email,
                "uid": user.uid
            ]) { error in
                if let error = error {
                    completion(false, "Firestore record error: \(error.localizedDescription)", nil)
                    return
                }
                
                user.sendEmailVerification { error in
                    if let error = error {
                        print("Verification email not sent: \(error.localizedDescription)")
                    } else {
                        print("Verification email sent.")
                        NotificationCenter.default.post(name: .emailVerificationSent, object: nil)
                    }
                }
                completion(true, "User created successfully", user.uid)
            }
        }
    }
    
    
    func checkEmailExists(email: String, completion: @escaping (Bool) -> Void){
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
    
    func saveProfileImage(userId: String, imageURL: String, completion: @escaping(Bool) -> Void){
        db.collection("user").document(userId).updateData([
            "profileImageUrl": imageURL
        ]){ error in
            if let error = error {
                print("profile image not saved\(error)")
                completion(false)
            }else {
                completion(true)
            }
        }
    }
    
    
    func currentUser(completion: @escaping (User?) -> Void){
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        db.collection("user").document(userId).getDocument{ snapshot, error in
            
            if let error = error {
                print("Firestore error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = snapshot?.data() else {
                print("No document found")
                completion(nil)
                return
            }
            
            let user = User(name: data["name"] as? String ?? "",
                            uid: userId,
                            email: data["email"] as? String ?? "",
                            phone: data["phone"] as? String ?? "",
                            profileImageUrl: data["profileImageUrl"] as? String ?? "")
            completion(user)
            
        }
    }
    
    func updateUser(imageUrl: String?, fullName: String?, phone: String?, completion: @escaping (String?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        var updateData: [String: Any] = [:]
        
        if let name = fullName, !name.isEmpty {
            updateData["name"] = name
        }
        if let phone = phone, !phone.isEmpty {
            updateData["phone"] = phone
        }
        if let imageUrl = imageUrl, !imageUrl.isEmpty {
            updateData["profileImageUrl"] = imageUrl
        }
        
        
        db.collection("user").document(userId).updateData(updateData) { error in
            if let error = error {
                print("Firestore update hatası: \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(userId)
                
            }
        }
    }
    func fetchAllUser(completion: @escaping ([User]?, Error?) -> Void){
        
        db.collection("user").getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let documents = snapshot?.documents else {
                completion(nil, nil)
                return
            }
            
            var users = documents.compactMap{ documents in
                
                try?  documents.data(as: User.self)
                
            }
            
            if let currentUserID = Auth.auth().currentUser?.uid,
               let index = users.firstIndex(where: { $0.uid == currentUserID }) {
                users.remove(at: index)
            }
            completion(users, nil)
        }
        
    }
    
    func checkIfChatExists(otherUserId: String, completion: @escaping(String?) -> Void){
        guard let currentUserId = auth.currentUser?.uid else { return }
        let chatId = [currentUserId, otherUserId].sorted().joined(separator: "_")
        let chatRef = Database.database().reference().child("chats").child(chatId)
        
        chatRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                completion(chatId)
            }else {
                completion(nil)
            }
        }
    }
    
    func createNewChat(otherUserId: String){
        guard let currentUserId = auth.currentUser?.uid else { return }
        let chatId = [currentUserId, otherUserId].sorted().joined(separator: "_")
        let chatRef = Database.database().reference().child("chats").child(chatId)
        let chatData: [String: Any] = [
            "participants": [currentUserId, otherUserId],
            "createdAt": Date().timeIntervalSince1970
        ]
        
        chatRef.setValue(chatData) { error, _ in
            if error == nil {
                print("new chat room has been created with id: \(chatId)")
            }
        }
    }
    
    func sendMessage(chatId: String, message: Message, completion: ((Error?) -> Void)? = nil) {
        
        let messageData: [String: Any] = [
            "messageId": message.messageId,
               "senderId": message.senderId,
               "text": message.text,
               "timestamp": message.timestamp,
               "isRead": message.isRead
        ]
        
        realTimeDb.child("chats").child(chatId).child(message.messageId).setValue(messageData) { error, _  in
            completion?(error)
            print("firts message error: \(String(describing: error))")
        }
    }
    
    func getUser(with userID: String, completion: @escaping(User) -> Void){
        db.collection("user").document(userID).getDocument { document, error in
            if let error = error {
                print("manager class error: \(error)")
                return
            }
            
            if let document = document, document.exists{
                do {
                    let user = try document.data(as: User.self)
                    completion(user)
                } catch {
                    print("manager class error:")
                }
            }
        }
    }
}
