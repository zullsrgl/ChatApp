//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 23.09.2025.
//

import PureLayout

class RegisterViewController: BaseViewController {
    
    lazy var viewModel = RegisterViewModel()
    private var showPassword: Bool = false
    
    private var nameTextField: PaddingTextField = {
        var txt = PaddingTextField()
        txt.textColor = Colors.darko
        txt.font = AppFont.regular.font(size: 16)
        txt.layer.cornerRadius = 20
        txt.layer.borderWidth = 1
        txt.layer.borderColor = Colors.gray.cgColor
        txt.placeholder = "Full Name"
        return txt
    }()
    
    private var emailTextField: PaddingTextField = {
        var txt = PaddingTextField()
        txt.textColor = Colors.darko
        txt.font = AppFont.regular.font(size: 16)
        txt.layer.cornerRadius = 20
        txt.layer.borderWidth = 1
        txt.layer.borderColor = Colors.gray.cgColor
        txt.placeholder = "Email"
        txt.autocapitalizationType = .none
        txt.autocorrectionType = .no
        txt.keyboardType = .emailAddress
        return txt
    }()
    
    private var passwordTextField: PaddingTextField = {
        var txt = PaddingTextField()
        txt.textColor = Colors.darko
        txt.font = AppFont.regular.font(size: 16)
        txt.layer.cornerRadius = 20
        txt.layer.borderWidth = 1
        txt.layer.borderColor = Colors.gray.cgColor
        txt.placeholder = "Password"
        txt.isSecureTextEntry = true
        txt.keyboardType = .default
        return txt
    }()
    
    private var eyeIconButton: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "eye"), for: .normal)
        btn.isEnabled = true
        btn.clipsToBounds = true
        btn.tintColor = Colors.secondary
        btn.isUserInteractionEnabled = true
        btn.addTarget(self, action: #selector(toggaleEye), for: .touchUpInside)
        return btn
    }()
    
    private var phoneTextField: PaddingTextField = {
        var txt = PaddingTextField()
        txt.textColor = Colors.darko
        txt.font = AppFont.regular.font(size: 16)
        txt.layer.cornerRadius = 20
        txt.layer.borderWidth = 1
        txt.layer.borderColor = Colors.gray.cgColor
        txt.keyboardType = .phonePad
        txt.placeholder = "Phone"
        return txt
    }()
    
    private let saveButton: UIButton = {
        var btn = UIButton()
        btn.setTitle("Save", for: .normal)
        btn.backgroundColor = Colors.primary
        btn.setTitleColor(Colors.white, for: .normal)
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        
        let leftBarBtn = self.backButton(vcName: "Login", target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarBtn)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showEmailAnimation), name: .emailVerificationSent, object: nil)
        
        viewModel.delegate = self
        
        setUpUI()
    }
    
    private func setUpUI(){
        
        view.addSubview(profileButton)
        
        view.addSubview(nameTextField)
        nameTextField.autoPinEdge(.top, to: .bottom, of: profileButton, withOffset: 12)
        nameTextField.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        nameTextField.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        nameTextField.autoSetDimension(.height, toSize: 40)
        
        view.addSubview(emailTextField)
        emailTextField.autoPinEdge(.top, to: .bottom, of: nameTextField, withOffset: 12)
        emailTextField.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        emailTextField.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        emailTextField.autoSetDimension(.height, toSize: 40)
        
        view.addSubview(passwordTextField)
        passwordTextField.autoPinEdge(.top, to: .bottom, of: emailTextField, withOffset: 12)
        passwordTextField.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        passwordTextField.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        passwordTextField.autoSetDimension(.height, toSize: 40)
        
        passwordTextField.rightView = eyeIconButton
        passwordTextField.rightViewMode = .always
        
        view.addSubview(phoneTextField)
        phoneTextField.autoPinEdge(.top, to: .bottom, of: passwordTextField, withOffset: 12)
        phoneTextField.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        phoneTextField.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        phoneTextField.autoSetDimension(.height, toSize: 40)
        
        view.addSubview(saveButton)
        saveButton.autoSetDimension(.height, toSize: 40)
        saveButton.autoPinEdge(.top, to: .bottom, of: phoneTextField, withOffset:  12)
        saveButton.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        saveButton.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
    }
    
    @objc func saveButtonClicked(){
        
        guard let emailText = emailTextField.text, !emailText.isEmpty,
              let nameText = nameTextField.text, !nameText.isEmpty,
              let passwordText = passwordTextField.text, !passwordText.isEmpty,
              let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty,
              let image = profileButton.imageView?.image
        else {
            self.showError(message: "Please enter your information")
            return
        }
        viewModel.createUser(email: emailText, password: passwordText, phoneNumber: phoneNumber, name: nameText, image: image)
    }
    
    @objc private func showEmailAnimation(){
        let vc = AnimationViewController()
        vc.source = .register
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func toggaleEye(){
        showPassword.toggle()
        let iconName = showPassword ? "eye.slash": "eye"
        passwordTextField.isSecureTextEntry = !showPassword
        eyeIconButton.setImage(UIImage(systemName: iconName), for: .normal)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
}

extension RegisterViewController: RegisterViewModelDelegate {
    func userDidCreate(isSuccess: Bool, message: String) {
        if isSuccess{
            navigationController?.popViewController(animated: true)
        }else {
            self.showError(message: message)
        }
    }
}
