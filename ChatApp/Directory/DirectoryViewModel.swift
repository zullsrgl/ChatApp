//
//  ConversationViewModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 29.10.2025.
//

protocol ConverstaionViewModelDelegate: AnyObject {
    func usersFetched(users: [User])
}

final class ConverstaionViewModel {
    weak var delegate: ConverstaionViewModelDelegate?
    var currentSender: String?
    
    func getAllUser(){
        AuthManager.shared.fetchAllUser { users, error in
            guard error == nil else { return }
            guard let users = users, !users.isEmpty else { return }
            
            self.delegate?.usersFetched(users: users)
            
        }
    }
    
    func existsChat(with otherUserId: String){
        AuthManager.shared.checkIfChatExists(otherUserId: otherUserId){ existingChatId in
           AuthManager.shared.currentUser{ currentUser in
               guard let user = currentUser else { return }
               let selfSender = user.uid
               self.currentSender = selfSender
               if let chatId = existingChatId {
                  print("chat already exists")
               } else {
                   AuthManager.shared.createNewChat(otherUserId: otherUserId)
               }
            }
        }
    }
}
