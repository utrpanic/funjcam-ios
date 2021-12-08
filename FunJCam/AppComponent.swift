import UIKit
import Application
import HTTPNetworkImp
import SQLite
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
  let searchImageUsecase: SearchImageUsecase
  let recentImageUsecase: RecentImageUsecase
  
  init(
    searchProviderUsecase: SearchProviderUsecase,
    searchImageUsecase: SearchImageUsecase,
    recentImageUsecase: RecentImageUsecase
  ) {
    self.searchProviderUsecase = searchProviderUsecase
    self.searchImageUsecase = searchImageUsecase
    self.recentImageUsecase = recentImageUsecase
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
    do {
      let userDefaults = UserDefaults.standard
      let network = HTTPNetworkImp(session: URLSession.shared)
      let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
      let db = try Connection("\(path)/db.sqlite3")
      return AppComponent(
        searchProviderUsecase: SearchProviderUsecaseImp(userDefaults: userDefaults),
        searchImageUsecase: SearchImageUsecaseImp(network: network),
        recentImageUsecase: try RecentImageUsecaseImp(db: db)
      )
    } catch {
      fatalError(error.localizedDescription)
    }
  }
}
