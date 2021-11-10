import UIKit
import Domain
import Application
import UserDefaults
import UserDefaultsImp
import Usecase
import UsecaseImp

typealias Dependencies =
MainDependency &
SearchDependency &
RecentDependency &
BookmarkDependency &
SettingsDependency

final class AppComponent: Dependencies {
  
  let searchProviderUsecase: SearchProviderUsecase
  
  init(
    searchProviderUsecase: SearchProviderUsecase
  ) {
    self.searchProviderUsecase = searchProviderUsecase
  }
  
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

extension AppComponent {
  static var app: AppComponent {
    let userDefaults = UserDefaults.standard
    return AppComponent(
      searchProviderUsecase: SearchProviderUsecaseImp(userDefaults: userDefaults)
    )
  }
}
