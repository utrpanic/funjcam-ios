import UIKit

protocol MainControllable {
  func activate()
}

final class MainViewController: UITabBarController, MainViewControllable, UITabBarControllerDelegate {
  
  private let controller: MainControllable
  
  init(controller: MainControllable) {
    self.controller = controller
    super.init(nibName: nil, bundle: nil)
    self.setupTabBar()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.controller.activate()
  }
  
  private func setupTabBar() {
    self.tabBar.backgroundColor = .white
  }
  
  // MARK: - MainViewControllable
  
  func setTabs(search: ViewControllable, recent: ViewControllable, bookmark: ViewControllable, settings: ViewControllable) {
    search.ui.tabBarItem = UITabBarItem(title: Resource.string("common:search"),
                                        image: nil,
                                        selectedImage: nil)
    recent.ui.tabBarItem = UITabBarItem(title: Resource.string("common:recent"),
                                        image: nil,
                                        selectedImage: nil)
    bookmark.ui.tabBarItem = UITabBarItem(title: Resource.string("common:bookmark"),
                                          image: nil,
                                          selectedImage: nil)
    settings.ui.tabBarItem = UITabBarItem(title: Resource.string("common:settings"),
                                          image: nil,
                                          selectedImage: nil)
    self.viewControllers = [search.ui, recent.ui, bookmark.ui, settings.ui]
    self.selectedIndex = 0
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
