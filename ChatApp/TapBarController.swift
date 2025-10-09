//
//  TapBarController.swift
//  ChatApp
//
//  Created by Zülal Sarıoğlu on 19.09.2025.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        let appearance = UITabBarAppearance()
        super.viewDidLoad()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .systemBackground
        appearance.backgroundEffect = UIBlurEffect(style: .light)
        appearance.stackedLayoutAppearance.selected.iconColor = Colors.secondary
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: Colors.secondary]
        appearance.stackedLayoutAppearance.normal.iconColor = Colors.gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: Colors.gray]
        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        configureTabs()
    }
    private func configureTabs() {
        
        let homeVC = HomeViewController()
        let settingsVC = SettingsViewController()
        
        homeVC.tabBarItem = UITabBarItem(title: "Message", image: UIImage(systemName: "message"), tag: 1)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        viewControllers = [homeNav,settingsNav]
    }
}
