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
    private var showPassword: Bool = false
    
    
    private let stackContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 300, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    
    private let chatBoxImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "chatbox-icon")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
        return image
    }()
    
    private let appNameLabel: UILabel = {
        var lbl = UILabel()
        lbl.font = AppFont.bold.font(size: 32)
        lbl.text = "Chatting"
        lbl.textAlignment = .center
        lbl.textColor = Colors.secondary
        return lbl
    }()
    
    private let explanationLabel: UILabel = {
        var lbl = UILabel()
        lbl.font = AppFont.regular.font(size: 18)
        lbl.text = "Welcome to Chatting, enter your information."
        lbl.textAlignment = .center
        lbl.textColor = Colors.gray
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private var emailTextField: PaddingTextField = {
        var txt = PaddingTextField()
        txt.textColor = Colors.darko
        txt.font = AppFont.regular.font(size: 16)
        txt.layer.cornerRadius = 20
        txt.layer.borderWidth = 1
        txt.layer.borderColor = Colors.gray.cgColor
        txt.placeholder = "E-mail"
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
        btn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
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
        btn.setTitleColor(Colors.white, for: .normal)
        btn.layer.cornerRadius = 20
        btn.titleLabel?.textColor = Colors.white
        btn.addTarget(self, action: #selector(logInButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    private let registerButton: UIButton = {
        var btn = UIButton()
        
        let fullText = NSMutableAttributedString(string: "Don't you have an account?/",attributes: [
            .foregroundColor: Colors.darko,
            .font: AppFont.regular.font(size: 16)])
        
        fullText.append(NSAttributedString(string: " Sign Up", attributes: [
            .foregroundColor: Colors.secondary,
            .font: AppFont.bold.font(size: 16)]))
        
        btn.setAttributedTitle(fullText, for: .normal)
        btn.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return btn
    }()
    
    private let resetPassword: UIButton = {
        var btn = UIButton()
        
        let fullText = NSMutableAttributedString(string: "I forgot my password",attributes: [
            .foregroundColor: Colors.secondary,
            .font: AppFont.bold.font(size: 16)])
        
        btn.setAttributedTitle(fullText, for: .normal)
        btn.addTarget(self, action: #selector(resetPasswordTapped), for: .touchUpInside)
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
        
        view.addSubview(stackContainerView)
        stackContainerView.autoPinEdgesToSuperviewEdges()
        
        stackContainerView.addArrangedSubview(appNameLabel)
        appNameLabel.autoSetDimension(.height, toSize: 40)
        
        stackContainerView.addArrangedSubview(chatBoxImage)
        
        stackContainerView.addArrangedSubview(explanationLabel)
        explanationLabel.autoSetDimension(.height, toSize: 60)
        
        stackContainerView.addArrangedSubview(emailTextField)
        emailTextField.autoSetDimension(.height, toSize: 40)
        
        stackContainerView.addArrangedSubview(passwordTextField)
        passwordTextField.autoSetDimension(.height, toSize: 40)
        passwordTextField.rightView = eyeIconButton
        passwordTextField.rightViewMode = .always
        
        stackContainerView.addArrangedSubview(logInButton)
        logInButton.autoSetDimension(.height, toSize: 40)
        
        stackContainerView.addArrangedSubview(registerButton)
        registerButton.autoSetDimension(.height, toSize: 40)
        
        stackContainerView.addArrangedSubview(resetPassword)
        resetPassword.autoSetDimension(.height, toSize: 20)
        
        bottomConstraint = stackContainerView.autoPinEdge(.bottom, to: .bottom, of: view)
        
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
    
    
    @objc private func signUpTapped(){
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    @objc private func resetPasswordTapped(){
        self.showTextFieldAlert(title: "I forgot my password", message: "Enter your email address", placheHolderText: "e-mail") { txt in
            self.viewModel.resetPassword(email: txt)
        }
    }
    
    @objc func toggaleEye(){
        showPassword.toggle()
        let iconName = showPassword ? "eye": "eye.slash"
        passwordTextField.isSecureTextEntry = !showPassword
        eyeIconButton.setImage(UIImage(systemName: iconName), for: .normal)
        
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        
        
        bottomConstraint?.constant = -16
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        bottomConstraint?.constant = 300
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
}

extension LoginViewController: LoginViewModelDelegate{
    func passwordResetDidFinish(message: String) {
        self.showAlertActiob(message: message)
    }
    
    func didCheckEmail(exists: Bool, message: String) {
        if exists {
            let vc = TabBarController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            
        } else {
            self.showAlertActiob(message: message)
        }
    }
    
    func loginFailed(errorMessage: String) {
        self.showError(message: errorMessage)
    }
}
