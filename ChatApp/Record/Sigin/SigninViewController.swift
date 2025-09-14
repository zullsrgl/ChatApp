//
//  SigninViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 11.09.2025.
//

import PureLayout

class SigninViewController: UIViewController{
    
    private let viewModel = SiginViewModel()
    
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
        lbl.text = "Enter your phone number"
        lbl.textAlignment = .center
        lbl.textColor = Colors.darko
        return lbl
    }()
    
    private let explanationLabel: UILabel = {
        var lbl = UILabel()
        lbl.font = AppFont.regular.font(size: 12)
        lbl.text = "Please enter your phone number starting with zero"
        lbl.textAlignment = .center
        lbl.textColor = Colors.gray
        return lbl
    }()
    
    private var phoneTextField: UITextField = {
        var txt = UITextField()
        txt.textColor = Colors.darko
        txt.font = AppFont.regular.font(size: 16)
        txt.layer.cornerRadius = 12
        txt.layer.borderWidth = 1
        txt.layer.borderColor = Colors.gray.cgColor
        txt.keyboardType = .phonePad
        return txt
    }()
    
    private let nextButton: UIButton = {
        var btn = UIButton()
        btn.setTitle("Next", for: .normal)
        btn.backgroundColor = Colors.primary
        btn.setTitleColor(Colors.darko, for: .normal)
        btn.layer.cornerRadius = 12
        btn.titleLabel?.textColor = Colors.white
        btn.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        view.backgroundColor = Colors.white
        phoneTextField.delegate = self
        
        setUpUI()
    }
    
    private func setUpUI(){
        view.addSubview(chatBoxImage)
        chatBoxImage.autoSetDimension(.width, toSize: UIScreen.main.bounds.width)
        chatBoxImage.autoSetDimension(.height, toSize: 200)
        chatBoxImage.autoPinEdge(.top, to: .top, of: view, withOffset: 100)
        
        view.addSubview(numberLabel)
        numberLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        numberLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        
        view.addSubview(explanationLabel)
        explanationLabel.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        explanationLabel.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        explanationLabel.autoPinEdge(.top, to: .bottom, of: numberLabel, withOffset: 12)
        
        view.addSubview(phoneTextField)
        phoneTextField.autoPinEdge(.left, to: .left, of: view, withOffset: 40)
        phoneTextField.autoPinEdge(.right, to: .right, of: view, withOffset: -40)
        phoneTextField.autoSetDimension(.height, toSize: 40)
        phoneTextField.autoPinEdge(.top, to: .bottom, of: explanationLabel, withOffset: 24)
        
        view.addSubview(nextButton)
        nextButton.autoPinEdge(.left, to: .left, of: view, withOffset: 40)
        nextButton.autoPinEdge(.right, to: .right, of: view, withOffset: -40)
        nextButton.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: -40)
        nextButton.autoSetDimension(.height, toSize: 40)
    }
    
    @objc func nextButtonClicked(){
        if phoneTextField.text?.isEmpty == true {
            self.showError(message: "Please enter your number")
        } else if phoneTextField.text?.count != 10 {
            self.showError(message: "You made an incomplete keystroke")
        }else {
            phoneTextField.resignFirstResponder()
            if let text = phoneTextField.text, !text.isEmpty {
                let number = "+90\(text)"
                DispatchQueue.main.async {
                    self.viewModel.startAuth(phoneNumer: number)
                    self.navigationController?.pushViewController(VerificationViewController(), animated: true)
                }
            }
        }
    }
}

extension SigninViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newLength = currentText.count + string.count - range.length
        
        if newLength > 11 {
            return false
        } else if newLength == 10 {
            DispatchQueue.main.async {
                textField.resignFirstResponder()
            }
            return true
        }
        return true
    }
}
