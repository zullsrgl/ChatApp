//
//  ChatTableView.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 2.11.2025.
//

import PureLayout

class ChatTableView: UIView {
    
    var chatUserID: String?
    var massages: [Message]? = nil{
        didSet{
            tableView.reloadData()
        }
    }
    
    private let tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = true
        tableView.backgroundColor = Colors.white
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
    func setMessages(massages: [Message]){
        self.massages = massages
        tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return massages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as! ChatTableViewCell
        guard let massages = massages, !massages.isEmpty  else { return  cell}
        
        let message = massages[indexPath.row]
        cell.backgroundColor = .clear
        
        cell.configureUI(text: message.text, time: message.timestamp, isRead: false, isFromCurrentUser: message.senderId == chatUserID)
        return cell
    }
}
