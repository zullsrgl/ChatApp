//
//  Extension.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 12.09.2025.
//
import UIKit
import Lottie

extension UIViewController{
    
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
}

extension Notification.Name {
    static let emailVerificationSent = Notification.Name("emailVerificationSent")
}
