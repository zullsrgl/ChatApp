//
//  ConversationViewModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 29.10.2025.
//

protocol ConverstaionViewModelDelegate: AnyObject {
    func usersFetched(users: [User])
}

final class ConverstaionViewModel {
    weak var delegate: ConverstaionViewModelDelegate?
    
    func getAllUser(){
        AuthManager.shared.fetchAllUser { users, error in
            guard error == nil else { return }
            guard let users = users, !users.isEmpty else { return }
            
            self.delegate?.usersFetched(users: users)
            
        }
    }
}
