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
  
  func searchBuilder() -> ViewControllerBuildable {
    return SearchController(dependency: self)
  }
  
  func recentBuilder() -> ViewControllerBuildable {
    return RecentController(dependency: self)
  }
  
  func bookmarkBuilder() -> ViewControllerBuildable {
    return BookmarkController(dependency: self)
  }
  
  func settingsBuilder() -> ViewControllerBuildable {
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
