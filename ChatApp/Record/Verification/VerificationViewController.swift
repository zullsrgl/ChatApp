//
//  VerificationViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 14.09.2025.
//

import PureLayout

class VerificationViewController: UIViewController {
    
    private let viewModel = VerificationViewModel()
    
    private var codeTextField: UITextField = {
        var txt = UITextField()
        txt.textColor = Colors.darko
        txt.font = AppFont.regular.font(size: 16)
        txt.layer.cornerRadius = 12
        txt.layer.borderWidth = 1
        txt.layer.borderColor = Colors.gray.cgColor
        txt.returnKeyType = .continue
        return txt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        codeTextField.delegate = self
        setUpUI()
    }
    
    private func setUpUI(){
        view.addSubview(codeTextField)
        codeTextField.autoAlignAxis(.vertical, toSameAxisOf: view)
        codeTextField.autoAlignAxis(.horizontal, toSameAxisOf: view)
        codeTextField.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
        codeTextField.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
        codeTextField.autoSetDimension(.height, toSize: 40)
    }
}

extension VerificationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text, !text.isEmpty {
            let code = text
            viewModel.verifyCode(smsCode: code)
            
            DispatchQueue.main.async {
                let vc = ProfileNameViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
        return true
    }
    
}
