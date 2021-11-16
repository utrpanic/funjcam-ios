import UIKit
import Domain
import Application
import UserDefaults
import UserDefaultsImp
import Usecase
import UsecaseImp
import HTTPNetworkImp

typealias Dependencies =
MainDependency &
SearchDependency &
RecentDependency &
BookmarkDependency &
SettingsDependency

final class AppComponent: Dependencies {
  
  let searchProviderUsecase: SearchProviderUsecase
  let searchImageUsecase: SearchImageUsecase
  
  init(
    searchProviderUsecase: SearchProviderUsecase,
    searchImageUsecase: SearchImageUsecase
  ) {
    self.searchProviderUsecase = searchProviderUsecase
    self.searchImageUsecase = searchImageUsecase
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
    let network = HTTPNetworkImp(session: URLSession.shared)
    return AppComponent(
      searchProviderUsecase: SearchProviderUsecaseImp(userDefaults: userDefaults),
      searchImageUsecase: SearchImageUsecaseImp(network: network)
    )
  }
}
