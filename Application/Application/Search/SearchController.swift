import Usecase
import Combine
import SwiftUI

public protocol SearchDependency {
  var searchProviderUsecase: SearchProviderUsecase { get }
  var daumImageUsecase: DaumImageUsecase { get }
  var googleImageUsecase: GoogleImageUsecase { get }
  var naverImageUsecase: NaverImageUsecase { get }
}

public protocol SearchListener: AnyObject {
  
}

public protocol SearchViewControllable: ViewControllable {
  
}

public final class SearchController: SearchControllable, ViewControllerBuildable {
  
  private let searchProviderUsecase: SearchProviderUsecase
  private let daumImageUsecase: DaumImageUsecase
  private let googleImageUsecase: GoogleImageUsecase
  private let naverImageUsecase: NaverImageUsecase
  private let stateSubject: CurrentValueSubject<SearchState, Never>
  private var state: SearchState {
    get { self.stateSubject.value }
    set { self.stateSubject.send(newValue) }
  }
  
  private weak var viewController: SearchViewControllable?
  weak var listener: SearchListener?
  
  public init(dependency: SearchDependency, listener: SearchListener?) {
    self.searchProviderUsecase = dependency.searchProviderUsecase
    self.daumImageUsecase = dependency.daumImageUsecase
    self.googleImageUsecase = dependency.googleImageUsecase
    self.naverImageUsecase = dependency.naverImageUsecase
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
  
  public func activate(with viewController: SearchViewControllable) -> Observable<SearchState> {
    self.viewController = viewController
    return self.stateSubject.eraseToAnyPublisher()
  }
  
  public func searchTapped() {
    Task { [weak self] in
      guard let self = self else { return }
      do {
        switch self.state.provider {
        case .daum:
          let result = try await self.daumImageUsecase.search(query: self.state.query, next: nil)
          self.state.images = result.searchedImages
          self.state.next = result.next
        case .google:
          let result = try await self.googleImageUsecase.search(query: self.state.query, next: nil)
          self.state.images = result.searchedImages
          self.state.next = result.next
        case .naver:
          let result = try await self.naverImageUsecase.search(query: self.state.query, next: nil)
          self.state.images = result.searchedImages
          self.state.next = result.next
        }
      } catch {
        
      }
    }
  }
}

enum SearchError {
  case searchFailed
  case searchMoreFailed
}
