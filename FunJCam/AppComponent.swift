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
  let daumImageUsecase: DaumImageUsecase
  let googleImageUsecase: GoogleImageUsecase
  let naverImageUsecase: NaverImageUsecase
  
  init(
    searchProviderUsecase: SearchProviderUsecase,
    daumImageUsecase: DaumImageUsecase,
    googleImageUsecase: GoogleImageUsecase,
    naverImageUsecase: NaverImageUsecase
  ) {
    self.searchProviderUsecase = searchProviderUsecase
    self.daumImageUsecase = daumImageUsecase
    self.googleImageUsecase = googleImageUsecase
    self.naverImageUsecase = naverImageUsecase
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
      daumImageUsecase: DaumImageUsecaseImp(network: network),
      googleImageUsecase: GoogleImageUsecaseImp(network: network),
      naverImageUsecase: NaverImageUsecaseImp(network: network)
    )
  }
}
