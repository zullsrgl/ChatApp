//
//  ChatsViewModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 30.10.2025.
//

import Foundation

protocol ChatsViewModelDelegate: AnyObject {
    func userFetched(user: User)
}

final class ChatsViewModel {
    var currentSender: Sender?
    
    weak var delegate: ChatsViewModelDelegate?

    func chatExists(userID: String, text: String) {
        AuthManager.shared.checkIfChatExists(otherUserId: userID) { existingChatId in
            AuthManager.shared.currentUser { user in
                guard let user = user, let photoUrl = user.profileImageUrl else { return }

                let selfSender = Sender(photoURL: photoUrl, senderId: user.uid, displayName: user.name)
                self.currentSender = selfSender

                if let chatId = existingChatId {
                    self.sendMessage(chatId: chatId, text: text, sender: selfSender)
                } else {
                    AuthManager.shared.createNewChat(otherUserId: userID)
                }
            }
        }
    }

    func sendMessage(chatId: String, text: String, sender: Sender, completion: ((Error?) -> Void)? = nil) {
        let message = Message(sender: sender, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text))

        AuthManager.shared.sendMessage(chatId: chatId, message: message) { error in
            completion?(error)
            print("View model first message error: \(String(describing: error))")
        }
    }
    
    func getUser(with userID: String) {
        AuthManager.shared.getUser(with: userID){ user in
            self.delegate?.userFetched(user: user)
        }
    }
}
