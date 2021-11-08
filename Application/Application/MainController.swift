public protocol MainDependency {
  func searchController() -> SearchControllable
  func recentController() -> RecentControllable
  func bookmarkController() -> BookmarkControllable
  func settingsController() -> SettingsControllable
}

public protocol MainViewControllable: ViewControllable {
  func setTabs(search: ViewControllable, recent: ViewControllable, bookmark: ViewControllable, settings: ViewControllable)
}

public final class MainController: MainControllable, SettingsListener {
  
  private let dependency: MainDependency
  weak var viewController: MainViewControllable?
  
  public init(dependency: MainDependency) {
    self.dependency = dependency
  }
  
  public func createViewController() -> ViewControllable {
    return MainViewController(controller: self)
  }
  
  public func activate(with viewController: MainViewControllable) {
    self.viewController = viewController
    self.viewController?.setTabs(
      search: self.dependency.searchController().createViewController(),
      recent: self.dependency.recentController().createViewController(),
      bookmark: self.dependency.bookmarkController().createViewController(),
      settings: self.dependency.settingsController().createViewController()
    )
  }
}

