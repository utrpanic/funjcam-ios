import Usecase
import BoxKit
import Combine
import Entity
import SwiftUI

protocol SearchViewControllable: ViewControllable {
  
}

final class SearchController: SearchControllable {
  
  private let searchProviderUsecase: SearchProviderUsecase
  private let searchImageUsecase: SearchImageUsecase
  private let imageViewerBuilder: ImageViewerBuildable
  
  private let stateSubject: CurrentValueSubject<SearchState, Never>
  private var state: SearchState {
    get { self.stateSubject.value }
    set { self.stateSubject.send(newValue) }
  }
  let observableState: ObservableState<SearchState>
  private let eventSubject: PassthroughSubject<SearchEvent, Never>
  let observableEvent: ObservableEvent<SearchEvent>
  weak var viewController: SearchViewControllable?
  private weak var listener: SearchListener?
  
  public init(dependency: SearchDependency, listener: SearchListener?) {
    self.searchProviderUsecase = dependency.searchProviderUsecase
    self.searchImageUsecase = dependency.searchImageUsecase
    self.imageViewerBuilder = dependency.imageViewerBuilder(listener: nil)
    let initialState = SearchState(provider: dependency.searchProviderUsecase.query())
    self.stateSubject = CurrentValueSubject(initialState)
    self.observableState = ObservableState(subject: self.stateSubject)
    self.eventSubject = PassthroughSubject()
    self.observableEvent = ObservableEvent(subject: self.eventSubject)
    self.listener = listener
  }
  
  // MARK: - SearchControllable
  
  func handleUpdateQuery(_ query: String?) {
    guard let query = query else { return }
    self.state.query = query
  }
  
  func handleSearch(query: String?) {
    guard let query = query, query.hasElement else { return }
    self.state.query = query
    Task { [weak self] in
      self?.eventSubject.send(.loading(true))
      do {
        try await self?.search()
      } catch {
        self?.eventSubject.send(.errorSearch(error))
      }
      self?.eventSubject.send(.loading(false))
    }
  }
  
  func handleSearchMore() {
    Task { [weak self] in
      do {
        try await self?.searchMore()
      } catch {
        self?.eventSubject.send(.errorSearchMore(error))
      }
    }
  }
  
  func handleToggleGIF() {
    self.state.searchAnimatedGIF.toggle()
    Task { [weak self] in
      self?.eventSubject.send(.loading(true))
      do {
        try await self?.search()
      } catch {
        self?.eventSubject.send(.errorSearch(error))
      }
      self?.eventSubject.send(.loading(false))
    }
  }
  
  func handleChangeSearchProvider(to newValue: SearchProvider) {
    self.state.provider = newValue
    Task { [weak self] in
      self?.eventSubject.send(.loading(true))
      do {
        try await self?.search()
      } catch {
        self?.eventSubject.send(.errorSearch(error))
      }
      self?.eventSubject.send(.loading(false))
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
