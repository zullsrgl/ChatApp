//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 23.09.2025.
//

import PureLayout
import Lottie

class RegisterViewController: BaseViewController {
    
    private lazy var viewModel = RegisterViewModel()
    
    private var nameTextField: UITextField = {
        var txt = UITextField()
        txt.textColor = Colors.darko
        txt.font = AppFont.regular.font(size: 16)
        txt.layer.cornerRadius = 20
        txt.layer.borderWidth = 1
        txt.layer.borderColor = Colors.gray.cgColor
        txt.placeholder = "Full Name"
        return txt
    }()
    
    private var emailTextField: UITextField = {
        var txt = UITextField()
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
    
    private var passwordTextField: UITextField = {
        var txt = UITextField()
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
        return btn
    }()
    
    private var phoneTextField: UITextField = {
        var txt = UITextField()
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
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftBarBtn = self.backButton(vcName: "Login", target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarBtn)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showEmailAnimation), name: .emailVerificationSent, object: nil)
        viewModel.delegate = self
        
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        eyeIconButton.addTarget(self, action: #selector(toggleEye), for: .touchUpInside)
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
        nameTextField.setLeftPadding(12)
        nameTextField.autoPinEdge(.top, to: .bottom, of: profileButton, withOffset: 12)
        nameTextField.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        nameTextField.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        nameTextField.autoSetDimension(.height, toSize: 40)
        
        view.addSubview(emailTextField)
        emailTextField.setLeftPadding(12)
        emailTextField.autoPinEdge(.top, to: .bottom, of: nameTextField, withOffset: 12)
        emailTextField.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        emailTextField.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        emailTextField.autoSetDimension(.height, toSize: 40)
        
        view.addSubview(passwordTextField)
        passwordTextField.setLeftPadding(12)
        passwordTextField.autoPinEdge(.top, to: .bottom, of: emailTextField, withOffset: 12)
        passwordTextField.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        passwordTextField.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        passwordTextField.autoSetDimension(.height, toSize: 40)
        
        passwordTextField.rightView = eyeIconButton
        passwordTextField.rightViewMode = .always
        
        view.addSubview(phoneTextField)
        phoneTextField.setLeftPadding(12)
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
        
        view.endEditing(false)
        viewModel.createUser(email: emailText, password: passwordText, phoneNumber: phoneNumber, name: nameText, image: image)
    }
    
    @objc private func showEmailAnimation(){
        let animationView: LottieAnimationView?
        animationView = .init(name: "email")
        animationView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        animationView?.center = view.center
        animationView?.backgroundColor = Colors.primary
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        
        guard let animation = animationView else { return }
        
        view.addSubview(animation)
        
        animationView?.play()
        
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func toggleEye(){
        let isSecure = passwordTextField.isSecureTextEntry
        
        let iconName = isSecure ? "eye.slash": "eye"
        passwordTextField.isSecureTextEntry = !isSecure
        eyeIconButton.setImage(UIImage(systemName: iconName), for: .normal)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
}

extension RegisterViewController: RegisterViewModelDelegate {
    func userDidCreate(isSuccess: Bool, message: String) {
        if isSuccess{
            self.showEmailAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.showError(message: message)
        }
    }
}
