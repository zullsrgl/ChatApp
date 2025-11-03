//
//  ChatTableView.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 2.11.2025.
//

import PureLayout

class ChatTableView: UIView {
    var massages: [Message]? = nil
    private let tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = true
        tableView.backgroundColor = Colors.white
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
        tableView.contentInsetAdjustmentBehavior = .automatic
        //tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
    func setMessages(massages: [Message]){
        print("message alll: \(massages)")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let massages = massages, !massages.isEmpty {
            let message = massages[indexPath.row]
            cell.textLabel?.text = message.text
          //  cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        }
        
        return cell
    }
}
