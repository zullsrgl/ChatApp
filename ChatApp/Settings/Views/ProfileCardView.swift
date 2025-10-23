//
//  ProfileCardView.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 23.10.2025.
//

import UIKit
import FirebaseAuth
import Kingfisher
import SkeletonView

protocol ProfileCardViewDelegate: AnyObject {
    func didTapEditProfile()
}


class ProfileCardView: UIView {
    
    weak var delegate: ProfileCardViewDelegate?
    
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = Colors.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isSkeletonable = true
        return view
    }()
    
    private let profileBgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = Colors.white
        view.layer.borderColor = Colors.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.isSkeletonable = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    private let profileImage: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "persone")
        image.layer.cornerRadius = 32
        image.layer.masksToBounds = true
        image.layer.borderWidth = 1
        image.layer.borderColor = Colors.lightGray.cgColor
        image.isSkeletonable = true
        return image
    }()
    
    private let fullNameLabel: UILabel = {
        var lbl = UILabel()
        lbl.textColor = Colors.darko
        lbl.text = "Zülal Sarıoğlu"
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.isSkeletonable = true
        return lbl
    }()
    
    private let logOutBtn: UIButton = {
        var btn = UIButton()
        btn.setTitle("Log Out", for: .normal)
        btn.setTitleColor(Colors.red, for: .normal)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = Colors.white
        btn.layer.borderColor = Colors.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.isUserInteractionEnabled = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(tappedLogOut), for: .touchUpInside)
        return btn
    }()
    
    private let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isSkeletonable = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedProfileCard))
        addGestureRecognizer(gesture)
        setUpUI()
        
    }
    
    private func setUpUI(){
        addSubview(bgView)
        bgView.autoPinEdge(.left, to: .left, of: self)
        bgView.autoPinEdge(.right, to: .right, of: self)
        bgView.autoSetDimension(.height, toSize: 140)
        
        bgView.addSubview(profileBgView)
        profileBgView.autoPinEdge(.top, to: .top, of: bgView)
        profileBgView.autoPinEdge(.left, to: .left, of: self)
        profileBgView.autoPinEdge(.right, to: .right, of: self)
        profileBgView.autoSetDimension(.height, toSize: 80)
        
        profileBgView.addSubview(profileImage)
        profileImage.autoSetDimension(.height, toSize: 64)
        profileImage.autoSetDimension(.width, toSize: 64)
        profileImage.autoPinEdge(.left, to: .left, of: profileBgView, withOffset: 12)
        profileImage.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        profileBgView.addSubview(fullNameLabel)
        fullNameLabel.autoPinEdge(.left, to: .right, of: profileImage, withOffset: 8)
        fullNameLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        profileBgView.addSubview(arrowImageView)
        arrowImageView.autoPinEdge(.right, to: .right, of: profileBgView, withOffset: -8)
        arrowImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        arrowImageView.tintColor = Colors.red
        
        bgView.addSubview(logOutBtn)
        logOutBtn.autoPinEdge(.top, to: .bottom, of: profileBgView, withOffset: 16)
        logOutBtn.autoPinEdge(.left, to: .left, of: bgView)
        logOutBtn.autoPinEdge(.right, to: .right, of: bgView)
        logOutBtn.autoSetDimension(.height, toSize: 40)
        
        
        startAnimation()
    }
    
    private func startAnimation(){
        self.showAnimatedGradientSkeleton(
            usingGradient: .init(baseColor: .concrete, secondaryColor: .lightGray),
            animation: GradientDirection.leftRight.slidingAnimation()
        )
    }
    
    private func stopAnimation(){
        hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
    }
    
    func canfigure(user: User){
        
        fullNameLabel.text = user.name
        
        guard let imageUrl = user.profileImageUrl else  {  return  }
        
        if let url = URL(string: imageUrl) {
            profileImage.kf.setImage(with: url)
            stopAnimation()
        }else {
            profileImage.image = UIImage(systemName: "person.crop.circle")
            stopAnimation()
        }
    }
    @objc func tappedProfileCard(){
        delegate?.didTapEditProfile()
    }
    
    
    @objc func tappedLogOut() {
        do {
            try Auth.auth().signOut()
            
            let loginVC = LoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                window.rootViewController = nav
                window.makeKeyAndVisible()
            }
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
