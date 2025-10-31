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

extension Message {
    var dictionary: [String: Any] {
        var textValue = ""
        switch kind {
        case .text(let text):
            textValue = text
        default:
            textValue = ""
        }
        
        let sender = self.sender as? Sender
        
        return [
            "messageId": messageId,
            "senderId": sender?.senderId ?? "",
            "senderName": sender?.displayName ?? "",
            "photoURL": sender?.photoURL ?? "",
            "text": textValue,
            "timestamp": sentDate.timeIntervalSince1970
        ]
    }
    
    init?(dictionary: [String: Any]) {
        guard let messageId = dictionary["messageId"] as? String,
              let senderId = dictionary["senderId"] as? String,
              let senderName = dictionary["senderName"] as? String,
              let text = dictionary["text"] as? String,
              let timestamp = dictionary["timestamp"] as? TimeInterval
        else { return nil }
        
        let photoURL = dictionary["photoURL"] as? String ?? ""
        self.sender = Sender(photoURL: photoURL, senderId: senderId, displayName: senderName)
        self.messageId = messageId
        self.sentDate = Date(timeIntervalSince1970: timestamp)
        self.kind = .text(text)
    }
}

