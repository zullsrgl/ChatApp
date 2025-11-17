//
//  HomeViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 14.09.2025.
//
import PureLayout

class HomeViewController: BaseViewController {
    
    private let homeTableView = HomeTableView()
    private lazy var viewModel = HomeViewModel()
    private var chatRoomId: String? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navBarSetUp(title: "Chat", largeTitle: true)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(newMessageButton))
        navigationItem.rightBarButtonItem?.tintColor = Colors.primary
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(moreButton))
        navigationItem.leftBarButtonItem?.tintColor = Colors.primary
        
        homeTableView.delegate = self
        viewModel.delegate = self
        viewModel.getAllUser()
       
        setUpUI()
    }
    
    private func setUpUI(){
        view.addSubview(homeTableView)
        homeTableView.autoPinEdgesToSuperviewSafeArea()
    }
    
    @objc private func newMessageButton(){
        let vc = DirectoryViewController()
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    @objc private func moreButton(){
        //TODO: 
    }
}

extension HomeViewController: HomeTableViewDelegate {
    func cellDidSelect(userId: String) {
        
        let vc = ChatsViewController()
        vc.userID = userId
        vc.chatId = self.chatRoomId
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: DirectoryViewControllerDelegate{
    func teppedNewConversation(userID: String, chatRoomId: String) {
        let vc = ChatsViewController()
        vc.userID = userID
        vc.chatId = chatRoomId
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: HomeViewModelDelegate{
    func chatsFetched(chat: [Chat]) {
        homeTableView.setChats(chats: chat)
    }
}
