import Usecase

public protocol SearchDependency {
  var searchProviderUsecase: SearchProviderUsecase { get }
}

public protocol SearchListener: AnyObject {
  
}

public protocol SearchViewControllable: ViewControllable {
  
}

public final class SearchController: SearchControllable {
  
  private let searchProviderUsecase: SearchProviderUsecase
  
  private var state: SearchState
  
  private weak var viewController: SearchViewControllable?
  weak var listener: SearchListener?
  
  public init(dependency: SearchDependency) {
    self.searchProviderUsecase = dependency.searchProviderUsecase
    self.state = SearchState(provider: self.searchProviderUsecase.query())
  }
  
  public func createViewController() -> ViewControllable {
    let viewController = SearchViewController(controller: self)
    self.viewController = viewController
    return viewController
  }
}
