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
    case bookmark
    
    static let `default`: MainTab = .search
    static let allValues: [MainTab] = [.search, .recent, .bookmark]
    
    var viewController: UIViewController {
        let viewController: UIViewController
        switch self {
        case .search:
            viewController = SearchViewController.create()
        case .recent:
            viewController = RecentViewController.create()
        case .bookmark:
            viewController = BookmarkViewController.create()
        }
        let navigationController = FJNavigationController(rootViewController: viewController)
        let tabBarItem = self.tabBarItem
        navigationController.tabBarItem = tabBarItem
        viewController.navigationItem.title = tabBarItem.title
        return navigationController
    }
    
    var tabBarItem: UITabBarItem {
        // TODO: Language
        let tabBarItem: UITabBarItem
        switch self {
        case .search:
            tabBarItem = UITabBarItem(title: "Search", image: nil, selectedImage: nil)
        case .recent:
            tabBarItem = UITabBarItem(title: "Recent", image: nil, selectedImage: nil)
        case .bookmark:
            tabBarItem = UITabBarItem(title: "Bookmark", image: nil, selectedImage: nil)
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
    
}
