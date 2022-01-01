public protocol MainDependency {
  func searchBuilder(listener: SearchListener?) -> SearchBuildable
  func recentBuilder(listener: RecentListener?) -> RecentBuildable
  func bookmarkBuilder(listener: BookmarkListener?) -> BookmarkBuildable
  func settingsBuilder(listener: SettingsListener?) -> SettingsBuildable
}

protocol MainViewControllable: ViewControllable {
  func setTabs(search: ViewControllable, recent: ViewControllable, bookmark: ViewControllable, settings: ViewControllable)
}

public final class MainController: MainControllable {

  private let dependency: MainDependency
  private weak var viewController: MainViewControllable?
  
  public init(dependency: MainDependency) {
    self.dependency = dependency
  }
  
  func activate(with viewControllable: MainViewControllable) {
    self.viewController = viewControllable
    self.viewController?.setTabs(
      search: self.dependency.searchBuilder(listener: nil).build(),
      recent: self.dependency.recentBuilder(listener: nil).build(),
      bookmark: self.dependency.bookmarkBuilder(listener: nil).build(),
      settings: self.dependency.settingsBuilder(listener: nil).build()
    )
  }
}

