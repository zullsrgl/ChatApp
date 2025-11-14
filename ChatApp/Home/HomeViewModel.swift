//
//  HomeViewModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 13.11.2025.
//

protocol HomeViewModelDelegate: AnyObject {
    func usersFetched(users: [User], chatId: String)
    func userLastMessagesFetched(lastMessage: Message)
    func unReadMessageCountFetched(unReadMessageCount: Int)
}

final class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
    private var currentSender: String?
    private var users: [User] = []
    
    
    func getAllUser(){
        AuthManager.shared.fetchAllUser { users, error in
            guard error == nil else { return }
            guard let users = users, !users.isEmpty else { return }
   
            for user in users {
                AuthManager.shared.checkIfChatExists(otherUserId: user.uid){ chatId, isExsist in
                    if isExsist {
                        self.users.append(user)
                        guard let chatRoomId = chatId,  !chatRoomId.isEmpty else { return}
                        self.delegate?.usersFetched(users: self.users, chatId: chatRoomId)
                        
                        guard let chatRoomId = chatId, !chatRoomId.isEmpty else { return }
                        AuthManager.shared.fetchOldMessages(chatRoomID: chatRoomId){ messages in
                            if let lastMessage = messages.last {
                                self.delegate?.userLastMessagesFetched(lastMessage: lastMessage)
                            }
                        }
                        AuthManager.shared.fetchUnreadCount(chatRoomID: chatRoomId) { unReadMessageCount in
                            self.delegate?.unReadMessageCountFetched(unReadMessageCount: unReadMessageCount)
                            
                        }
                        
                    } else{
                        print("chat not exsist")
                    }
                    
                }
            }
        }
    }
    
    func unReadMessageCount(){
        
    }
}
