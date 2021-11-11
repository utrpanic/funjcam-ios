import Entity
import Usecase

public final class SearchProviderUsecaseMock: SearchProviderUsecase {
  
  public var searchProvider: SearchProvider
  
  public init(searchProvider: SearchProvider) {
    self.searchProvider = searchProvider
  }
  
  public func query() -> SearchProvider {
    return self.searchProvider
  }
  
  public func mutate(_ newValue: SearchProvider) {
    self.searchProvider = newValue
  }
}
