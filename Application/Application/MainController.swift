public protocol MainDependency {
  func searchBuilder(listener: SearchListener?) -> ViewControllerBuildable
  func recentBuilder(listener: RecentListener?) -> RecentBuildable
  func bookmarkBuilder(listener: BookmarkListener?) -> ViewControllerBuildable
  func settingsBuilder(listener: SettingsListener?) -> ViewControllerBuildable
}

protocol MainViewControllable: ViewControllable {
  func setTabs(search: ViewControllable, recent: ViewControllable, bookmark: ViewControllable, settings: ViewControllable)
}

public final class MainController: MainControllable, ViewControllerBuildable, SettingsListener {

  private let dependency: MainDependency
  private let recentBuilder: RecentBuildable
  private weak var viewController: MainViewControllable?
  
  public init(dependency: MainDependency) {
    self.dependency = dependency
    self.recentBuilder = dependency.recentBuilder(listener: nil)
  }
  
  public func buildViewController() -> ViewControllable {
    return MainViewController(controller: self)
  }
  
  func activate(with viewController: MainViewControllable) {
    self.viewController = viewController
    self.viewController?.setTabs(
      search: self.dependency.searchBuilder(listener: nil).buildViewController(),
      recent: self.recentBuilder.build(),
      bookmark: self.dependency.bookmarkBuilder(listener: nil).buildViewController(),
      settings: self.dependency.settingsBuilder(listener: nil).buildViewController()
    )
  }
}

