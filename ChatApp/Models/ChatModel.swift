//
//  ChatModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 17.11.2025.
//

struct Chat {
    let chatId: String
    let user: User
    var lastMessage: Message?
    var unReadMessageCount: Int
    
}
