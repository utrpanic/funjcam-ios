import Usecase
import Combine
import SwiftUI

public protocol SearchDependency {
  var searchProviderUsecase: SearchProviderUsecase { get }
}

public protocol SearchListener: AnyObject {
  
}

public protocol SearchViewControllable: ViewControllable {
  
}

public final class SearchController: SearchControllable, ViewControllerBuildable {
  
  private let dependency: SearchDependency
  private let state: CurrentValueSubject<SearchState, Never>
  
  private weak var viewController: SearchViewControllable?
  weak var listener: SearchListener?
  
  public init(dependency: SearchDependency, listener: SearchListener?) {
    self.dependency = dependency
    let initialState = SearchState(provider: self.dependency.searchProviderUsecase.query())
    self.state = CurrentValueSubject(initialState)
    self.listener = listener
  }
  
  public func buildViewController() -> ViewControllable {
    let viewController = SearchViewController(controller: self)
    self.viewController = viewController
    return viewController
  }
  
  public func activate(with viewController: SearchViewControllable) -> Observable<SearchState> {
    self.viewController = viewController
    return self.state.eraseToAnyPublisher()
  }
}

enum SearchError {
  case searchFailed
  case searchMoreFailed
}
