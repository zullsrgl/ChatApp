//
//  EditProfileViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 22.10.2025.
//

import UIKit
import SkeletonView

class EditProfileViewController: BaseViewController {

    private var nameTextField: PaddingTextField = {
        var txt = PaddingTextField()
        txt.textColor = Colors.darko
        txt.backgroundColor = Colors.white
        txt.font = AppFont.regular.font(size: 16)
        txt.layer.cornerRadius = 10
        txt.layer.borderWidth = 1
        txt.layer.borderColor = Colors.lightGray.cgColor
        txt.placeholder = "Full Name"
        txt.isSkeletonable = true
        return txt
    }()
    
    private var phoneTextField: PaddingTextField = {
        var txt = PaddingTextField()
        txt.textColor = Colors.darko
        txt.backgroundColor = Colors.white
        txt.font = AppFont.regular.font(size: 16)
        txt.layer.cornerRadius = 10
        txt.layer.borderWidth = 1
        txt.layer.borderColor = Colors.lightGray.cgColor
        txt.placeholder = "Phone Number"
        txt.isSkeletonable = true
        return txt
    }()
    
    private lazy var viewModel = EditProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.bgWhite
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveProfile))
        
        let leftBarBtn = self.backButton(vcName: "Settings", target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarBtn)
        
        self.navBarSetUp(title: "Edit", largeTitle: false)
        
        viewModel.delegate = self
        viewModel.fetchUserData()
    
        setUpUI()
    }
    
    private func setUpUI(){
        view.addSubview(profileButton)
        profileButton.isHidden = false
        profileButton.autoPinEdge(.top, to: .top, of: view, withOffset: 100)
        profileButton.autoSetDimension(.height, toSize: 100)
        profileButton.autoSetDimension(.width, toSize: 100)
        profileButton.autoAlignAxis(.vertical, toSameAxisOf: view)
        
        view.addSubview(nameTextField)
        nameTextField.autoPinEdge(.top, to: .bottom, of: profileButton, withOffset: 12)
        nameTextField.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        nameTextField.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        nameTextField.autoSetDimension(.height, toSize: 40)
        
        view.addSubview(phoneTextField)
        phoneTextField.autoPinEdge(.top, to: .bottom, of: nameTextField, withOffset: 12)
        phoneTextField.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        phoneTextField.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        phoneTextField.autoSetDimension(.height, toSize: 40)
    }
    
    
    @objc func saveProfile () {
        guard let name = nameTextField.text, let phone = phoneTextField.text, let image = profileButton.imageView?.image, !name.isEmpty, !phone.isEmpty else {
            return
        }
        startAnimation()
        viewModel.updateUserData(image: image, fullName: name, phone: phone)
        
    }
    
    @objc func backTapped () {
        navigationController?.popViewController(animated: true)
    }
}

extension EditProfileViewController: EditProfileViewModelDelegate {

    func userFetchedSuccessfully(user: User) {
        
        nameTextField.text = user.name
        phoneTextField.text = user.phone
        
        guard let imageUrl = user.profileImageUrl else { return }
        
        
        if let url = URL(string: imageUrl) {
            profileButton.kf.setImage(with: url, for: .normal)
        }else{
            profileButton.setImage(UIImage(systemName: "person.crop.circle"), for: .normal)
        }
    }
    
    func userSussessfullyUpdated() {
        viewModel.fetchUserData()
        stopAnimation()
        NotificationCenter.default.post(name: .userUpdated, object: nil)
    }
}
