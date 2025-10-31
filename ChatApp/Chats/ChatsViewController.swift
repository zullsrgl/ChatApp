//
//  ChatsViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 22.09.2025.

import PureLayout
import MessageKit
import InputBarAccessoryView

class ChatsViewController: MessagesViewController {
    
    var userID: String? = nil
    
    private var messages = [Message]()
    private var selfSender: Sender? = nil
    
    private lazy var viewModel = ChatsViewModel()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
  
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
        return viewModel.currentSender ?? Sender(photoURL: "", senderId: "unknown", displayName: "Unknown")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> any MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
}

extension ChatsViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print("input bar text: \(text)")
        //TODO: send Message
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return}
        
        
        guard let userID = userID, !userID.isEmpty else { return}
        viewModel.chatExists(userID: userID, text: text)
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem()
        inputBar.inputTextView.text = ""
    }
}
