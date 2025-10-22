//
//  EditProfileViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 22.10.2025.
//

import UIKit

class EditProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.bgWhite
        navigationItem.title = "Edit Profile"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveProfile))
        
        let leftBarBtn = self.backButton(vcName: "Settings", target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarBtn)
        
        navigationItem.rightBarButtonItem?.tintColor = Colors.primary
        
        
    }
    
    @objc func saveProfile () {
        //TODO:
    }
    
    @objc func backTapped () {
        navigationController?.popViewController(animated: true)
    }
}

