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
  
  func searchBuilder(listener: SearchListener?) -> ViewControllerBuildable {
    return SearchController(dependency: self, listener: listener)
  }
  
  func recentBuilder(listener: RecentListener?) -> ViewControllerBuildable {
    return RecentController(dependency: self, listener: listener)
  }
  
  func bookmarkBuilder(listener: BookmarkListener?) -> ViewControllerBuildable {
    return BookmarkController(dependency: self, listener: listener)
  }
  
  func settingsBuilder(listener: SettingsListener?) -> ViewControllerBuildable {
    return SettingsController(dependency: self, listener: listener)
  }
}

extension AppComponent {
  static var live: AppComponent {
    let userDefaults = UserDefaults.standard
    return AppComponent(
      searchProviderUsecase: SearchProviderUsecaseImp(userDefaults: userDefaults)
    )
  }
}
