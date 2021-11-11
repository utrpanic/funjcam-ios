public protocol MainDependency {
  func searchBuilder() -> Buildable
  func recentBuilder() -> Buildable
  func bookmarkBuilder() -> Buildable
  func settingsBuilder() -> Buildable
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
      search: self.dependency.searchBuilder().createViewController(),
      recent: self.dependency.recentBuilder().createViewController(),
      bookmark: self.dependency.bookmarkBuilder().createViewController(),
      settings: self.dependency.settingsBuilder().createViewController()
    )
  }
}

