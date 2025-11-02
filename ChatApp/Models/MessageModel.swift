//
//  MessageModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 29.10.2025.
//

import MessageKit

struct Message: Codable {
    let messageId: String
    let senderId: String
    let text: String
    let timestamp: String
    var isRead: Bool
}
