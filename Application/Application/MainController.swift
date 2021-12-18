public protocol MainDependency {
  func searchBuilder(listener: SearchListener?) -> SearchBuildable
  func recentBuilder(listener: RecentListener?) -> RecentBuildable
  func bookmarkBuilder(listener: BookmarkListener?) -> BookmarkBuildable
  func settingsBuilder(listener: SettingsListener?) -> SettingsBuildable
}

protocol MainViewControllable: ViewControllable {
  func setTabs(search: ViewControllable, recent: ViewControllable, bookmark: ViewControllable, settings: ViewControllable)
}

public final class MainController: MainControllable, ViewControllerBuildable, SettingsListener {

  private weak var viewController: MainViewControllable?
  
  private let searchBuilder: SearchBuildable
  private let recentBuilder: RecentBuildable
  private let bookmarkBuilder: BookmarkBuildable
  private let settingsBuilder: SettingsBuildable
  
  public init(dependency: MainDependency) {
    self.searchBuilder = dependency.searchBuilder(listener: nil)
    self.recentBuilder = dependency.recentBuilder(listener: nil)
    self.bookmarkBuilder = dependency.bookmarkBuilder(listener: nil)
    self.settingsBuilder = dependency.settingsBuilder(listener: nil)
  }
  
  public func buildViewController() -> ViewControllable {
    return MainViewController(controller: self)
  }
  
  func activate(with viewController: MainViewControllable) {
    self.viewController = viewController
    self.viewController?.setTabs(
      search: self.searchBuilder.build(),
      recent: self.recentBuilder.build(),
      bookmark: self.bookmarkBuilder.build(),
      settings: self.settingsBuilder.build()
    )
  }
}

