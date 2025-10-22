//
//  HomeViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 14.09.2025.
//
import PureLayout

class HomeViewController: UIViewController {
    
    private let tableView = ChatsTableView()
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        navigationItem.title = "Chats"
        
        navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(newMessageButton))
        navigationItem.rightBarButtonItem?.tintColor = Colors.primary
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(moreButton))
        navigationItem.leftBarButtonItem?.tintColor = Colors.primary 
       
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        
        setUpUI()
    }
    
    private func setUpUI(){
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
        
    }
    
    @objc private func newMessageButton(){
        
    }
    
    @objc private func moreButton(){
        
    }
}
