//
//  SettingsViewModel.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 21.10.2025.
//

import UIKit

protocol SettingsViewModelDelegate: AnyObject{
    func userFetched(user: User)
}

final class SettingsViewModel {
    
    weak var delegate: SettingsViewModelDelegate?
    
    func getUser()  {
        AuthManager.shared.currentUser { user in
            guard let user = user else { return}
            self.delegate?.userFetched(user: user)
        }
    }
}
