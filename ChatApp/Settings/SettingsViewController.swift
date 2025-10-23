//
//  SettingsViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 19.09.2025.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController{
    
    private let stackContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 16, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    lazy var viewModel = SettingsViewModel()
    private let profileCardView = ProfileCardView()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        view.backgroundColor = Colors.bgWhite
        
        view.addSubview(stackContainerView)
        stackContainerView.autoPinEdgesToSuperviewEdges()
        
        stackContainerView.addArrangedSubview(profileCardView)
        profileCardView.autoSetDimension(.height, toSize: 140)
        profileCardView.delegate =  self
        viewModel.delegate = self
        viewModel.getUser()
        
    }
    
}

extension SettingsViewController: SettingsViewModelDelegate {
    func userFetched(user: User) {
        profileCardView.canfigure(user: user)
    }
}

extension SettingsViewController: ProfileCardViewDelegate {
    func didTapEditProfile() {
        let editProfileViewController = EditProfileViewController()
        navigationController?.pushViewController(editProfileViewController, animated: true)
    }
}

