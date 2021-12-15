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
  var observableState: Observable<RecentState> { self.state.eraseToAnyPublisher() }
  weak var viewController: RecentViewControllable?
  private weak var listener: RecentListener?
  
  private let recentImageUsecase: RecentImageUsecase
  
  init(dependency: RecentDependency, listener: RecentListener?) {
    self.state = CurrentValueSubject(.state([]))
    self.recentImageUsecase = dependency.recentImageUsecase
    self.listener = listener
    self.requestRecentImages()
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
