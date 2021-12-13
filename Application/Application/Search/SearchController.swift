import Usecase
import BoxKit
import Combine
import Entity
import SwiftUI

public protocol SearchDependency {
  var searchProviderUsecase: SearchProviderUsecase { get }
  var searchImageUsecase: SearchImageUsecase { get }
  func imageViewerBuilder(listener: ImageViewerListener?) -> ImageViewerBuildable
}

public protocol SearchListener: AnyObject {
  
}

public protocol SearchViewControllable: ViewControllable {
  
}

public final class SearchController: SearchControllable, ViewControllerBuildable {
  
  private let searchProviderUsecase: SearchProviderUsecase
  private let searchImageUsecase: SearchImageUsecase
  private let imageViewerBuilder: ImageViewerBuildable
  
  private var state: SearchState {
    didSet { self.viewState.send(.stateArrived(self.state)) }
  }
  private let viewState: PassthroughSubject<SearchViewState, Never>
  
  private weak var viewController: SearchViewControllable?
  weak var listener: SearchListener?
  
  public init(dependency: SearchDependency, listener: SearchListener?) {
    self.searchProviderUsecase = dependency.searchProviderUsecase
    self.searchImageUsecase = dependency.searchImageUsecase
    self.imageViewerBuilder = dependency.imageViewerBuilder(listener: nil)
    self.state = SearchState(provider: dependency.searchProviderUsecase.query())
    self.viewState = PassthroughSubject()
    self.listener = listener
  }
  
  public func buildViewController() -> ViewControllable {
    let viewController = SearchViewController(initialState: self.state, controller: self)
    self.viewController = viewController
    return viewController
  }
  
  // MARK: - SearchControllable
  
  func activate(with viewController: SearchViewControllable) -> Observable<SearchViewState> {
    self.viewController = viewController
    return self.viewState.eraseToAnyPublisher()
  }
  
  func handleUpdateQuery(_ query: String?) {
    guard let query = query else { return }
    self.state.query = query
  }
  
  func handleSearch(query: String?) {
    guard let query = query, query.hasElement else { return }
    self.state.query = query
    Task { [weak self] in
      self?.viewState.send(.loading(true))
      do {
        try await self?.search()
      } catch {
        self?.viewState.send(.errorArrived(.search(error)))
      }
      self?.viewState.send(.loading(false))
    }
  }
  
  func handleSearchMore() {
    Task { [weak self] in
      do {
        try await self?.searchMore()
      } catch {
        self?.viewState.send(.errorArrived(.searchMore(error)))
      }
    }
  }
  
  func handleToggleGIF() {
    self.state.searchAnimatedGIF.toggle()
    Task { [weak self] in
      self?.viewState.send(.loading(true))
      do {
        try await self?.search()
      } catch {
        self?.viewState.send(.errorArrived(.search(error)))
      }
      self?.viewState.send(.loading(false))
    }
  }
  
  func handleChangeSearchProvider(to newValue: SearchProvider) {
    self.state.provider = newValue
    Task { [weak self] in
      self?.viewState.send(.loading(true))
      do {
        try await self?.search()
      } catch {
        self?.viewState.send(.errorArrived(.search(error)))
      }
      self?.viewState.send(.loading(false))
    }
  }
  
  func handleSelectImage(at index: Int) {
    let image = self.state.images[index]
    let target = self.imageViewerBuilder.build(searchedImage: image)
    self.viewController?.present(viewControllable: target, animated: true, completion: nil)
  }
  
  private func search() async throws {
    do {
      let result = try await self.searchImageUsecase.execute(
        query: self.adjustedSearchQuery(),
        next: nil,
        provider: self.state.provider
      )
      self.state.images = result.images
      self.state.next = result.next
    } catch {
      if let error = error as? DecodingError {
        print("❌ \(error.debugDescription)")
      } else {
        print("❌ \(error.localizedDescription)")
      }
      throw error
    }
  }
  
  private func searchMore() async throws {
    guard let next = self.state.next else { return }
    do {
      let result = try await self.searchImageUsecase.execute(
        query: self.adjustedSearchQuery(),
        next: next,
        provider: self.state.provider
      )
      self.state.images.append(contentsOf: result.images)
      self.state.next = result.next
    } catch {
      if let error = error as? DecodingError {
        print("❌ \(error.debugDescription)")
      } else {
        print("❌ \(error.localizedDescription)")
      }
      throw error
    }
  }
  
  private func adjustedSearchQuery() -> String {
    var query = self.state.query
    if self.state.searchAnimatedGIF {
      query.append(contentsOf: " \(Resource.string("search:gif"))")
    }
    return query
  }
}
