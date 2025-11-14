//
//  ConversationViewModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 29.10.2025.
//
import Foundation

protocol DirectoryViewModelDelegate: AnyObject {
    func usersFetched(users: [User])
    func chatRoomIdCreated(chatRoomId: String)
}

final class DirectoryViewModel {
    weak var delegate: DirectoryViewModelDelegate?
    private var currentSender: String?
    
    func getAllUser(){
        AuthManager.shared.fetchAllUser { users, error in
            guard error == nil else { return }
            guard let users = users, !users.isEmpty else { return }
            
            self.delegate?.usersFetched(users: users)
            
        }
    }
    func existsChat(with otherUserId: String) {
        AuthManager.shared.currentUser { [weak self] currentUser in
            guard let self = self, let user = currentUser else { return }
            self.currentSender = user.uid
            
            AuthManager.shared.checkIfChatExists(otherUserId: otherUserId) { existingChatId, ifExist in
                if let chatId = existingChatId {
                    self.delegate?.chatRoomIdCreated(chatRoomId: chatId)
                    
                } else {
                    AuthManager.shared.createNewChat(otherUserId: otherUserId) { chatId in
                        self.delegate?.chatRoomIdCreated(chatRoomId: chatId)
                        
                    }
                }
            }
        }
    }
}
