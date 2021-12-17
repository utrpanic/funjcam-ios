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

protocol SearchViewControllable: ViewControllable {
  
}

final class SearchController: SearchControllable {
  
  private let dependency: SearchDependency
  private let stateSubject: CurrentValueSubject<SearchState, Never>
  private let eventSubject: PassthroughSubject<SearchEvent, Never>
  private var state: SearchState {
    get { self.stateSubject.value }
    set { self.stateSubject.send(newValue) }
  }
  let observableState: ObservableState<SearchState>
  let observableEvent: ObservableEvent<SearchEvent>
  weak var viewController: SearchViewControllable?
  weak var listener: SearchListener?
  
  public init(dependency: SearchDependency) {
    self.dependency = dependency
    let initialState = SearchState(provider: dependency.searchProviderUsecase.query())
    self.stateSubject = CurrentValueSubject(initialState)
    self.eventSubject = PassthroughSubject()
    self.observableState = ObservableState(subject: self.stateSubject)
    self.observableEvent = ObservableEvent(subject: self.eventSubject)
  }
  
  private func routeToImageViewer(image: SearchedImage) {
    let builder = self.dependency.imageViewerBuilder(listener: nil)
    let target = builder.build(searchedImage: image)
    self.viewController?.present(viewControllable: target, animated: true, completion: nil)
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
    self.routeToImageViewer(image: image)
  }
  
  private func search() async throws {
    do {
      let usecase = self.dependency.searchImageUsecase
      let result = try await usecase.execute(
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
      let usecase = self.dependency.searchImageUsecase
      let result = try await usecase.execute(
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
