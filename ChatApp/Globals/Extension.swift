//
//  Extension.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 12.09.2025.
//
import UIKit

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
          
          UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
              errorLabel.alpha = 0.0
          }){ _ in
              errorLabel.removeFromSuperview()
          }
      }
}
