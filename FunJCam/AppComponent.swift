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
SettingsDependency &
ImageViewerDependency

struct AppComponent: Dependencies {
  
  let searchProviderUsecase: SearchProviderUsecase
  let searchImageUsecase: SearchImageUsecase
  let recentImageUsecase: RecentImageUsecase
  let bookmarkImageUsecase: BookmarkImageUsecase
  
  func searchBuilder(listener: SearchListener?) -> ViewControllerBuildable {
    return SearchController(dependency: self, listener: listener)
  }
  
  func recentBuilder(listener: RecentListener?) -> RecentBuildable {
    return RecentBuilder(dependency: self, listener: listener)
  }
  
  func bookmarkBuilder(listener: BookmarkListener?) -> BookmarkBuildable {
    return BookmarkBuilder(dependency: self, listener: listener)
  }
  
  func settingsBuilder(listener: SettingsListener?) -> SettingsBuildable {
    return SettingsBuilder(dependency: self, listener: listener)
  }
  
  func imageViewerBuilder(listener: ImageViewerListener?) -> ImageViewerBuildable {
    return ImageViewerBuilder(dependency: self, listener: listener)
  }
  
  func shareBuilder() -> ShareBuildable {
    return ShareBuilder()
  }
  
  func alertBuilder() -> AlertBuildable {
    return AlertBuilder()
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
        recentImageUsecase: try RecentImageUsecaseImp(db: db),
        bookmarkImageUsecase: try BookmarkImageUsecaseImp(db: db)
      )
    } catch {
      fatalError(error.localizedDescription)
    }
  }
}
