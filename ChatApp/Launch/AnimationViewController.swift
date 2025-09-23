//
//  ViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 11.09.2025.
//

import UIKit
import Lottie

enum SourceViewController {
case launch
case register
}

class AnimationViewController: UIViewController {
    
    var source: SourceViewController?
    
    private let animationTitle: UILabel = {
        var lbl = UILabel()
        lbl.font = AppFont.regular.font(size: 20)
        lbl.text = "Please check your email"
        lbl.textAlignment = .center
        lbl.textColor = Colors.darko
        return lbl
    }()
    
    private let animationExplanationLabel: UILabel = {
        var lbl = UILabel()
        lbl.font = AppFont.regular.font(size: 12)
        lbl.text = "We've sent a link to your email address. Please check it. Don't forget to check your spam box."
        lbl.textAlignment = .center
        lbl.textColor = Colors.gray
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let source = source {
            switch source {
            case .launch:
                self.showAnimation(with: "chat", duration: 10)
            case .register:
                self.showAnimation(with: "email", duration: 30)
                configureUI()
            }
        }
        navigationController?.navigationBar.isHidden = true
        
    }
    
    private func configureUI() {
        view.addSubview(animationTitle)
        animationTitle.autoPinEdge(.top, to: .top, of: view, withOffset: 100)
        animationTitle.autoAlignAxis(.vertical, toSameAxisOf: view)
        
        view.addSubview(animationExplanationLabel)
        animationExplanationLabel.autoPinEdge(.top, to: .bottom, of: animationTitle, withOffset: 16)
        animationExplanationLabel.autoAlignAxis(.vertical, toSameAxisOf: view)
        animationExplanationLabel.autoSetDimension(.width, toSize: UIScreen.main.bounds.width - 24)
    }
}
 

