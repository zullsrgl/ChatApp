//
//  SettingsTableViewCell.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 21.10.2025.
//

import PureLayout
import Kingfisher
import SkeletonView

class SettingsTableViewCell: UITableViewCell {
    
    static let identifier = "SettingsTableViewCell"
    
    private let profileImage: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "persone")
        image.layer.cornerRadius = 32
        image.layer.masksToBounds = true
        image.layer.borderWidth = 1
        image.layer.borderColor = Colors.lightGray.cgColor
        return image
    }()
    
    private let fullNameLabel: UILabel = {
        var lbl = UILabel()
        lbl.textColor = Colors.darko
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let darkModeSwitch: UISwitch = {
        var view = UISwitch()
        view.isOn = false
        view.isHidden = true
        view.addTarget(self, action: #selector(darkModeToggled), for: .valueChanged)
        return view
    }()
    
    private let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.layer.cornerRadius = 10
        contentView.addSubview(profileImage)
        profileImage.autoSetDimension(.height, toSize: 64)
        profileImage.autoSetDimension(.width, toSize: 64)
        profileImage.autoPinEdge(.left, to: .left, of: self, withOffset: 12)
        profileImage.autoAlignAxis(toSuperviewAxis: .horizontal)
        profileImage.isSkeletonable = true
        
        contentView.addSubview(fullNameLabel)
        fullNameLabel.autoPinEdge(.left, to: .right, of: profileImage, withOffset: 8)
        fullNameLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        fullNameLabel.isSkeletonable = true
        
        contentView.addSubview(darkModeSwitch)
        darkModeSwitch.autoPinEdge(.right, to: .right, of: contentView, withOffset: -8)
        darkModeSwitch.autoAlignAxis(toSuperviewAxis: .horizontal)
        darkModeSwitch.isSkeletonable = true
        
        contentView.addSubview(arrowImageView)
        arrowImageView.autoPinEdge(.right, to: .right, of: contentView, withOffset: -8)
        arrowImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        arrowImageView.tintColor = Colors.red
        arrowImageView.isHidden = true
        arrowImageView.isSkeletonable = true
        
        contentView.isSkeletonable = true
        isSkeletonable = true
    }
    
    
    func setCellUI(sectionIndex: Int, rowIndex: Int, name: String, profileUrl: String){
        
        if sectionIndex == 0 {
            fullNameLabel.text = name
            fullNameLabel.isHidden = false
            profileImage.isHidden = false
            arrowImageView.isHidden = false
            arrowImageView.tintColor = Colors.secondary
            
            if let url = URL(string: profileUrl){
                profileImage.kf.setImage(with: url)
            } else {
                profileImage.image = UIImage(systemName: "person.crop.circle")
            }
        } else if sectionIndex == 1 {
            
            if rowIndex == 0 {
                darkModeSwitch.isHidden = false
                arrowImageView.isHidden = true
                
            } else if rowIndex == 1 {
                darkModeSwitch.isHidden = true
                arrowImageView.isHidden = false
            }
        }
    }
    
    func resetCell() {
        fullNameLabel.text = nil
        fullNameLabel.isHidden = true
        profileImage.image = nil
        profileImage.isHidden = true
        darkModeSwitch.isHidden = true
        
    }
    
    @objc private func darkModeToggled() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
