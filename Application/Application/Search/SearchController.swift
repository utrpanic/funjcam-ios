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

public final class SearchController: SearchControllable, Buildable {
  
  private let searchProviderUsecase: SearchProviderUsecase
  
  private let state: CurrentValueSubject<SearchState, Never>
  public let observableState: AnyPublisher<SearchState, Never>
  
  private weak var viewController: SearchViewControllable?
  weak var listener: SearchListener?
  
  public init(dependency: SearchDependency) {
    self.searchProviderUsecase = dependency.searchProviderUsecase
    let initialState = SearchState(provider: self.searchProviderUsecase.query())
    self.state = CurrentValueSubject(initialState)
    self.observableState = self.state.eraseToAnyPublisher()
  }
  
  public func createViewController() -> ViewControllable {
    let viewController = SearchViewController(controller: self)
    self.viewController = viewController
    return viewController
  }
}

public enum SearchError {
  case searchFailed
  case searchMoreFailed
}
