//
//  ProfileNameViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 12.09.2025.
//

import UIKit
import FirebaseAuth

class ProfileNameViewController: UIViewController {
    
    private lazy var profileButton: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(named: "chooseimage-icon"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.contentHorizontalAlignment = .fill
        btn.contentVerticalAlignment = .fill
        btn.layer.masksToBounds = true
        btn.tintColor = Colors.primary
        let camera = UIAction(title: "Camera", image: UIImage(systemName: "camera")) { [weak self] _ in
            self?.openCamera()
        }
        let gallery = UIAction(title: "Gallery", image: UIImage(systemName: "photo")) { [weak self] _ in
            self?.openGallery()
        }
        let cancel = UIAction(title: "Cancel", image: UIImage(systemName: "x.circle")) { _ in
            print("İptal")
        }
        
        btn.menu = UIMenu(title: "", children: [camera, gallery, cancel])
        btn.showsMenuAsPrimaryAction = true
        
        return btn
    }()
    
    private var nameTextField: UITextField = {
        var txt = UITextField()
        txt.textColor = Colors.darko
        txt.font = AppFont.regular.font(size: 16)
        txt.layer.cornerRadius = 12
        txt.layer.borderWidth = 1
        txt.layer.borderColor = Colors.gray.cgColor
        txt.placeholder = "Name"
        return txt
    }()
    
    private var sureNameTextField: UITextField = {
        var txt = UITextField()
        txt.textColor = Colors.darko
        txt.font = AppFont.regular.font(size: 16)
        txt.layer.cornerRadius = 12
        txt.layer.borderWidth = 1
        txt.layer.borderColor = Colors.gray.cgColor
        txt.placeholder = "Surname"
        return txt
    }()
    
    private let saveButton: UIButton = {
        var btn = UIButton()
        btn.setTitle("Save", for: .normal)
        btn.backgroundColor = Colors.primary
        btn.titleLabel?.textColor = Colors.white
        btn.setTitleColor(Colors.darko, for: .normal)
        btn.layer.cornerRadius = 12
//        btn.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    private let cancelButton: UIButton = {
        var btn = UIButton()
        btn.setTitle("Cancel", for: .normal)
        btn.backgroundColor = Colors.primary
        btn.titleLabel?.textColor = Colors.white
        btn.setTitleColor(Colors.darko, for: .normal)
        btn.layer.cornerRadius = 12
        btn.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        setUpUI()
    }
    
    private func setUpUI(){
        
        view.addSubview(profileButton)
        profileButton.autoPinEdge(.top, to: .top, of: view, withOffset: 100)
        profileButton.autoSetDimension(.height, toSize: 100)
        profileButton.autoSetDimension(.width, toSize: 100)
        profileButton.autoAlignAxis(.vertical, toSameAxisOf: view)
        
        view.addSubview(nameTextField)
        nameTextField.autoPinEdge(.top, to: .bottom, of: profileButton, withOffset: 24)
        nameTextField.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        nameTextField.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        nameTextField.autoSetDimension(.height, toSize: 40)
        
        view.addSubview(sureNameTextField)
        sureNameTextField.autoPinEdge(.top, to: .bottom, of: nameTextField, withOffset: 24)
        sureNameTextField.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        sureNameTextField.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        sureNameTextField.autoSetDimension(.height, toSize: 40)
        
        view.addSubview(saveButton)
        saveButton.autoSetDimension(.height, toSize: 40)
        saveButton.autoPinEdge(.top, to: .bottom, of: sureNameTextField, withOffset:  60)
        saveButton.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        saveButton.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        
        view.addSubview(cancelButton)
        cancelButton.autoSetDimension(.height, toSize: 40)
        cancelButton.autoPinEdge(.top, to: .bottom, of: saveButton, withOffset:  16)
        cancelButton.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        cancelButton.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
    }
    
    @objc func openGallery() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        self.present(vc, animated: true)
    }
    @objc func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Kamera mevcut değil")
            return
        }
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc func cancelButtonClicked(){
        do {
            try Auth.auth().signOut()
            print("User signed out")
            navigationController?.pushViewController(SigninViewController(), animated: true)
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

extension ProfileNameViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage
        if let image = selectedImage {
            profileButton.setImage(image, for: .normal)
            profileButton.imageView?.contentMode = .scaleAspectFill
            profileButton.clipsToBounds = true
            profileButton.layer.cornerRadius = profileButton.bounds.width / 2
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


