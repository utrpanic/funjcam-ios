import UIKit
import Application

typealias Dependencies =
MainDependency &
SearchDependency &
RecentDependency &
BookmarkDependency &
SettingsDependency

final class AppComponent: Dependencies {
  
  func searchController() -> SearchControllable {
    return SearchController(dependency: self)
  }
  
  func recentController() -> RecentControllable {
    return RecentController(dependency: self)
  }
  
  func bookmarkController() -> BookmarkControllable {
    return BookmarkController(dependency: self)
  }
  
  func settingsController() -> SettingsControllable {
    return SettingsController(dependency: self)
  }
}
