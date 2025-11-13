//
//  ChatTableViewCell.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 4.11.2025.
//

import PureLayout

class ChatTableViewCell: UITableViewCell {
    
    static let identifier = "ChatTableViewCellIdentifier"
    
    private let bgView : UIView = {
        let view = UIView()
        view.backgroundColor = Colors.primary
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let textLbl: UILabel = {
        var lbl = UILabel()
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.font = AppFont.regular.font(size: 16)
        lbl.textColor = Colors.white
        return lbl
    }()
    
    private let timeLbl : UILabel = {
        var lbl = UILabel()
        lbl.textAlignment = .left
        lbl.font = AppFont.bold.font(size: 8)
        lbl.textColor = Colors.white
        return lbl
    }()
    
    private let isReadImage: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        image.tintColor = Colors.primary
        image.image = UIImage(systemName: "checkmark")
        return image
    }()
    
    private var leftConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
    }
    
    private func setUpCell() {
        
        contentView.addSubview(bgView)
        bgView.autoPinEdge(toSuperviewEdge: .top, withInset: 2)
        bgView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 4)
        bgView.autoSetDimension(.width, toSize: UIScreen.main.bounds.width * 0.7, relation: .lessThanOrEqual)
        bgView.autoSetDimension(.width, toSize: 100, relation: .greaterThanOrEqual)
        
        leftConstraint = bgView.autoPinEdge(toSuperviewEdge: .left, withInset: 8)
        rightConstraint = bgView.autoPinEdge(toSuperviewEdge: .right, withInset: 8)
        
        leftConstraint?.isActive = false
        rightConstraint?.isActive = true
        
        bgView.addSubview(textLbl)
        textLbl.autoPinEdge(.left, to: .left, of: bgView, withOffset: 8)
        textLbl.autoPinEdge(.right, to: .right, of: bgView, withOffset: -8)
        textLbl.autoPinEdge(.top, to: .top, of: bgView, withOffset: 4)
        textLbl.autoPinEdge(.bottom, to: .bottom, of: bgView, withOffset: -12)
        
        bgView.addSubview(isReadImage)
        isReadImage.autoPinEdge(.right, to: .right, of: bgView, withOffset: -8)
        isReadImage.autoSetDimension(.height, toSize: 10)
        isReadImage.autoSetDimension(.width, toSize: 10)
        isReadImage.autoPinEdge(.bottom, to: .bottom, of: bgView)
        
        bgView.addSubview(timeLbl)
        timeLbl.autoPinEdge(.right, to: .left, of: isReadImage, withOffset: -4)
        timeLbl.autoSetDimension(.height, toSize: 10)
        timeLbl.autoSetDimension(.width, toSize: 24)
        timeLbl.autoPinEdge(.bottom, to: .bottom, of: bgView)
    }
    
    func configureUI(text: String, time: String, isRead: Bool, isFromCurrentUser: Bool) {
        textLbl.text = text
        
        if isRead {
            isReadImage.tintColor = Colors.primary
        } else {
            isReadImage.tintColor = Colors.lightGray
        }
        
        if let date = Date.from(time) {
            timeLbl.text = date.formattedTime
        }
        
        if isFromCurrentUser {
            bgView.backgroundColor = Colors.gray
            textLbl.textColor = Colors.darko
            rightConstraint?.isActive = false
            leftConstraint?.isActive = true
        } else {
            bgView.backgroundColor = Colors.primary
            textLbl.textColor = Colors.white
            leftConstraint?.isActive = false
            rightConstraint?.isActive = true
        }
        
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
