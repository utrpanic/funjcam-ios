import UIKit

protocol MainControllable {
  func activate(with viewController: MainViewControllable)
}

final class MainViewController: UITabBarController, MainViewControllable {
  
  private let controller: MainControllable
  
  init(controller: MainControllable) {
    self.controller = controller
    super.init(nibName: nil, bundle: nil)
    self.controller.activate(with: self)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - MainViewControllable
  
  func setTabs(search: ViewControllable, recent: ViewControllable, bookmark: ViewControllable, settings: ViewControllable) {
    let size: CGFloat = 16
    let weight: UIImage.SymbolWeight = .regular
    let selectedWeight: UIImage.SymbolWeight = .bold
    search.ui.tabBarItem = UITabBarItem(
      title: Resource.string("common:search"),
      image: Resource.image("sun.and.horizon", size: size, weight: weight),
      selectedImage: Resource.image("sun.and.horizon.fill", size: size, weight: selectedWeight)
    )
    recent.ui.tabBarItem = UITabBarItem(
      title: Resource.string("common:recent"),
      image: Resource.image("cloud.drizzle", size: size, weight: weight),
      selectedImage: Resource.image("cloud.drizzle.fill", size: size, weight: selectedWeight)
    )
    bookmark.ui.tabBarItem = UITabBarItem(
      title: Resource.string("common:bookmark"),
      image: Resource.image("umbrella", size: size, weight: weight),
      selectedImage: Resource.image("umbrella.fill", size: size, weight: selectedWeight)
    )
    settings.ui.tabBarItem = UITabBarItem(
      title: Resource.string("common:settings"),
      image: Resource.image("gearshape", size: size, weight: weight),
      selectedImage: Resource.image("gearshape.fill", size: size, weight: selectedWeight)
    )
    self.viewControllers = [search.ui, recent.ui, bookmark.ui, settings.ui]
    self.selectedIndex = 0
  }
}
