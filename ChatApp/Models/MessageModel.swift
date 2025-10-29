//
//  MessageModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 29.10.2025.
//

import MessageKit

struct Message: MessageType {
    
    var sender: any MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}

struct Sender: SenderType{
    var photoURL: String
    var senderId: String
    var displayName: String
    
}
