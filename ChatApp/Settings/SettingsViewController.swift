//
//  SettingsViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 19.09.2025.
//

import UIKit
import FirebaseAuth

class SettingsViewController: BaseViewController{
    
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
    
    private lazy var viewModel = SettingsViewModel()
    private let profileCardView = ProfileCardView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navBarSetUp(title: "Settings", largeTitle: true)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = Colors.bgWhite
       
        NotificationCenter.default.addObserver(self, selector: #selector(userUpdeted), name: .userUpdated, object: nil)
        
        profileCardView.delegate =  self
        viewModel.delegate = self
        viewModel.getUser()
    
        view.addSubview(stackContainerView)
        stackContainerView.autoPinEdgesToSuperviewEdges()
        
        stackContainerView.addArrangedSubview(profileCardView)
        profileCardView.autoSetDimension(.height, toSize: 140)
        
    }
    
    @objc func userUpdeted(){
        viewModel.getUser()
   }
}


extension SettingsViewController: SettingsViewModelDelegate {
    func userFetched(user: User) {
        profileCardView.configure(user: user)
    }
}

extension SettingsViewController: ProfileCardViewDelegate {
    func didTapEditProfile() {
        let editProfileViewController = EditProfileViewController()
        navigationController?.pushViewController(editProfileViewController, animated: true)
    }
}

