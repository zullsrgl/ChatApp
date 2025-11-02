//
//  ChatsViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 22.09.2025.

import PureLayout
import Kingfisher

class ChatsViewController: BaseViewController {
    
    private var bottomConstraint: NSLayoutConstraint!
    var userID: String? = nil
    
    private var messages = [Message]()
    
    private lazy var viewModel = ChatsViewModel()
    private var tableView = ChatTableView()
    
    private let stackContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = .clear
        stackView.spacing = 8
        stackView.alignment = .bottom
        return stackView
    }()
    
    private let addDocButton: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.tintColor = Colors.secondary
        btn.isUserInteractionEnabled = true
        return btn
    }()
    
    private let messageTextView: UITextView = {
        let txtView = UITextView()
        txtView.isScrollEnabled = false
        txtView.isUserInteractionEnabled = true
        txtView.font = .systemFont(ofSize: 16)
        txtView.backgroundColor = .secondarySystemBackground
        txtView.layer.cornerRadius = 16
        txtView.isEditable = true
        txtView.textContainerInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        return txtView
    }()
    
    private let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Send", for: .normal)
        btn.tintColor = Colors.secondary
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        return btn
    }()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        sendButton.addTarget(self, action: #selector(tappedSentButton), for: .touchUpInside)
        
        if #available(iOS 18.0, *) {
            tabBarController?.isTabBarHidden = true
        } else {
            // Fallback on earlier versions
        }
        
        let leftBtn = self.backButton(vcName: "", target: self, action: #selector(tappedBack))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        
        viewModel.delegate = self
        
        guard let userID = userID else { return }
        viewModel.getUser(with: userID)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        self.navBarAppearance()
        setUpUI()
        
    }
    
    @objc private func tappedBack(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func tappedSentButton() {
        
        guard let text = messageTextView.text,
              let userID = userID, !text.isEmpty
        else {
            self.showError(message: "please enter a message")
            return
        }
        viewModel.chatExists(userID: userID, text: text)
        messageTextView.text = ""
    }
    
    private func setUpUI(){
        view.addSubview(stackContainerView)
        
        stackContainerView.autoPinEdge(toSuperviewEdge: .bottom)
        stackContainerView.autoPinEdge(toSuperviewEdge: .leading, withInset: 8)
        stackContainerView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 8)
        
        bottomConstraint = stackContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24)
        bottomConstraint.isActive = true
        
        stackContainerView.addSubview(addDocButton)
        addDocButton.autoSetDimension(.width, toSize: 24)
        addDocButton.autoPinEdge(.left, to: .left, of: stackContainerView)
        addDocButton.autoPinEdge(.top, to: .top, of: stackContainerView)
        addDocButton.autoPinEdge(.bottom, to: .bottom, of: stackContainerView)
        
        stackContainerView.addSubview(sendButton)
        sendButton.autoSetDimension(.width, toSize: 64)
        sendButton.autoPinEdge(.right, to: .right, of: stackContainerView)
        sendButton.autoPinEdge(.top, to: .top, of: stackContainerView)
        sendButton.autoPinEdge(.bottom, to: .bottom, of: stackContainerView)
        
        stackContainerView.addSubview(messageTextView)
        messageTextView.autoPinEdge(.left, to: .right, of: addDocButton)
        messageTextView.autoPinEdge(.top, to: .top, of: stackContainerView)
        messageTextView.autoPinEdge(.bottom, to: .bottom, of: stackContainerView)
        messageTextView.autoPinEdge(.right, to: .left, of: sendButton, withOffset: -8)
        
        view.addSubview(tableView)
        tableView.autoPinEdge(.top, to: .top, of: view, withOffset: 100)
        tableView.autoPinEdge(.left, to: .left, of: view)
        tableView.autoPinEdge(.right, to: .right, of: view)
        tableView.autoPinEdge(.bottom, to: .top, of: stackContainerView, withOffset: -16)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        bottomConstraint.constant = -keyboardFrame.height - 8
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        bottomConstraint.constant = -24
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension ChatsViewController: ChatsViewModelDelegate {
    func userFetched(user: User) {
        guard let profileImageUrl = user.profileImageUrl else { return }
        setupNavigationTitleView(userName: user.name, profileUrl: profileImageUrl)
    }
}

extension ChatsViewController {
    private func navBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
        appearance.backgroundColor = UIColor.clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupNavigationTitleView(userName: String, profileUrl: String) {
        let stackContainerView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.alignment = .center
            stack.spacing = 8
            return stack
        }()
        
        let profileImageView: UIImageView = {
            let image = UIImageView()
            image.layer.cornerRadius = 20
            image.contentMode = .scaleAspectFill
            image.clipsToBounds = true
            image.image = UIImage(systemName: "plus")
            image.translatesAutoresizingMaskIntoConstraints = false
            
            return image
        }()
        
        let nameLabel: UILabel = {
            let lbl = UILabel()
            lbl.numberOfLines = 1
            lbl.font = .systemFont(ofSize: 16, weight: .medium)
            lbl.textColor = Colors.primary
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.textAlignment = .left
            lbl.text = userName
            return lbl
        }()
        
        stackContainerView.addArrangedSubview(profileImageView)
        profileImageView.autoSetDimension(.height, toSize: 40)
        profileImageView.autoSetDimension(.width, toSize: 40)
        
        profileImageView.kf.setImage(with: URL(string: profileUrl))
        
        stackContainerView.addArrangedSubview(nameLabel)
        navigationItem.titleView = stackContainerView
        stackContainerView.transform = CGAffineTransform(translationX: -60, y: 0)
    }
}

extension ChatsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
         return !(touch.view is UIButton || touch.view is UITextField)
     }
}
