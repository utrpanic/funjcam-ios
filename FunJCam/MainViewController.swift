//
//  MainViewController.swift
//  FunJCam
//
//  Created by boxjeon on 2017. 1. 12..
//  Copyright © 2017년 the42apps. All rights reserved.
//

enum MainTab: Int {
    case search
    case recent
    case settings
    
    static let `default`: MainTab = .search
    static let allValues: [MainTab] = [.search, .recent, .settings]
    
    var viewController: UIViewController {
        let viewController: UIViewController
        switch self {
        case .search:
            viewController = SearchViewController.create()
        case .recent:
            viewController = RecentViewController.create()
        case .settings:
            viewController = SettingsViewController.create()
        }
        let navigationController = FJNavigationController(rootViewController: viewController)
        let tabBarItem = self.tabBarItem
        navigationController.tabBarItem = tabBarItem
        viewController.navigationItem.title = tabBarItem.title
        return navigationController
    }
    
    var tabBarItem: UITabBarItem {
        let tabBarItem: UITabBarItem
        switch self {
        case .search:
            tabBarItem = UITabBarItem(title: "common:search".localized(), image: nil, selectedImage: nil)
        case .recent:
            tabBarItem = UITabBarItem(title: "common:recent".localized(), image: nil, selectedImage: nil)
        case .settings:
            tabBarItem = UITabBarItem(title: "common:settings".localized(), image: nil, selectedImage: nil)
        }
        tabBarItem.tag = self.rawValue
        return tabBarItem
    }
}

class MainViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupChildViewControllers()
        
        self.setupTabBar()
    }
    
    func setupChildViewControllers() {
        self.viewControllers = MainTab.allValues.map({ $0.viewController })
        self.delegate = self
        self.selectedIndex = MainTab.default.rawValue
    }
    
    func setupTabBar() {
        self.tabBar.backgroundColor = .white
    }
    
    // MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == self.selectedViewController {
            let navigationController = viewController as? UINavigationController
            if navigationController?.viewControllers.count == 1 {
            (navigationController?.topViewController as? HasScrollView)?.scrollToTop(animated: true)
            }
        }
        return true
    }
    
}
