//
//  SettingsTableView.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 21.10.2025.
//

import PureLayout
import FirebaseAuth
import SkeletonView


protocol SettingsTableViewDelegate: AnyObject {
    func tapedProfile()
}

class SettingsTableView: UIView {
    
    private var user: User? = nil
    weak var delegate: SettingsTableViewDelegate?
    
    private let tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = true
        tableView.backgroundColor = Colors.bgWhite
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 40
        tableView.isSkeletonable = true
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        
        
        addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
    func configure(with user: User?) {
        self.user = user
        
        if user == nil {
            DispatchQueue.main.async {
                self.tableView.showAnimatedGradientSkeleton(
                    usingGradient: .init(baseColor: Colors.primary),
                    animation: GradientDirection.leftRight.slidingAnimation(),
                    transition: .crossDissolve(0.25) )
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()){
                self.tableView.stopSkeletonAnimation()
                self.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                self.tableView.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsTableView: UITableViewDelegate, SkeletonTableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
        cell.contentView.layer.borderColor = Colors.lightGray.cgColor
        cell.contentView.layer.borderWidth =  1
        cell.contentView.isSkeletonable = true
        cell.selectionStyle = .none
        
        cell.textLabel?.text = ""
        cell.resetCell()
        
        if indexPath.section == 0 {
            
            if let userName = user?.name,
               let userProfileUrl = user?.profileImageUrl,
               !userName.isEmpty, !userProfileUrl.isEmpty {
                cell.setCellUI(sectionIndex: 0, rowIndex: 0, name: userName, profileUrl: userProfileUrl)
            }
            
        } else if indexPath.section == 1 {
            if indexPath.row == 0  {
                cell.textLabel?.text = "Dark Mode"
                cell.setCellUI(sectionIndex: 1, rowIndex: 0, name: "", profileUrl: "")
                
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Log Out"
                cell.textLabel?.textColor = Colors.red
                cell.textLabel?.textAlignment = .left
                cell.setCellUI(sectionIndex: 1, rowIndex: 1, name: "", profileUrl: "")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            delegate?.tapedProfile()
            
        } else if indexPath.section == 1 && indexPath.row == 1 {
            do {
                try Auth.auth().signOut()
                
                let loginVC = LoginViewController()
                let nav = UINavigationController(rootViewController: loginVC)
                
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
                   let window = sceneDelegate.window {
                    window.rootViewController = nav
                    window.makeKeyAndVisible()
                }
                
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return SettingsTableViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}
