//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 23.09.2025.
//

import PureLayout

class LoginViewController: UIViewController, LoginViewModelDelegate{
  
    
    
    private lazy var viewModel = LoginViewModel()
    
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
        lbl.text = "welcome back"
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
        return txt
    }()
    
    private var passwordTextField: UITextField = {
        var txt = UITextField()
        txt.textColor = Colors.darko
        txt.font = AppFont.regular.font(size: 16)
        txt.layer.cornerRadius = 12
        txt.layer.borderWidth = 1
        txt.layer.borderColor = Colors.gray.cgColor
        txt.keyboardType = .phonePad
        txt.placeholder = "Password"
        return txt
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
        
        setUpUI()
    }
    
    private func setUpUI(){
        view.addSubview(chatBoxImage)
        chatBoxImage.autoSetDimension(.width, toSize: UIScreen.main.bounds.width)
        chatBoxImage.autoSetDimension(.height, toSize: 200)
        chatBoxImage.autoPinEdge(.top, to: .top, of: view, withOffset: 200)
        
        view.addSubview(numberLabel)
        numberLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        numberLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        
        view.addSubview(explanationLabel)
        explanationLabel.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        explanationLabel.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        explanationLabel.autoPinEdge(.top, to: .bottom, of: numberLabel, withOffset: 12)
        
        view.addSubview(emailTextField)
        emailTextField.autoPinEdge(.left, to: .left, of: view, withOffset: 40)
        emailTextField.autoPinEdge(.right, to: .right, of: view, withOffset: -40)
        emailTextField.autoSetDimension(.height, toSize: 40)
        emailTextField.autoPinEdge(.top, to: .bottom, of: explanationLabel, withOffset: 24)
        
        view.addSubview(passwordTextField)
        passwordTextField.autoPinEdge(.left, to: .left, of: view, withOffset: 40)
        passwordTextField.autoPinEdge(.right, to: .right, of: view, withOffset: -40)
        passwordTextField.autoSetDimension(.height, toSize: 40)
        passwordTextField.autoPinEdge(.top, to: .bottom, of: emailTextField, withOffset: 24)
        
        view.addSubview(registerButton)
        registerButton.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        registerButton.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        registerButton.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: -40)
        registerButton.autoSetDimension(.height, toSize: 40)
        
        view.addSubview(logInButton)
        logInButton.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        logInButton.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        logInButton.autoPinEdge(.bottom, to: .top, of: registerButton, withOffset: -20)
        logInButton.autoSetDimension(.height, toSize: 40)
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
    
    func didCheckEmail(exists: Bool) {
        if exists {
            navigationController?.pushViewController(HomeViewController(), animated: true)
        }else {
            self.showError(message: "login process failed")
        }
    }
    
    @objc func registerButtonClicked(){
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
}

