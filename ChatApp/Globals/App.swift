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


class PaddingTextField: UITextField {
    var textpadding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textpadding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textpadding)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textpadding)
    }
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 8
        return rect
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
        
        view.addSubview(profileButton)
        profileButton.autoPinEdge(.top, to: .top, of: view, withOffset: 100)
        profileButton.autoSetDimension(.height, toSize: 100)
        profileButton.autoSetDimension(.width, toSize: 100)
        profileButton.autoAlignAxis(.vertical, toSameAxisOf: view)
    }
    
    
    
    @objc private func openGallery() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        self.present(vc, animated: true)
    }
    
    @objc private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func startAnimation(){
        view.showAnimatedGradientSkeleton(
            usingGradient: .init(baseColor: Colors.gray, secondaryColor: Colors.lightGray),
            animation: GradientDirection.leftRight.slidingAnimation()
        )
    }
    
    func stopAnimation(){
        view.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
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

