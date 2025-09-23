//
//  SettingsViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 19.09.2025.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    private let logoutBtn: UIButton = {
        var btn = UIButton()
        btn.setTitle("Log out", for: .normal)
        btn.setTitleColor(Colors.white, for: .normal)
        btn.backgroundColor = Colors.red
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        logoutBtn.addTarget(self, action: #selector(logOutBtnCliked), for: .touchUpInside)
        view.addSubview(logoutBtn)
        logoutBtn.autoAlignAxis(.vertical, toSameAxisOf: view)
        logoutBtn.autoAlignAxis(.horizontal, toSameAxisOf: view)
        logoutBtn.autoSetDimension(.height, toSize: 40)
    }
    //TODO: fix- This code is made for testing purposes.
    @objc private func logOutBtnCliked() {
        do {
            try Auth.auth().signOut()
            
            let loginVC = LoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                window.rootViewController = nav
                window.makeKeyAndVisible()
            }
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
