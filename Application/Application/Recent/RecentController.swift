import Entity
import Usecase
import Combine

protocol RecentViewControllable: ViewControllable {
  
}

enum RecentState {
  case state([RecentImage])
}

final class RecentController: RecentControllable {
  
  private let state: CurrentValueSubject<RecentState, Never>
  
  private let recentImageUsecase: RecentImageUsecase
  
  private weak var viewController: RecentViewControllable?
  private weak var listener: RecentListener?
  
  init(dependency: RecentDependency, listener: RecentListener?) {
    self.state = CurrentValueSubject(.state([]))
    self.recentImageUsecase = dependency.recentImageUsecase
    self.listener = listener
    self.requestRecentImages()
  }
  
  func activate(with viewController: RecentViewControllable) -> Observable<RecentState> {
    self.viewController = viewController
    return self.state.eraseToAnyPublisher()
  }
  
  private func requestRecentImages() {
    do {
      let recentImages = try self.recentImageUsecase.query()
      self.state.send(.state(recentImages))
    } catch {
      
    }
  }
  
  func handleSelectImage(at index: Int) {
    
  }
}
