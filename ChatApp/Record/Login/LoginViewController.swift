//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 23.09.2025.
//

import PureLayout

class LoginViewController: UIViewController{
    
    private lazy var viewModel = LoginViewModel()
    private var bottomConstraint: NSLayoutConstraint?
    var showPassword: Bool = false
    
    private let chatBoxImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "chatbox-icon")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let numberLabel: UILabel = {
        var lbl = UILabel()
        lbl.font = AppFont.regular.font(size: 20)
        lbl.text = "welcome"
        lbl.textAlignment = .center
        lbl.textColor = Colors.darko
        return lbl
    }()
    
    private let explanationLabel: UILabel = {
        var lbl = UILabel()
        lbl.font = AppFont.regular.font(size: 12)
        lbl.text = "Please enter your information"
        lbl.textAlignment = .center
        lbl.textColor = Colors.gray
        return lbl
    }()
    
    private var emailTextField: UITextField = {
        var txt = UITextField()
        txt.textColor = Colors.darko
        txt.font = AppFont.regular.font(size: 16)
        txt.layer.cornerRadius = 12
        txt.layer.borderWidth = 1
        txt.layer.borderColor = Colors.gray.cgColor
        txt.placeholder = "E-mail"
        txt.keyboardType = .emailAddress
        return txt
    }()
    
    private var passwordTextField: UITextField = {
        var txt = UITextField()
        txt.textColor = Colors.darko
        txt.font = AppFont.regular.font(size: 16)
        txt.layer.cornerRadius = 12
        txt.layer.borderWidth = 1
        txt.layer.borderColor = Colors.gray.cgColor
        txt.placeholder = "password"
        txt.isSecureTextEntry = true
        txt.keyboardType = .phonePad
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
    
    private let logInButton: UIButton = {
        var btn = UIButton()
        btn.setTitle("Log In", for: .normal)
        btn.backgroundColor = Colors.primary
        btn.setTitleColor(Colors.darko, for: .normal)
        btn.layer.cornerRadius = 12
        btn.titleLabel?.textColor = Colors.white
        btn.addTarget(self, action: #selector(logInButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    private let registerButton: UIButton = {
        var btn = UIButton()
        btn.setTitle("Register", for: .normal)
        btn.backgroundColor = Colors.primary
        btn.setTitleColor(Colors.darko, for: .normal)
        btn.layer.cornerRadius = 12
        btn.titleLabel?.textColor = Colors.white
        btn.addTarget(self, action: #selector(registerButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        view.backgroundColor = Colors.white
        viewModel.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setUpUI()
    }
    
    private func setUpUI(){
        view.addSubview(registerButton)
        registerButton.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        registerButton.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        registerButton.autoSetDimension(.height, toSize: 40)
        bottomConstraint = registerButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
        
        view.addSubview(logInButton)
        logInButton.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        logInButton.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        logInButton.autoPinEdge(.bottom, to: .top, of: registerButton, withOffset: -16)
        logInButton.autoSetDimension(.height, toSize: 40)
        
        view.addSubview(passwordTextField)
        passwordTextField.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        passwordTextField.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        passwordTextField.autoSetDimension(.height, toSize: 40)
        passwordTextField.autoPinEdge(.bottom, to: .top, of: logInButton, withOffset: -200)
        passwordTextField.rightView = eyeIconButton
        passwordTextField.rightViewMode = .always
        
        view.addSubview(emailTextField)
        emailTextField.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        emailTextField.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        emailTextField.autoSetDimension(.height, toSize: 40)
        emailTextField.autoPinEdge(.bottom, to: .top, of: passwordTextField, withOffset: -16)
        
        view.addSubview(explanationLabel)
        explanationLabel.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        explanationLabel.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        explanationLabel.autoPinEdge(.bottom, to: .top, of: emailTextField, withOffset: -8)
        
        view.addSubview(numberLabel)
        numberLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        numberLabel.autoPinEdge(.bottom, to: .top, of: explanationLabel, withOffset: -8)
        
        view.addSubview(chatBoxImage)
        chatBoxImage.autoSetDimension(.width, toSize: UIScreen.main.bounds.width)
        chatBoxImage.autoSetDimension(.height, toSize: 200)
        chatBoxImage.autoPinEdge(.bottom, to: .top, of: numberLabel, withOffset: 8)
        
       
    }
    
    @objc func logInButtonClicked(){
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              !email.isEmpty, !password.isEmpty
        else {
            self.showError(message: "Please enter your information")
            return
        }
        viewModel.getUser(email: email, password: password)
    }
    
    
    @objc private func registerButtonClicked(){
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    @objc func toggaleEye(){
        showPassword.toggle()
        let iconName = showPassword ? "eye.slash": "eye"
        passwordTextField.isSecureTextEntry = !showPassword
        eyeIconButton.setImage(UIImage(systemName: iconName), for: .normal)
        
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        
        let keyboardHeight = frame.height
        
        bottomConstraint?.constant = -(keyboardHeight + 16)
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        bottomConstraint?.constant = -16
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
}

extension LoginViewController: LoginViewModelDelegate{
    func didCheckEmail(exists: Bool) {
        if exists {
            let vc = TabBarController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)

        } else {
            self.showAlertActiob(message: "Email adress not verifiyed please check your email")
        }
    }
    
    func loginFailed(errorMessage: String) {
        self.showError(message: errorMessage)
    }
}
