import Usecase
import Combine
import Entity
import SwiftUI

public protocol SearchDependency {
  var searchProviderUsecase: SearchProviderUsecase { get }
  var searchImageUsecase: SearchImageUsecase { get }
}

public protocol SearchListener: AnyObject {
  
}

public protocol SearchViewControllable: ViewControllable {
  
}

public final class SearchController: SearchControllable, ViewControllerBuildable {
  
  private let searchProviderUsecase: SearchProviderUsecase
  private let searchImageUsecase: SearchImageUsecase
  private let stateSubject: CurrentValueSubject<SearchState, Never>
  private var state: SearchState {
    get { self.stateSubject.value }
    set { self.stateSubject.send(newValue) }
  }
  
  private weak var viewController: SearchViewControllable?
  weak var listener: SearchListener?
  
  public init(dependency: SearchDependency, listener: SearchListener?) {
    self.searchProviderUsecase = dependency.searchProviderUsecase
    self.searchImageUsecase = dependency.searchImageUsecase
    let initialState = SearchState(provider: dependency.searchProviderUsecase.query())
    self.stateSubject = CurrentValueSubject(initialState)
    self.listener = listener
  }
  
  public func buildViewController() -> ViewControllable {
    let viewController = SearchViewController(controller: self)
    self.viewController = viewController
    return viewController
  }
  
  // MARK: - SearchControllable
  
  func activate(with viewController: SearchViewControllable) -> Observable<SearchState> {
    self.viewController = viewController
    return self.stateSubject.eraseToAnyPublisher()
  }
  
  func searchTapped() {
    Task { [weak self] in
      guard let self = self else { return }
      do {
        let result = try await self.searchImageUsecase.execute(
          query: self.state.query, next: nil, provider: self.state.provider
        )
        self.state.images = result.images
        self.state.next = result.next
      } catch {
        
      }
    }
  }
  
  func searchProviderChanged(to newValue: SearchProvider) {
    self.state.provider = newValue
    self.searchTapped()
  }
}

enum SearchError {
  case searchFailed
  case searchMoreFailed
}
