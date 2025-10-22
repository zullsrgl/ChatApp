//
//  ChatsTableView.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 19.09.2025.
//

import PureLayout

class ChatsTableView: UIView {
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
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatsTableViewCell.self, forCellReuseIdentifier: ChatsTableViewCell.Identifier)
        searchBar.delegate = self
        
        addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
        searchBar.sizeToFit()
        tableView.tableHeaderView?.backgroundColor = Colors.white
        tableView.tableHeaderView = searchBar
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatsTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatsTableViewCell.Identifier, for: indexPath) as! ChatsTableViewCell
        cell.setCell(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


extension ChatsTableView: UISearchBarDelegate {
    //TODO: filtering operations
}
