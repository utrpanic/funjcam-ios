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
  
  func searchBuilder() -> Buildable {
    return SearchController(dependency: self)
  }
  
  func recentBuilder() -> Buildable {
    return RecentController(dependency: self)
  }
  
  func bookmarkBuilder() -> Buildable {
    return BookmarkController(dependency: self)
  }
  
  func settingsBuilder() -> Buildable {
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
