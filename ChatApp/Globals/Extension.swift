//
//  Extension.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 12.09.2025.
//
import UIKit
import Lottie

extension UIViewController{
    
    //MARK: Error Label
    
    func showError(message: String, duration: TimeInterval = 1.0){
        let errorLabel: UILabel = {
            let lbl = UILabel()
            lbl.text = message
            lbl.font = .systemFont(ofSize: 16)
            lbl.textColor = Colors.white
            lbl.textAlignment = .center
            lbl.backgroundColor = Colors.red
            lbl.layer.cornerRadius = 10
            lbl.numberOfLines = 0
            lbl.clipsToBounds = true
            lbl.alpha = 1.0
            return lbl
        }()
        
        self.view.addSubview(errorLabel)
        errorLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        errorLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        
        errorLabel.autoSetDimension(.height, toSize: 40)
        errorLabel.autoSetDimension(.width, toSize: UIScreen.main.bounds.width - 16)
        
        UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
            errorLabel.alpha = 0.0
        }){ _ in
            errorLabel.removeFromSuperview()
        }
    }
    //MARK: Lottie
    func showAnimation(with animation: String, duration: Double) {
        let animationView = LottieAnimationView(name: animation)
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        view.addSubview(animationView)
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            let logInVC = LoginViewController()
            self.navigationController?.setViewControllers([logInVC], animated: false)
        }
    }
    //MARK: Alert Message
    func showAlertActiob(message: String){
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }
    
    func showTextFieldAlert(title: String, message: String, placheHolderText: String,completion: @escaping (String) -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { txtField in
            txtField.keyboardType = .emailAddress
            txtField.placeholder = placheHolderText
            txtField.autocapitalizationType = .none
            txtField.autocorrectionType = .no
        }
        
        let sendAction = UIAlertAction(title: "Send", style: .default) { _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                completion(text)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(sendAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    //MARK: Back Button
    func backButton(vcName: String, target: Any? , action: Selector) -> UIButton {
        let backBtn = UIButton()
        backBtn.isUserInteractionEnabled = true
        backBtn.setTitle(vcName, for: .normal)
        backBtn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backBtn.setTitleColor(Colors.secondary, for: .normal)
        backBtn.tintColor = Colors.primary
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.addTarget(target, action: action, for: .touchUpInside)
        return backBtn
    }
}

extension Notification.Name {
    static let emailVerificationSent = Notification.Name("emailVerificationSent")
}


