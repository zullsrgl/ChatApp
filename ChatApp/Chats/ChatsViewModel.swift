//
//  ChatsViewModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 30.10.2025.
//

import Foundation

protocol ChatsViewModelDelegate: AnyObject {
    func userFetched(user: User)
    func oldMessagesFetched(messages: [Message])
}

final class ChatsViewModel {
    var currentSender: String?
    
    weak var delegate: ChatsViewModelDelegate?

    func sendMessage(chatId: String, text: String, senderId: String) {
        
        let now = Date()
        let dateString = now.formattedString
        
        let message = Message(messageId: UUID().uuidString, senderId: senderId, text: text, timestamp: dateString, isRead: false)

        AuthManager.shared.sendMessage(chatId: chatId, message: message) { error in
            

        }
    }
    
    func getUser(with userID: String) {
        AuthManager.shared.getUser(with: userID){ user in
            self.delegate?.userFetched(user: user)
        }
    }
    func observeMessages(with chatId: String){
        AuthManager.shared.observeMessages(chatRoomID: chatId)
    }
    
    func fetchOldMessage(with chatId: String){
        AuthManager.shared.fetchOldMessages(chatRoomID: chatId) { messages in
            self.delegate?.oldMessagesFetched(messages: messages)
        }
    }
}
