public protocol MainDependency {
  func searchBuilder(listener: SearchListener?) -> ViewControllerBuildable
  func recentBuilder(listener: RecentListener?) -> ViewControllerBuildable
  func bookmarkBuilder(listener: BookmarkListener?) -> ViewControllerBuildable
  func settingsBuilder(listener: SettingsListener?) -> ViewControllerBuildable
}

protocol MainViewControllable: ViewControllable {
  func setTabs(search: ViewControllable, recent: ViewControllable, bookmark: ViewControllable, settings: ViewControllable)
}

public final class MainController: MainControllable, ViewControllerBuildable, SettingsListener {

  private let dependency: MainDependency
  weak var viewController: MainViewControllable?
  
  public init(dependency: MainDependency) {
    self.dependency = dependency
  }
  
  public func buildViewController() -> ViewControllable {
    return MainViewController(controller: self)
  }
  
  func activate(with viewController: MainViewControllable) {
    self.viewController = viewController
    self.viewController?.setTabs(
      search: self.dependency.searchBuilder(listener: nil).buildViewController(),
      recent: self.dependency.recentBuilder(listener: nil).buildViewController(),
      bookmark: self.dependency.bookmarkBuilder(listener: nil).buildViewController(),
      settings: self.dependency.settingsBuilder(listener: nil).buildViewController()
    )
  }
}

