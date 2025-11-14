//
//  ChatsTableView.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 19.09.2025.
//

import PureLayout


protocol HomeTableViewDelegate: AnyObject {
    func cellDidSelect(userId: String)
}

class HomeTableView: UIView {
    
    weak var delegate: HomeTableViewDelegate?
    
    private var users: [User]? = nil
    private var lastMessage: Message? = nil
    public var unReadMessageCount: Int = 0
    
    private let searchBar: UISearchBar = {
        var view = UISearchBar()
        view.placeholder = "Search"
        view.keyboardType = .default
        view.searchBarStyle = .default
        view.backgroundColor = Colors.white
        view.showsCancelButton = false
        view.backgroundImage = UIImage()
        return view
    }()
    
    private let tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = true
        tableView.backgroundColor = Colors.white
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
        tableView.contentInsetAdjustmentBehavior = .automatic
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.Identifier)
        searchBar.delegate = self
        
        addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
        searchBar.sizeToFit()
        tableView.tableHeaderView?.backgroundColor = Colors.white
        tableView.tableHeaderView = searchBar
        
    }
    
    func getUsers(users:[User]){
        self.users = users
        tableView.reloadData()
    }
    
    func getLastMessage(lastMessage: Message){
        self.lastMessage = lastMessage
        tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let users = users, !users.isEmpty else { return 0 }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.Identifier, for: indexPath) as! HomeTableViewCell
        guard let users = users,let lastMessage = lastMessage, !users.isEmpty else { return cell }
        cell.setCell(user: users[indexPath.row], lastMessage: lastMessage, unReadMessageCount: unReadMessageCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let users = users, !users.isEmpty else { return  }
        delegate?.cellDidSelect(userId: users[indexPath.row].uid)
    }
}


extension HomeTableView: UISearchBarDelegate {
    //TODO: filtering operations
}
