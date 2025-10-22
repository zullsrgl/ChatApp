//
//  SettingsViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 19.09.2025.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController{
  
    
    private let tableView = SettingsTableView()
    lazy var viewModel = SettingsViewModel()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
        viewModel.delegate = self
        tableView.delegate = self
        viewModel.getUser()
        
    }
    
}

extension SettingsViewController: SettingsViewModelDelegate {
    func userFetched(user: User) {
        tableView.configure(with: user)
    }
}

extension SettingsViewController:SettingsTableViewDelegate {
    func tapedProfile() {
        let vc = EditProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
