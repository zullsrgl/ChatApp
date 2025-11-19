//
//  ConversationViewModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 29.10.2025.
//
import Foundation

protocol DirectoryViewModelDelegate: AnyObject {
    func usersFetched(users: [User])
    func chatCreated(chat: Chat)
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
        
        AuthManager.shared.checkIfChatExists(otherUserId: otherUserId) { [weak self] existingChatId, ifExist in
            guard let self = self else { return }
            self.getUser(otherUserId: otherUserId) { user in
                
                if ifExist, let chatId = existingChatId {
                    let chat = Chat(chatId: chatId, user: user, unReadMessageCount: 0)
                    self.delegate?.chatCreated(chat: chat)
                    
                } else {
                    AuthManager.shared.createNewChat(otherUserId: otherUserId) { chatId in
                        let chat = Chat(chatId: chatId, user: user, unReadMessageCount: 0)
                        self.delegate?.chatCreated(chat: chat)
                    }
                }
            }
        }
    }
    
    private func getUser(otherUserId: String, completion: @escaping(User) -> Void) {
        AuthManager.shared.getUser(with: otherUserId) { user in
            completion(user)
        }
    }
}
