import Entity

public protocol SearchProviderUsecase {
  func query() -> SearchProvider
  func mutate(_ newValue: SearchProvider)
}
