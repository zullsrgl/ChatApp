//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 29.10.2025.
//
import PureLayout

protocol DirectoryViewControllerDelegate: AnyObject {
    func teppedNewConversation(userID: String, chatRoomId: String)
}

class DirectoryViewController: BaseViewController{
    
    lazy var chatRoomId: String? = nil
    private var selectedUser: User?
    weak var delegate: DirectoryViewControllerDelegate?
    
    private var users: [User]? = nil
    private var filteredUsers: [User]? = nil
    
    private var searchBar: UISearchBar = {
      var search = UISearchBar()
        search.placeholder = "Search for Users..."
        return search
    }()
    
    private var tableView: UITableView = {
       var table = UITableView()
        table.isHidden = true
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private lazy var viewModel = DirectoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        navigationItem.rightBarButtonItem?.tintColor = Colors.primary
        searchBar.becomeFirstResponder()
        
        viewModel.delegate = self
        viewModel.getAllUser()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
        
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true)
    }
}

extension DirectoryViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return}
    
        if !text.isEmpty {
            filteredUsers = users?.filter{ $0.name.lowercased().contains(text.lowercased())}
        }else {
            filteredUsers = users
        }
        
        tableView.reloadData()
    }
    
}

extension DirectoryViewController: DirectoryViewModelDelegate {
    
    func chatRoomIdCreated(chatRoomId: String) {
           guard let selectedUser = selectedUser else { return }
           delegate?.teppedNewConversation(userID: selectedUser.uid, chatRoomId: chatRoomId)
           dismissSelf()
       }
    
    func usersFetched(users: [User]) {
        self.users = users
        filteredUsers = users
        
        tableView.isHidden = false
        tableView.reloadData()
    }
}


extension DirectoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let users = filteredUsers, users.count > 0  else {
            return 0
        }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        guard let userName = filteredUsers?[indexPath.row].name else { return cell}
        cell.textLabel?.text = userName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = filteredUsers?[indexPath.row] else { return }
        selectedUser = user
        viewModel.existsChat(with: user.uid)
    }
}
