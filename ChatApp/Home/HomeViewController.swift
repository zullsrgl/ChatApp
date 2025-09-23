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
        title = "Chats"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(newMessageButton))
        navigationItem.rightBarButtonItem?.tintColor = Colors.primary
        navigationItem.leftBarButtonItem = nil
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
}
