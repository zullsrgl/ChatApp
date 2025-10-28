//
//  ChatsTableViewCell.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 19.09.2025.
//

import PureLayout

class HomeTableViewCell: UITableViewCell {
    static let Identifier = "chatsTableViewCell"
    
    private let bgView: UIView = {
       var view = UIView()
        view.backgroundColor = Colors.white
        return view
    }()
    
    private let profilePhoto: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = Colors.secondary
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.image = UIImage(systemName: "person.crop.circle")
        return image
    }()
    
    private let nameLabel: UILabel = {
        var lbl = UILabel()
        lbl.text = "Zülal Sarıoğlu"
        lbl.textColor = Colors.darko
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let messageLabel: UILabel = {
        var lbl = UILabel()
        lbl.textColor = Colors.gray
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let timeLabel: UILabel = {
        var lbl = UILabel()
        lbl.text = "10:40"
        lbl.textColor = Colors.gray
        lbl.textAlignment = .right
        lbl.font = AppFont.medium.font(size: 8)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let messageCountLabel: UILabel = {
        var lbl = UILabel()
        lbl.text = "2"
        lbl.backgroundColor = Colors.secondary
        lbl.textColor = Colors.white
        lbl.textAlignment = .right
        lbl.clipsToBounds = true
        lbl.layer.cornerRadius = 10
        lbl.textAlignment = .center
        lbl.font = AppFont.bold.font(size: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let bottomLine: UIView = {
        var view = UIView()
        view.backgroundColor = Colors.lightGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    private func setupConstraints() {
        contentView.addSubview(bgView)
        bgView.autoPinEdgesToSuperviewEdges()
        
        bgView.addSubview(profilePhoto)
        profilePhoto.autoAlignAxis(.horizontal, toSameAxisOf: bgView)
        profilePhoto.autoPinEdge(.left, to: .left, of: bgView, withOffset: 16)
        profilePhoto.autoSetDimension(.height, toSize: 40)
        profilePhoto.autoSetDimension(.width, toSize: 40)
        
        bgView.addSubview(nameLabel)
        nameLabel.autoPinEdge(.left, to: .right, of: profilePhoto, withOffset: 8)
        nameLabel.autoPinEdge(.top, to: .top, of: profilePhoto)
        
        bgView.addSubview(messageLabel)
        messageLabel.autoPinEdge(.left, to: .right, of: profilePhoto, withOffset: 8)
        messageLabel.autoPinEdge(.top, to: .bottom, of: nameLabel)
        
        bgView.addSubview(timeLabel)
        timeLabel.autoPinEdge(.right, to: .right, of: bgView, withOffset: -16)
        timeLabel.autoPinEdge(.top, to: .top, of: profilePhoto)
        
        bgView.addSubview(messageCountLabel)
        messageCountLabel.autoPinEdge(.right, to: .right, of: bgView, withOffset: -16)
        messageCountLabel.autoPinEdge(.top, to: .bottom, of: timeLabel, withOffset: 8)
        messageCountLabel.autoSetDimension(.height, toSize: 20)
        messageCountLabel.autoSetDimension(.width, toSize: 20)
    
        bgView.addSubview(bottomLine)
        bottomLine.autoPinEdge(.left, to: .left, of: bgView, withOffset: 56)
        bottomLine.autoPinEdge(.right, to: .right, of: bgView)
        bottomLine.autoSetDimension(.height, toSize: 1)
    }
    
    func setCell(index: Int){
        
        messageLabel.text = "Message: \(index)"
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
