//
//  HomeViewModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 13.11.2025.
//

protocol HomeViewModelDelegate: AnyObject {
    func chatsFetched(chat: [Chat])
}

final class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
    private var chat: [Chat] = []
    
    private func returnChats(){
        self.delegate?.chatsFetched(chat: chat)
    }
    
    func getAllUser(){
        AuthManager.shared.fetchAllUser { [weak self] users, error in
            guard error == nil else { return }
            guard let users = users, !users.isEmpty else { return }
            
            users.forEach { user in
                self?.checkIfChatExists(user: user)
                
            }
        }
    }
    
    private func checkIfChatExists(user: User){
        AuthManager.shared.checkIfChatExists(otherUserId: user.uid){ [weak self] chatId, isExsist in
            guard let chatId = chatId else { return}
            if isExsist {
                self?.chat.append( Chat(chatId: chatId, user: user, lastMessage: nil, unReadMessageCount: 0))
                
                self?.getLastMessage(chatId: chatId){
                    self?.returnChats()
                }
                self?.getLastMessage(chatId: chatId){
                    self?.returnChats()
                    
                }
            }
        }
    }
    
    private func getLastMessage(chatId: String, completion: @escaping() -> Void){
        AuthManager.shared.fetchOldMessages(chatRoomID: chatId){ [weak self] messages in
            if let lastMessage = messages.last {
                let index = self?.chat.firstIndex { chat in
                    chat.chatId == chatId
                    
                }
                guard let index = index else { return }
                
                self?.chat[index].lastMessage = lastMessage
                completion()
            }else {
                completion()
            }
            
        }
    }
}

