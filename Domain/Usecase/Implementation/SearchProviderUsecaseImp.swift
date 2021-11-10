import Entity
import Usecase
import UserDefaults

public final class SearchProviderUsecaseImp: SearchProviderUsecase {
  
  private let userDefaults: UserDefaultsProtocol
  
  public init(userDefaults: UserDefaultsProtocol) {
    self.userDefaults = userDefaults
  }
  
  public func query() -> SearchProvider {
    let rawValue = self.userDefaults.string(forKey: "SearchProviderRawValue")
    return SearchProvider(rawValue: rawValue ?? "") ?? .google
  }
  
  public func mutate(_ newValue: SearchProvider) {
    self.userDefaults.set(newValue.rawValue, forKey: "SearchProviderRawValue")
  }
}
