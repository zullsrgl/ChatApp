//
//  ChatsViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 22.09.2025.
//
import PureLayout
import MessageKit

class ChatsViewController: MessagesViewController {
    
    var userID: String? = nil
    
    private var messages = [Message]()
    private let selfSender = Sender(photoURL: "", senderId: "1", displayName: "Zülal Sarıoğlu")
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //TODO: Delete mock data
        messages.append(Message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("hi ")))
        
        messages.append(Message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("I'm zulal")))
        
        messages.append(Message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Did you remember me. forom school")))
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.setTitle("Home", for: .normal)
        backButton.tintColor = Colors.primary
        backButton.setTitleColor(Colors.primary, for: .normal)
        backButton.addTarget(self, action: #selector(tappedBack), for: .touchUpInside)
        backButton.sizeToFit()

        let barButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButton
    
    }
    
    @objc private func tappedBack(){
        navigationController?.popViewController(animated: true)
    }
}

extension ChatsViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> any MessageKit.SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> any MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
}
