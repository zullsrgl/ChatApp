//
//  ViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 11.09.2025.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimation()
    }
    
    func showAnimation() {
        let animationView = LottieAnimationView(name: "chat")
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.loopMode = .playOnce
        animationView.play { finished in
            let signVC = SigninViewController()
            self.navigationController?.setViewControllers([signVC], animated: false)
        }
        view.addSubview(animationView)
    }
}
 

