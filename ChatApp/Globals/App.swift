//
//  App.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 11.09.2025.
//
import UIKit
import SkeletonView

enum AppFont: String {
    case light = "Ubuntu-Light"
    case regular = "Ubuntu-Regular"
    case medium = "Ubuntu-Medium"
    case semiBold = "Ubuntu-SemiBold"
    case bold = "Ubuntu-Bold"
    
    func font(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: self.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}

class BaseViewController: UIViewController {
    
    lazy var profileButton: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "photo.circle.fill"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.contentHorizontalAlignment = .fill
        btn.contentVerticalAlignment = .fill
        btn.layer.borderColor = Colors.primary.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius =  50
        btn.layer.masksToBounds = true
        btn.isHidden = true
        btn.isSkeletonable = true
        btn.tintColor = Colors.primary
        let camera = UIAction(title: "Camera", image: UIImage(systemName: "camera")) { [weak self] _ in
            self?.openCamera()
        }
        let gallery = UIAction(title: "Gallery", image: UIImage(systemName: "photo")) { [weak self] _ in
            self?.openGallery()
        }
        let cancel = UIAction(title: "Cancel", image: UIImage(systemName: "x.circle")) { _ in
            
        }
        
        btn.menu = UIMenu(title: "", children: [camera, gallery, cancel])
        btn.showsMenuAsPrimaryAction = true
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
    }
    
    func navBarSetUp(title: String, largeTitle: Bool) {
        navigationItem.title = title
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        navigationItem.rightBarButtonItem?.tintColor =  Colors.primary
        navigationItem.leftBarButtonItem?.tintColor =  Colors.primary
        
        if largeTitle {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .automatic
        } else {
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationItem.largeTitleDisplayMode = .never
        }
    }
    //MARK: open gallery
    @objc private func openGallery() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        self.present(vc, animated: true)
    }
    //MARK: open Camera
    @objc private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        present(vc, animated: true)
    }
    //MARK: start Animation
    func startAnimation(){
        view.showAnimatedGradientSkeleton(
            usingGradient: .init(baseColor: Colors.gray, secondaryColor: Colors.lightGray),
            animation: GradientDirection.leftRight.slidingAnimation()
        )
    }
    //MARK: stop Animation
    func stopAnimation(){
        view.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
    }
    
    //MARK: Error Label
    func showError(message: String, duration: TimeInterval = 1.0){
        let errorLabel: UILabel = {
            let lbl = UILabel()
            lbl.text = message
            lbl.font = AppFont.medium.font(size: 16)
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
        errorLabel.autoPinEdge(.top, to: .top, of: view, withOffset: 60)
        errorLabel.autoPinEdge(.left, to: .left, of: view, withOffset: 12)
        errorLabel.autoPinEdge(.right, to: .right, of: view, withOffset: -12)
        
        errorLabel.autoSetDimension(.height, toSize: 40)
        errorLabel.autoSetDimension(.width, toSize: UIScreen.main.bounds.width - 16)
        
        UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
            errorLabel.alpha = 0.0
        }){ _ in
            errorLabel.removeFromSuperview()
        }
    }
    
    //MARK: Alert Message
    func showAlertActiob(message: String){
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }
    //MARK: alert message with text field
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
        backBtn.setTitleColor(Colors.primary, for: .normal)
        backBtn.tintColor = Colors.primary
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.addTarget(target, action: action, for: .touchUpInside)
        return backBtn
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
extension BaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage
        if let image = selectedImage {
            profileButton.setImage(image, for: .normal)
            profileButton.imageView?.contentMode = .scaleAspectFill
            profileButton.clipsToBounds = true
            profileButton.layer.cornerRadius = profileButton.bounds.width / 2
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

