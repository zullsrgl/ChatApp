//
//  HomeViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 14.09.2025.
//
import PureLayout

class HomeViewController: BaseViewController {
    
    private let homeTableView = HomeTableView()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.navBarSetUp(title: "Chats", largeTitle: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(newMessageButton))
        navigationItem.rightBarButtonItem?.tintColor = Colors.primary
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(moreButton))
        navigationItem.leftBarButtonItem?.tintColor = Colors.primary
        
        homeTableView.delegate = self
        setUpUI()
    }
    
    private func setUpUI(){
        view.addSubview(homeTableView)
        homeTableView.autoPinEdgesToSuperviewSafeArea()
    }
    
    @objc private func newMessageButton(){
        let vc = ConverstaionViewController()
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    @objc private func moreButton(){
        //TODO: 
    }
}

extension HomeViewController: HomeTableViewDelegate {
    func cellDidSelect() {
        let vc = ChatsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: ConversationViewControllerDelegate{
    func teppedNewConversation(userID: String) {
        let vc = ChatsViewController()
        vc.userID = userID
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
