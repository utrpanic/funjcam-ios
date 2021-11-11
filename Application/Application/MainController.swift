public protocol MainDependency {
  func searchBuilder() -> ViewControllerBuildable
  func recentBuilder() -> ViewControllerBuildable
  func bookmarkBuilder() -> ViewControllerBuildable
  func settingsBuilder() -> ViewControllerBuildable
}

public protocol MainViewControllable: ViewControllable {
  func setTabs(search: ViewControllable, recent: ViewControllable, bookmark: ViewControllable, settings: ViewControllable)
}

public final class MainController: MainControllable, ViewControllerBuildable, SettingsListener {

  private let dependency: MainDependency
  weak var viewController: MainViewControllable?
  
  public init(dependency: MainDependency) {
    self.dependency = dependency
  }
  
  public func buildViewController() -> ViewControllable {
    let viewController = MainViewController(controller: self)
    self.viewController = viewController
    return viewController
  }
  
  public func activate() {
    self.viewController?.setTabs(
      search: self.dependency.searchBuilder().buildViewController(),
      recent: self.dependency.recentBuilder().buildViewController(),
      bookmark: self.dependency.bookmarkBuilder().buildViewController(),
      settings: self.dependency.settingsBuilder().buildViewController()
    )
  }
}

